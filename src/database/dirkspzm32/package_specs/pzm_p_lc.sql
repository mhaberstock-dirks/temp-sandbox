create or replace 
package DIRKSPZM32.PZM_P_LC is

  -- Author  : WKROEKER
  -- Created : 26.01.2026 12:25:01
  -- Purpose : PZM related language and error constants

  -----------------------------------------------------------------------------------------------
  -- Konstanten: PZM-Fehler-Codes fuer das ORA-20xxx Exception-Handling
  -----------------------------------------------------------------------------------------------
  PZM_ERROR_PERS_NR_404 constant pls_integer := -20001; -- Personalnummer nicht gefunden
  PZM_ERROR_RFID_PERS_NR_404 constant pls_integer := -20002; -- Personalnummer zur RFID nicht gefunden
  PZM_ERROR_ABT_ID_404 constant pls_integer := -20004; -- Abteilungs-ID nicht gefunden
  PZM_ERROR_SA_KURZNAME_404 constant pls_integer := -20005; -- Schichtart-Kurzname nicht gefunden

  PZM_ERROR_BUCHUNG constant pls_integer := -20010; -- generischer Buchungsfehler, Fallback fuer beliebige nicht spezifische Fehler

  PZM_ERROR_ZE_KEINE_OFFENE_VORH constant pls_integer := -20020; -- Fehler beim Schliessen einer Stempelzeit, da keine offene ZE-Buchung vorhanden ist.
  PZM_ERROR_ZE_STATUS_MISMATCH   constant pls_integer := -20025; -- Fehler beim Schliessen einer Stempelzeit, da der Status (der geschlossen werden soll) nicht uebereinstimmt.
  PZM_ERROR_ZE_BEREITS_OFFEN     constant pls_integer := -20030; -- Fehler beim (erneuten) Oeffnen einer Stempelzeit am selben Schichttag, wenn bereits eine Offene vorh. ist.
  PZM_ERROR_ZE_DATEN_INVALID     constant pls_integer := -20035; -- Fehler beim verbuchen einer Stempelzeit, da die erforderlichen (Stamm-)Daten fehlen oder ungueltig sind.
  PZM_ERROR_ZE_GEHEN_OHNE_KOMMEN constant pls_integer := -20040; -- Fehler beim Buchen einer Stempelzeit, da ein Gehen ohne vorheriges Kommen versucht wurde.
  PZM_ERROR_ZE_TAGESAUSWERTUNG   constant pls_integer := -20045; -- Fehler beim Aktualisieren der Tagesauswertung nach Stempelzeitbuchung.

  -----------------------------------------------------------------------------------------------
  -- Konstanten: PZM-Fehler-Messages fuer das ORA-20xxx Exception-Handling
  -----------------------------------------------------------------------------------------------
  O_TP1_PZM_ERROR_PERS_NR_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_PERS_NR_404'; -- Personalnummer <%1> nicht gefunden!
  O_TP1_PZM_ERROR_RFID_PERS_NR_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_RFID_PERS_NR_404'; -- Personalnummer zur RFID <%1> nicht gefunden!
  O_TP1_PZM_ERROR_ABT_ID_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_ABT_ID_404'; -- Abteilungs-ID <%1> nicht gefunden!
  O_TP1_PZM_ERROR_SA_KURZNAME_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_SA_KURZNAME_404'; -- Schichtart-Kurzname <%1> nicht gefunden

  O_T_PZM_ERROR_BUCHUNG constant varchar2(50 char) := 'O_T_PZM_ERROR_BUCHUNG'; -- Es ist ein Buchungsfehler in der PZM-Zeiterfassung aufgetreten!
  O_T_PZM_ERROR_ZE_INVALID_NO_START_TIME constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_NO_START_TIME'; -- FEHLER: Eintrag ohne Startzeit nicht erlaubt!
  O_TP2_PZM_ERROR_ZE_STATUS_MISMATCH constant varchar2(50 char) := 'O_TP2_PZM_ERROR_ZE_STATUS_MISMATCH'; -- FEHLER: Stempelzeit (ID: <%1>) kann nicht mit Aktion <%2> geschlossen werden!
  O_TP2_PZM_ERROR_ZE_GEHEN_OHNE_KOMMEN constant varchar2(50 char) := 'O_TP2_PZM_ERROR_ZE_GEHEN_OHNE_KOMMEN'; -- FEHLER: Gehen ohne Kommen am Schichttag <%1> - Buchung abgelehnt. Terminal: <%2>
  O_TP1_PZM_ERROR_ZE_EINTRAG_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_ZE_EINTRAG_404'; -- Zeiterfassungseintrag (ZE_ID: <%1>) nicht gefunden!
  O_TP1_PZM_ERROR_ZE_BEREITS_OFFEN constant varchar2(50 char) := 'O_TP1_PZM_ERROR_ZE_BEREITS_OFFEN'; -- WARNUNG: Eine offene Stempelzeit (ID: <%1>) ist vorhanden - Buchung ignoriert.
  O_T_PZM_ERROR_ZE_INVALID_NO_PERS_NR constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_NO_PERS_NR'; -- FEHLER: Eintrag ohne gueltige Personalnummer nicht moeglich
  O_T_PZM_ERROR_ZE_INVALID_NO_TIMESTAMP constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_NO_TIMESTAMP'; -- FEHLER: Eintrag ohne gueltigen Zeitstempel nicht moeglich
  O_T_PZM_ERROR_ZE_INVALID_NO_AKTION constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_NO_AKTION'; -- FEHLER: Eintrag ohne gueltige Aktion (Kommen/Gehen) nicht moeglich
  O_T_PZM_ERROR_ZE_INVALID_TIMESTAMP_IN_FUTURE constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_TIMESTAMP_IN_FUTURE'; -- FEHLER: Eintrag mit Zeitstempel in der Zukunft nicht erlaubt

  -----------------------------------------------------------------------------------------------
  -- OEFFENTLICHE API: Factory-Methoden fuer Error-Messages mit Parameter-Details
  -----------------------------------------------------------------------------------------------

  /**
   * Wirft einen Anwendungsfehler.
   *
   * @param in_code     Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_message  Nutzer-/Domaenenfreundlicher Text
   */
  procedure raise_app_error(
    in_code     in pls_integer,
    in_message  in varchar2
  );

  /**
   * Wirft einen Anwendungsfehler mit kombinierten 
   * Errorkonstante-Parameter-Text aus Errorkonstante mit 1 Parameter
   *
   * @param in_code     Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   */
  procedure raise_app_error_p1(
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_p1         in varchar2
  );

  /**
   * Wirft einen Anwendungsfehler mit kombinierten 
   * Errorkonstante-Parameter-Text aus Errorkonstante mit 2 Parametern
   *
   * @param in_code     Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   */
  procedure raise_app_error_p2(
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_p1         in varchar2,
    in_p2         in varchar2
  );

  /**
   * Faengt OTHERS, baut eine konsistente Fehlermeldung und wirft sie erneut.
   * - Wenn bereits ein -20xxx-Fehler vorliegt, wird er (mit keep_errors) sauber weitergegeben
   *   und optional um Kontext ergaenzt.
   * - Sonst wird mit p_fallback_code gewrappt.
   */
  procedure catch_and_rethrow(
    in_location       in varchar2,                    -- z.B. 'ABSENCE_API.check_absence'
    in_fallback_code  in pls_integer default PZM_ERROR_BUCHUNG,
    in_user_message   in varchar2    default null     -- optional zusaetzlicher Domaenentext
  );

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 1 Parameter fuer 'raise_...' Aufrufe
   */
  function create_p1(
    in_const_name in varchar2,
    in_p1 in varchar2
  ) return varchar2;

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 2 Parametern fuer 'raise_...' Aufrufe
   */
  function create_p2(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2
  ) return varchar2;

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 3 Parametern fuer 'raise_...' Aufrufe
   */
  function create_p3(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2,
    in_p3 in varchar2
  ) return varchar2;

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 4 Parametern fuer 'raise_...' Aufrufe
   */
  function create_p4(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2,
    in_p3 in varchar2,
    in_p4 in varchar2
  ) return varchar2;

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 5 Parametern fuer 'raise_...' Aufrufe
   */
  function create_p5(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2,
    in_p3 in varchar2,
    in_p4 in varchar2,
    in_p5 in varchar2
  ) return varchar2;

end;
/



-- sqlcl_snapshot {"hash":"a3bca9703cb4c8f24d995e448837fc1bdb18749b","type":"PACKAGE_SPEC","name":"PZM_P_LC","schemaName":"DIRKSPZM32","sxml":""}