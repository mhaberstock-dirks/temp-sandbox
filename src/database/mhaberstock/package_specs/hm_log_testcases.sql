create or replace
package MHABERSTOCK.HM_LOG_TESTCASES as
  -----------------------------------------------------------------------------------------------
  -- Package: hm_log_testcases
  -- Zweck:   Testfaelle fuer das Exception-Handling von PZM_P_LC und PZM_P_LOG,
  --          insbesondere im Zusammenspiel mit autonomen Transaktionen (PRAGMA AUTONOMOUS_TRANSACTION).
  -- Autor:   M.Haberstock, W24120-648
  -- Datum:   2026-07
  --
  -- HINTERGRUND:
  --   PZM_P_LOG.write_to_table() schreibt ueber eine autonome Transaktion in PZM_LOG, damit
  --   Log-Eintraege einen ROLLBACK der Haupttransaktion "ueberleben". Autonome Transaktionen
  --   haben aber eigene Fallstricke (fehlender COMMIT, Self-Deadlock bei Zugriff auf von der
  --   Haupttransaktion gesperrte Zeilen/Tabellen). Dieses Package macht diese Fallstricke gezielt
  --   reproduzierbar und prueft, wie PZM_P_LC / PZM_P_LOG sich dabei verhalten.
  --
  --   AKTUELLE METHODIK (Stand W24120-648):
  --     - PZM_P_LC.raise_app_error()/raise_app_error_p() protokollieren jetzt SELBST per
  --       pzm_p_log.log_data() (Call-Stack via DBMS_UTILITY.FORMAT_CALL_STACK), BEVOR sie
  --       RAISE_APPLICATION_ERROR ausfuehren. PZM-Anwendungsfehler landen damit automatisch und
  --       vollstaendig in PZM_LOG - unabhaengig davon, ob die aufrufende Prozedur ueberhaupt
  --       einen eigenen Exception-Handler besitzt.
  --     - Oeffentliche Exception-Handler folgen deshalb dem Muster:
  --         EXCEPTION WHEN OTHERS THEN
  --           IF NOT pzm_p_lc.is_app_code(SQLCODE) THEN pzm_p_log.log_exception(...); END IF;
  --           RAISE;
  --       Das vermeidet Doppel-Logging fuer PZM-Codes (die bereits beim Werfen geloggt wurden)
  --       und garantiert trotzdem lueckenlose Protokollierung echter Systemfehler.
  --     - PZM_P_LC.catch_and_rethrow() wurde ersatzlos entfernt: Weder PZM- noch Systemfehler
  --       werden mehr umgeschrieben/gewrappt - der Aufrufer sieht immer den tatsaechlichen,
  --       unveraenderten SQLCODE/SQLERRM.
  --
  -- VORSICHT:
  --   - Die Tests fuehren bewusst eigene COMMIT/ROLLBACK-Operationen aus (u.a. um Sperren wieder
  --     freizugeben). Nicht in eine laufende Anwendungs-/Nutztransaktion eingebettet aufrufen,
  --     sondern isoliert in einer Test-/Dev-Session.
  --   - test_pzm_log_swallows_write_error() und test_pattern_loses_everything_when_pzm_log_locked()
  --     sperren PZM_LOG kurzzeitig mit LOCK TABLE ... EXCLUSIVE und warten auf die
  --     Self-Deadlock-Erkennung von Oracle (typischerweise wenige Sekunden). Nicht gegen eine
  --     produktiv genutzte Instanz laufen lassen.
  --   - Nutzt bei Bedarf die Tabelle HM_AT_TEST_LOG sowie HM_PKG_AT_TEST/HM_PRC_AT_TEST als
  --     Referenzimplementierung fuer "sauberes" autonomes Transaktionsverhalten.
  --   - Alle Test-Marker sind mit dem Praefix 'HMTC_' versehen, damit cleanup_test_data() auch
  --     die automatischen Log-Eintraege aus raise_app_error()/raise_app_error_p() findet, die
  --     KEIN log_module tragen (die generische Bibliotheksfunktion kennt den Namen der
  --     aufrufenden Prozedur nicht).
  --
  -- Aufruf:
  --   exec hm_log_testcases.run_all;
  --   exec hm_log_testcases.cleanup_test_data;   -- entfernt in PZM_LOG hinterlassene Testzeilen
  -----------------------------------------------------------------------------------------------

  /** Fuehrt alle Testfaelle nacheinander aus und gibt eine PASS/FAIL-Zusammenfassung aus. */
  procedure run_all;

  /** Entfernt alle von diesem Package in PZM_LOG hinterlassenen Testzeilen. */
  procedure cleanup_test_data;

  -----------------------------------------------------------------------------------------------
  -- Autonome Transaktionen: fehlender COMMIT / Self-Deadlock
  -----------------------------------------------------------------------------------------------

  /**
   * Ruft eine autonome Prozedur auf, die nach einem INSERT weder COMMIT noch ROLLBACK ausfuehrt.
   * Erwartung: Oracle bricht die autonome Transaktion beim Verlassen selbst ab und wirft
   * ORA-06519 (aktive autonome Transaktion erkannt und zurueckgesetzt). Da ORA-06519 erst BEIM
   * RUECKSPRUNG aus der autonomen Prozedur entsteht, kann nur der Aufrufer das protokollieren.
   */
  procedure test_at_missing_commit;

  /**
   * Legt in der Haupttransaktion eine Zeile an (committet, dann gesperrt) und ruft danach eine
   * autonome Prozedur auf, die genau diese Zeile aendern will.
   * Erwartung: ORA-00060 (Deadlock), da dieselbe Session sich selbst blockiert.
   */
  procedure test_at_self_deadlock_on_locked_row;

  -----------------------------------------------------------------------------------------------
  -- PZM_P_LOG: Verhalten bei Schreibfehlern in der autonomen Log-Transaktion
  -----------------------------------------------------------------------------------------------

  /**
   * Sperrt PZM_LOG exklusiv und ruft anschliessend PZM_P_LOG.error() auf.
   * Erwartung: PZM_P_LOG.error() wirft KEINE Exception, der Log-Eintrag geht aber verloren
   * (write_to_table() faengt den Self-Deadlock intern per "WHEN OTHERS THEN ROLLBACK" ab).
   */
  procedure test_pzm_log_swallows_write_error;

  -----------------------------------------------------------------------------------------------
  -- PZM_P_LC: raise_app_error()/raise_app_error_p() protokollieren jetzt selbst VOR dem Werfen
  -----------------------------------------------------------------------------------------------

  /** is_app_code() klassifiziert -20000..-20999 korrekt als PZM-Anwendungsfehler, sonst nicht. */
  procedure test_pzm_lc_is_app_code;

  /** raise_app_error() protokolliert automatisch (Level ERROR, korrekter Code, Call-Stack) VOR dem Werfen. */
  procedure test_pzm_lc_raise_app_error_logs_automatically;

  /** raise_app_error_p() mit 1 Parameter protokolliert automatisch das TOKEN@[p1]-Format. */
  procedure test_pzm_lc_raise_app_error_p1_logs_automatically;

  /** raise_app_error_p() mit 2 Parametern protokolliert automatisch das TOKEN@[p1|p2]-Format. */
  procedure test_pzm_lc_raise_app_error_p2_logs_automatically;

  /** raise_app_error_p() mit PZM_P_LC.T_PARAMLIST (beliebig viele Parameter) protokolliert automatisch. */
  procedure test_pzm_lc_raise_app_error_plist_logs_automatically;

  /** assert() mit erfuellter Bedingung ist ein reiner No-Op: keine Exception, kein PZM_LOG-Eintrag. */
  procedure test_pzm_lc_assert_condition_true_no_op;

  /**
   * assert() mit verletzter Bedingung wirft ueber raise_app_error_p() und protokolliert
   * automatisch - identisches Verhalten zu test_pzm_lc_raise_app_error_p1_logs_automatically,
   * nur ueber den lesbareren assert()-Aufruf statt eines expliziten IF-Blocks.
   */
  procedure test_pzm_lc_assert_condition_false_raises_and_logs;

  -----------------------------------------------------------------------------------------------
  -- CURRENT_UNIT_NAME(): UTL_CALL_STACK-basierte Ermittlung des Modulnamens statt Literal
  -----------------------------------------------------------------------------------------------

  /** Direkter Aufruf liefert den Namen der aufrufenden Prozedur selbst. */
  procedure test_current_unit_name_direct_call;

  /**
   * Das eigentliche Einsatzmuster: c_module_name constant varchar2(50) := current_unit_name();
   * in der Deklarationssektion. Prueft in zwei Prozeduren UND einer Funktion, dass jede den
   * eigenen Namen erhaelt (nicht den des Aufrufers und nicht den einer anderen).
   */
  procedure test_current_unit_name_via_declare_constant;

  /**
   * Referenz: c_module_name als p_module an pzm_p_log.log_exception() uebergeben - zeigt, dass
   * der ermittelte Name genauso funktioniert wie bisher ein manuell eingetipptes Literal.
   */
  procedure test_current_unit_name_in_log_module;

  -----------------------------------------------------------------------------------------------
  -- Zusammenspiel PZM_P_LC + PZM_P_LOG
  -----------------------------------------------------------------------------------------------

  /** PZM_P_LOG.log_exception() persistiert Fehlercode und Meldung einer zuvor gefangenen Exception. */
  procedure test_pzm_log_log_exception_captures_context;

  -----------------------------------------------------------------------------------------------
  -- Handler-Muster wie jetzt in PZM_P_ZEITERFASSUNG umgesetzt:
  --   EXCEPTION WHEN OTHERS THEN
  --     IF NOT pzm_p_lc.is_app_code(sqlcode) THEN pzm_p_log.log_exception(...); END IF;
  --     RAISE;
  -----------------------------------------------------------------------------------------------

  /**
   * Ein bereits vorhandener PZM-Anwendungsfehler durchlaeuft das Muster.
   * Erwartung: GENAU EIN PZM_LOG-Eintrag (automatisch durch raise_app_error() selbst) - der
   * Handler-Guard verhindert einen zweiten, redundanten Eintrag. Code bleibt fuer den Aufrufer
   * unveraendert.
   */
  procedure test_pattern_preserves_app_error;

  /**
   * Ein echter Systemfehler (ORA-01476) durchlaeuft das Muster.
   * Erwartung: GENAU EIN PZM_LOG-Eintrag (durch den Handler-Guard, da raise_app_error() hier nie
   * aufgerufen wurde). Der Aufrufer sieht den ORIGINAL-Fehler unveraendert - kein Wrapping mehr,
   * da catch_and_rethrow() entfernt wurde.
   */
  procedure test_pattern_propagates_system_error_unwrapped;

  /**
   * Eine verschachtelte autonome Prozedur "vergisst" COMMIT/ROLLBACK.
   * Erwartung: ORA-06519 wird vom AEUSSEREN Handler korrekt geloggt und UNVERAENDERT (nicht
   * gewrappt) an den Aufrufer weitergereicht.
   */
  procedure test_pattern_captures_missing_commit;

  /**
   * Eine verschachtelte autonome Prozedur kollidiert mit einer von der Haupttransaktion
   * gehaltenen Sperre.
   * Erwartung: ORA-00060 wird korrekt geloggt und unveraendert weitergereicht.
   */
  procedure test_pattern_captures_self_deadlock;

  /**
   * Setzt vorher pzm_p_log.set_log_level() ueber LEVEL_ERROR hinaus und durchlaeuft dann das
   * Muster mit einem App-Fehler.
   * Erwartung: Weder der automatische Log-Aufruf in raise_app_error() noch der Handler-Guard
   * schreiben eine Zeile in PZM_LOG. Setzt die Log-Schwelle danach garantiert zurueck (auch im
   * Fehlerfall).
   */
  procedure test_pattern_swallowed_when_log_level_raised;

  -----------------------------------------------------------------------------------------------
  -- Vollstaendigkeit der Protokollierung: verbleibende Luecken und Referenzverhalten
  -----------------------------------------------------------------------------------------------

  /**
   * KRITISCHE LUECKE (weiterhin vorhanden in PZM_P_LOG.log_exception()): Ein echter Systemfehler
   * aus ca. 120 Rekursionsebenen erzeugt einen dbms_utility.format_error_backtrace()-String
   * > 4000 Zeichen. Da is_app_code() fuer diesen Fehler FALSE liefert, ruft der Handler-Guard
   * log_exception() tatsaechlich auf - dort wirft die Zuweisung an v_stacktrace VARCHAR2(4000)
   * selbst ORA-06502, BEVOR der Log-Eintrag geschrieben wird. Weder Originalfehler noch Hinweis
   * landen in PZM_LOG.
   */
  procedure test_pattern_loses_everything_on_deep_backtrace;

  /**
   * REFERENZ (kein Fehlerfall): raise_app_error()/raise_app_error_p() kennen aktuell KEINE
   * PZM-Kontextparameter (pers_nr/ze_id/schicht_tag) - der automatische Log-Eintrag enthaelt sie
   * daher nie. Wer diesen Kontext dennoch protokollieren will, muss zusaetzlich manuell
   * pzm_p_log.log_exception() mit den entsprechenden Parametern aufrufen (wie hier demonstriert) -
   * das erzeugt bewusst einen ZWEITEN, ergaenzenden PZM_LOG-Eintrag neben dem automatischen.
   */
  procedure test_pattern_full_context_is_captured;

  /**
   * WEITERE LUECKE: Kombiniert das Handler-Muster mit einer exklusiv gesperrten PZM_LOG-Tabelle.
   * Erwartung: Der Aufrufer bekommt ganz regulaer den (unveraenderten) Fehlercode zurueck - sieht
   * also aus wie ordnungsgemaess behandelt -, aber PZM_LOG enthaelt dazu KEINE Zeile: weder vom
   * automatischen Log in raise_app_error() (durch die Sperre verschluckt) noch vom Handler-Guard
   * (is_app_code = TRUE, also ohnehin uebersprungen).
   */
  procedure test_pattern_loses_everything_when_pzm_log_locked;

end HM_LOG_TESTCASES;
/
