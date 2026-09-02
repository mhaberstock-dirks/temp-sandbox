create or replace 
package PZM_P_LC is

  -- Author  : WKROEKER
  -- Created : 26.01.2026 12:25:01
  -- Purpose : PZM related language and error constants
  --
  -- VERANTWORTUNGSTEILUNG PZM_P_LC <-> PZM_P_LOG:
  -- PZM_P_LC ist zustaendig fuer das WIE und WANN einer Anwendungsexception: Fehlercode-/
  -- Message-Katalog (cerr_*, O_T*-Konstanten), das Werfen (raise_app_error/raise_app_error_p/
  -- assert) sowie die Garantie, dass dabei einmalig automatisch vorprotokolliert wird, bevor
  -- die Exception den Aufrufer erreicht (log_before_raise -> pzm_p_log.log_data).
  -- PZM_P_LOG ist zustaendig fuer das WIE und WO der eigentlichen Protokollierung: Schreiben in
  -- Tabelle/Session-Puffer, Level-Filterung (g_table_log_level), sowie die vollstaendige
  -- Aufbereitung echter (nicht ueber PZM_P_LC geworfener) Systemfehler inkl. Backtrace
  -- (log_exception -> dbms_utility.format_error_backtrace).
  -- PZM_P_LC persistiert selbst nichts - jeder Schreibzugriff auf PZM_LOG laeuft ueber PZM_P_LOG.


  /**
   * Type-Definitionen
   */

  -- Type für Parameter-Listen, um variable Anzahl Parameter zur ermöglichen
  type t_paramlist is table of varchar2(4000);


  /**---------------------------------------------------------------------------------------------
    * Exception-Definitionen
    * Je Exception werden 3-n Definitionen benötigt:
    * - Exception,                   (für RAISE und EXCEPTION WHEN)
    * - Pragma Exception_Init,       (verbindet Exception mit sqlcode)
    * - Konstante mit dem Fehlercode (für Raise_AppLication_Error)
    * - optionale Konstanten für PZM-Fehler-Messages (ggf. mehrere Varianten)
    * --------------------------------------------------------------------------------------------
    *
    * HINWEIS zu den "excp_*"-Exceptions (EXCEPTION + PRAGMA EXCEPTION_INIT):
    * Aktuell nirgends aktiv genutzt (verifiziert per Referenzsuche im gesamten Schema) - weder per
    * "RAISE excp_..." geworfen, noch per "WHEN excp_... THEN" gefangen. Geworfen wird ausschliesslich
    * ueber die numerischen cerr_*-Konstanten via raise_app_error()/raise_app_error_p()/assert();
    * is_app_code() prueft ebenfalls gegen die cerr_*-Konstanten, nicht gegen diese Exceptions.
    *
    * Die excp_*-Exceptions bleiben trotzdem bewusst deklariert, weil sie einen alternativen,
    * nativen PL/SQL-Weg der Fehlerbehandlung ermoeglichen wuerden:
    *   - Vorteil: Typsicheres Fangen einzelner Fehler ohne SQLCODE-Zahlenwerte im Code,
    *     z.B. "WHEN excp_pzm_abt_id_404 THEN ..." oder kombiniert "WHEN excp_a OR excp_b THEN ...",
    *     inkl. Tippfehler-Erkennung durch den Compiler statt stiller Fehlklassifikation.
    *   - Nachteil 1: Ein blankes "RAISE excp_pzm_xxx;" traegt KEINEN eigenen, parametrisierten
    *     Meldungstext - eine aussagekraeftige Meldung entsteht erst, wenn zuvor (z.B. ueber
    *     raise_app_error_p()) RAISE_APPLICATION_ERROR mit Code+Text aufgerufen wurde. Die
    *     Exceptions koennen also raise_app_error*() nicht ersetzen, sondern hoechstens ergaenzen.
    *   - Nachteil 2: Ein per "WHEN excp_x THEN" gefangener Fehler haengt nicht automatisch am
    *     Logging-Mechanismus (log_before_raise/is_app_code) - jeder so gebaute Handler muesste sich
    *     wieder selbst um vollstaendige Protokollierung kuemmern, was genau die Garantie unterlaeuft,
    *     die mit dem generischen "WHEN OTHERS"-Muster in PZM_P_ZEITERFASSUNG erreicht wurde.
    * Dies ist daher eine bewusste, dokumentierte Entscheidung gegen die Nutzung - kein vergessenes
    * Aufraeumen. Vor einer etwaigen Wiederverwendung sollte das Team die beiden Nachteile bewerten.
   */

  -- Personalnummer nicht gefunden:
  excp_pzm_pers_nr_404             EXCEPTION;  PRAGMA EXCEPTION_INIT ( 
  excp_pzm_pers_nr_404                                               , -20001);
  cerr_pzm_pers_nr_404             CONSTANT PLS_INTEGER              := -20001;  
   O_TP1_PZM_ERROR_PERS_NR_404     constant varchar2(50 char) := 
  'O_TP1_PZM_ERROR_PERS_NR_404'; -- Personalnummer <%1> nicht gefunden!

  -- Personalnummer zur RFID nicht gefunden
  excp_pzm_rfid_pers_nr_404         EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_rfid_pers_nr_404                                           , -20002);
  cerr_pzm_rfid_pers_nr_404         CONSTANT PLS_INTEGER              := -20002;
   O_TP1_PZM_ERROR_RFID_PERS_NR_404 constant varchar2(50 char) := 
  'O_TP1_PZM_ERROR_RFID_PERS_NR_404'; -- Personalnummer zur RFID <%1> nicht gefunden!

  -- Abteilungs-ID nicht gefunden
  excp_pzm_abt_id_404               EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_abt_id_404                                                 , -20003);
  cerr_pzm_abt_id_404               CONSTANT PLS_INTEGER              := -20003;
   O_TP1_PZM_ERROR_ABT_ID_404       constant varchar2(50 char) := 
  'O_TP1_PZM_ERROR_ABT_ID_404'; -- Abteilungs-ID <%1> nicht gefunden!

  -- Schichtart-Kurzname nicht gefunden
  excp_sa_kurzname_404              EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_sa_kurzname_404                                                , -20004);
  cerr_sa_kurzname_404              CONSTANT PLS_INTEGER             := -20004;
   O_TP1_PZM_ERROR_SA_KURZNAME_404  constant varchar2(50 char) := 
  'O_TP1_PZM_ERROR_SA_KURZNAME_404'; -- Schichtart-Kurzname <%1> nicht gefunden

  -- Kostenstelle nicht gefunden
  excp_kst_id_404                   EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_kst_id_404                                                     , -20005);
  cerr_kst_id_404                   CONSTANT PLS_INTEGER             := -20005;
   O_TP1_PZM_ERROR_KST_ID_404       constant varchar2(50 char) := 
  'O_TP1_PZM_ERROR_KST_ID_404'; -- Kostenstelle <%1> nicht gefunden

  -- generischer Buchungsfehler, Fallback fuer beliebige nicht spezifische Fehler
  excp_pzm_buchung                  EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_buchung                                                    , -20010);
  cerr_pzm_buchung                  CONSTANT PLS_INTEGER             := -20010;
   O_T_PZM_ERROR_BUCHUNG            constant varchar2(50 char) := 
  'O_T_PZM_ERROR_BUCHUNG';          -- Es ist ein Buchungsfehler in der PZM-Zeiterfassung aufgetreten!

  -- Fehler beim Schliessen einer Stempelzeit, da keine offene ZE-Buchung vorhanden ist.
  excp_pzm_ze_keine_offene_vorh         EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_ze_keine_offene_vorh                                           , -20020);
  cerr_pzm_ze_keine_offene_vorh         CONSTANT PLS_INTEGER             := -20020;
   O_T_PZM_ERROR_ZE_INVALID_NO_START_TIME constant varchar2(50 char) := 
  'O_T_PZM_ERROR_ZE_INVALID_NO_START_TIME'; -- FEHLER: Eintrag ohne Startzeit nicht erlaubt!

  -- Fehler beim Schliessen einer Stempelzeit, da der Status (der geschlossen werden soll) nicht uebereinstimmt. 
  excp_pzm_ze_status_mismatch    EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_ze_status_mismatch                                      , -20025);
  cerr_pzm_ze_status_mismatch    CONSTANT PLS_INTEGER             := -20025;
   O_TP2_PZM_ERROR_ZE_STATUS_MISMATCH constant varchar2(50 char) := 
  'O_TP2_PZM_ERROR_ZE_STATUS_MISMATCH'; -- FEHLER: Stempelzeit (ID: <%1>) kann nicht mit Aktion <%2> geschlossen werden!

  -- Fehler beim (erneuten) Oeffnen einer Stempelzeit am selben Schichttag, wenn bereits eine Offene vorh. ist. 
  excp_pzm_ze_bereits_offen      EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_ze_bereits_offen                                        , -20030);
  cerr_pzm_ze_bereits_offen      CONSTANT PLS_INTEGER             := -20030;
   O_TP1_PZM_ERROR_ZE_BEREITS_OFFEN constant varchar2(50 char) := 
  'O_TP1_PZM_ERROR_ZE_BEREITS_OFFEN'; -- WARNUNG: Eine offene Stempelzeit (ID: <%1>) ist vorhanden - Buchung ignoriert.

  -- Fehler beim verbuchen einer Stempelzeit, da die erforderlichen (Stamm-)Daten fehlen oder ungueltig sind.  
  excp_pzm_ze_daten_invalid      EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_ze_daten_invalid                                        , -20035);
  cerr_pzm_ze_daten_invalid      CONSTANT PLS_INTEGER             := -20035;
   O_T_PZM_ERROR_ZE_INVALID_NO_PERS_NR constant varchar2(50 char) := 
  'O_T_PZM_ERROR_ZE_INVALID_NO_PERS_NR'; -- FEHLER: Eintrag ohne gueltige Personalnummer nicht moeglich
   O_T_PZM_ERROR_ZE_INVALID_NO_TIMESTAMP constant varchar2(50 char) := 
  'O_T_PZM_ERROR_ZE_INVALID_NO_TIMESTAMP'; -- FEHLER: Eintrag ohne gueltigen Zeitstempel nicht moeglich
   O_T_PZM_ERROR_ZE_INVALID_NO_AKTION constant varchar2(50 char) := 
  'O_T_PZM_ERROR_ZE_INVALID_NO_AKTION'; -- FEHLER: Eintrag ohne gueltige Aktion (Kommen/Gehen) nicht moeglich
   O_T_PZM_ERROR_ZE_INVALID_TIMESTAMP_IN_FUTURE constant varchar2(50 char) := 
  'O_T_PZM_ERROR_ZE_INVALID_TIMESTAMP_IN_FUTURE'; -- FEHLER: Eintrag mit Zeitstempel in der Zukunft nicht erlaubt

  -- Fehler beim Buchen einer Stempelzeit, da ein Gehen ohne vorheriges Kommen versucht wurde. 
  excp_pzm_ze_gehen_ohne_kommen  EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_ze_gehen_ohne_kommen                                    , -20040);
  cerr_pzm_ze_gehen_ohne_kommen  CONSTANT PLS_INTEGER             := -20040;
   O_TP2_PZM_ERROR_ZE_GEHEN_OHNE_KOMMEN constant varchar2(50 char) := 
  'O_TP2_PZM_ERROR_ZE_GEHEN_OHNE_KOMMEN'; -- FEHLER: Gehen ohne Kommen am Schichttag <%1> - Buchung abgelehnt. Terminal: <%2>

  -- Fehler beim Aktualisieren der Tagesauswertung nach Stempelzeitbuchung.  
  excp_pzm_ze_tagesauswertung    EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_ze_tagesauswertung                                      , -20045);
  cerr_pzm_ze_tagesauswertung    CONSTANT PLS_INTEGER             := -20045;
   O_TP1_PZM_ERROR_ZE_EINTRAG_404 constant varchar2(50 char) := 
  'O_TP1_PZM_ERROR_ZE_EINTRAG_404'; -- Zeiterfassungseintrag (ZE_ID: <%1>) nicht gefunden!

  -- Fehler, das Wechseln der Kostenstelle ist dem Benutzer nicht erlaubt.   
  excp_pzm_ze_kst_change_denied  EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_ze_kst_change_denied                                    , -20050);
  cerr_pzm_ze_kst_change_denied  CONSTANT PLS_INTEGER             := -20050;
   O_TP1_PZM_ERROR_ZE_KST_CHANGE_DENIED constant varchar2(50 char) := 
  'O_T_PZM_EXCEPT_ZE_KST_CHANGE_DENIED'; -- Fehler, das Wechseln der Kostenstelle ist dem Benutzer <%1> nicht erlaubt  

  -- Fehler, Wechseln Kostenstelle nur erlaubt, wenn anwesend. PZM_EXCEPT_ZE_employee_absent   Exception;  
  excp_pzm_ze_employee_absent    EXCEPTION;  PRAGMA EXCEPTION_INIT (
  excp_pzm_ze_employee_absent                                      , -20051);
  cerr_pzm_ze_employee_absent    CONSTANT PLS_INTEGER             := -20051;
   O_TP1_PZM_ERROR_ZE_EMPLOYEE_ABSENT constant varchar2(50 char) := 
  'O_TP1_PZM_ERROR_ZE_EMPLOYEE_ABSENT'; -- Fehler, Wechseln Kostenstelle nur erlaubt, wenn Benutzer <%1> anwesend 

/*
  -----------------------------------------------------------------------------------------------
  -- Konstanten: PZM-Fehler-Codes fuer das ORA-20xxx Exception-Handling
  -----------------------------------------------------------------------------------------------
  PZM_ERROR_PERS_NR_404 constant pls_integer           := -20001;
  PZM_ERROR_RFID_PERS_NR_404     constant pls_integer := -20002; -- Personalnummer zur RFID nicht gefunden
  PZM_ERROR_ABT_ID_404           constant pls_integer := -20004; -- Abteilungs-ID nicht gefunden
  PZM_ERROR_SA_KURZNAME_404      constant pls_integer := -20005; -- Schichtart-Kurzname nicht gefunden
  PZM_ERROR_KST_ID_404           constant pls_integer := -20006; -- Kostenstelle nicht gefunden

  PZM_ERROR_BUCHUNG              constant pls_integer := -20010; -- generischer Buchungsfehler, Fallback fuer beliebige nicht spezifische Fehler

  PZM_ERROR_ZE_KEINE_OFFENE_VORH constant pls_integer := -20020; -- Fehler beim Schliessen einer Stempelzeit, da keine offene ZE-Buchung vorhanden ist.
  PZM_ERROR_ZE_STATUS_MISMATCH   constant pls_integer := -20025; -- Fehler beim Schliessen einer Stempelzeit, da der Status (der geschlossen werden soll) nicht uebereinstimmt.
  PZM_ERROR_ZE_BEREITS_OFFEN     constant pls_integer := -20030; -- Fehler beim (erneuten) Oeffnen einer Stempelzeit am selben Schichttag, wenn bereits eine Offene vorh. ist.
  PZM_ERROR_ZE_DATEN_INVALID     constant pls_integer := -20035; -- Fehler beim verbuchen einer Stempelzeit, da die erforderlichen (Stamm-)Daten fehlen oder ungueltig sind.
  PZM_ERROR_ZE_GEHEN_OHNE_KOMMEN constant pls_integer := -20040; -- Fehler beim Buchen einer Stempelzeit, da ein Gehen ohne vorheriges Kommen versucht wurde.
  PZM_ERROR_ZE_TAGESAUSWERTUNG   constant pls_integer := -20045; -- Fehler beim Aktualisieren der Tagesauswertung nach Stempelzeitbuchung.

  -----------------------------------------------------------------------------------------------
  -- Konstanten: PZM-Fehler-Messages fuer das ORA-20xxx Exception-Handling
  -----------------------------------------------------------------------------------------------
*/

  -----------------------------------------------------------------------------------------------
  -- OEFFENTLICHE API: Factory-Methoden fuer Error-Messages mit Parameter-Details
  -----------------------------------------------------------------------------------------------

  /**
   * Prueft, ob der uebergebene Code ein PZM-Anwendungsfehler ist (-20999..-20000).
   * raise_app_error()/raise_app_error_p() protokollieren bereits VOR dem Werfen - oeffentliche
   * Exception-Handler sollten daher nur dann zusaetzlich pzm_p_log.log_exception() aufrufen,
   * wenn is_app_code(sqlcode) = FALSE ist (echter, nicht vorab protokollierter Systemfehler),
   * um Doppel-Eintraege in PZM_LOG zu vermeiden.
   */
  function is_app_code(p_code in pls_integer) return boolean;

  /**
   * Wirft einen Anwendungsfehler.
   *
   * @param in_code            Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_message         Nutzer-/Domaenenfreundlicher Text
   * @param in_already_logged  Bestaetigt, dass der Aufrufer den Fehler bereits selbst (mit eigenem,
   *                           reichhaltigerem Kontext) in PZM_LOG protokolliert hat. In diesem Fall
   *                           unterbleibt die automatische, generische Vor-Protokollierung, um einen
   *                           doppelten PZM_LOG-Eintrag zu vermeiden. Default FALSE: Wird der Parameter
   *                           nicht gesetzt, greift die automatische Protokollierung wie gewohnt -
   *                           im schlimmsten Fall entsteht dadurch ein ueberflüssiger, aber niemals ein
   *                           fehlender Log-Eintrag.
   */
  procedure raise_app_error(
    in_code            in pls_integer,
    in_message         in varchar2,
    in_already_logged  in boolean default false
  );

  /**
   * Wirft einen Anwendungsfehler mit kombinierten
   * Errorkonstante-Parameter-Text aus Errorkonstante mit 1 Parameter und optionalem zweiten Parameter
   *
   * @param in_code            Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_const_name      vordefinierter, konstanter Fehlerschlüssel (referenziert R3LangConstMapper.cs)
   * @param in_p1              Parameter, der in finalem Fehlertext ergänzt wird
   * @param in_p2              optionaler Parameter, der in finalem Fehlertext ergänzt wird (falls gefüllt)
   * @param in_already_logged  siehe raise_app_error()
   *
   */
  procedure raise_app_error_p(
    in_code            in pls_integer,
    in_const_name      in varchar2,
    in_p1              in varchar2,
    in_p2              in varchar2 default null,
    in_already_logged  in boolean default false
  );

  /**
   * Wirft einen Anwendungsfehler mit kombinierten
   * Errorkonstante-Parameter-Text aus Errorkonstante mit 1 Parameter und optionalem zweiten Parameter
   *
   * @param in_code            Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_const_name      vordefinierter, konstanter Fehlerschlüssel (referenziert R3LangConstMapper.cs)
   * @param in_plist           Liste beliebig vieler Parameter, die in finalem Fehlertext ergänzt werden
   * @param in_already_logged  siehe raise_app_error()
   *
   */
  procedure raise_app_error_p(
    in_code            in pls_integer,
    in_const_name      in varchar2,
    in_plist           in t_paramlist,
    in_already_logged  in boolean default false
  );

  /**
   * Prueft eine beliebige Bedingung und wirft bei Verletzung einen Anwendungsfehler mit einem
   * einfachen Freitext - lesbarerer Ersatz fuer "IF NOT <Bedingung> THEN raise_app_error(...);
   * END IF;"-Bloecke. Drei Varianten, analog zu raise_app_error()/raise_app_error_p().
   * Deckt sowohl Eingabe-/Geschaeftsregel-Validierungen (Bedingung durch den Aufrufer verletzbar)
   * als auch interne Zustands-Assertions (Bedingung sollte bei korrekter Programmlogik nie
   * verletzt werden) gleichermassen ab - die Unterscheidung ergibt sich allein aus dem gewaehlten
   * Fehlercode/der Fehlermeldung an der Aufrufstelle, nicht aus unterschiedlicher Infrastruktur.
   *
   * Bewusst OHNE "in_already_logged"-Parameter (anders als raise_app_error*()): Wer vor dem Fehler
   * noch manuell reichhaltiger protokollieren will, braucht ohnehin ein eigenes IF-Konstrukt fuer
   * den log_data()-Aufruf - dann kann direkt raise_app_error*() mit in_already_logged verwendet
   * werden. assert() ist gerade fuer den Fall gedacht, in dem KEIN eigenes IF noetig ist.
   *
   * @param in_condition  Bedingung, die erfuellt sein muss. Bei FALSE wird der Fehler geworfen.
   * @param in_code       Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_message    Nutzer-/Domaenenfreundlicher Text
   */
  procedure assert(
    in_condition in boolean,
    in_code      in pls_integer,
    in_message   in varchar2
  );

  /**
   * Wie assert(), aber mit kombiniertem Errorkonstante-Parameter-Text aus Errorkonstante mit
   * 1 Parameter und optionalem zweiten Parameter (siehe raise_app_error_p()).
   *
   * @param in_condition   Bedingung, die erfuellt sein muss. Bei FALSE wird der Fehler geworfen.
   * @param in_code        Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_const_name  vordefinierter, konstanter Fehlerschlüssel (referenziert R3LangConstMapper.cs)
   * @param in_p1          Parameter, der in finalem Fehlertext ergänzt wird
   * @param in_p2          optionaler Parameter, der in finalem Fehlertext ergänzt wird (falls gefüllt)
   */
  procedure assert(
    in_condition  in boolean,
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_p1         in varchar2,
    in_p2         in varchar2 default null
  );

  /**
   * Wie assert(), aber mit kombiniertem Errorkonstante-Parameter-Text aus einer beliebig langen
   * Parameter-Liste (siehe raise_app_error_p()).
   *
   * @param in_condition   Bedingung, die erfuellt sein muss. Bei FALSE wird der Fehler geworfen.
   * @param in_code        Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_const_name  vordefinierter, konstanter Fehlerschlüssel (referenziert R3LangConstMapper.cs)
   * @param in_plist       Liste beliebig vieler Parameter, die in finalem Fehlertext ergänzt werden
   */
  procedure assert(
    in_condition  in boolean,
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_plist      in t_paramlist
  );


  /**
   * Wirft einen Anwendungsfehler mit kombinierten 
   * Errorkonstante-Parameter-Text aus Errorkonstante mit 1 Parameter
   *
   * @param in_code     Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
  procedure raise_app_error_p1(
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_p1         in varchar2
  );
   */

  /**
   * Wirft einen Anwendungsfehler mit kombinierten 
   * Errorkonstante-Parameter-Text aus Errorkonstante mit 2 Parametern
   *
   * @param in_code     Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
  procedure raise_app_error_p2(
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_p1         in varchar2,
    in_p2         in varchar2
  );
   */

  /**
   * Faengt OTHERS, baut eine konsistente Fehlermeldung und wirft sie erneut.
   * - Wenn bereits ein -20xxx-Fehler vorliegt, wird er (mit keep_errors) sauber weitergegeben
   *   und optional um Kontext ergaenzt.
   * - Sonst wird mit p_fallback_code gewrappt.
  procedure catch_and_rethrow(
    --in_location       in varchar2,                    -- z.B. 'ABSENCE_API.check_absence'
    in_fallback_code  in pls_integer default cerr_pzm_buchung,
    in_user_message   in varchar2    default null     -- optional zusaetzlicher Domaenentext
  );
   */

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 1 Parameter fuer 'raise_...' Aufrufe
  function create_p1(
    in_const_name in varchar2,
    in_p1 in varchar2
  ) return varchar2;
   */

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 2 Parametern fuer 'raise_...' Aufrufe
  function create_p2(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2
  ) return varchar2;
   */

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 3 Parametern fuer 'raise_...' Aufrufe
  function create_p3(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2,
    in_p3 in varchar2
  ) return varchar2;
   */

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 4 Parametern fuer 'raise_...' Aufrufe
  function create_p4(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2,
    in_p3 in varchar2,
    in_p4 in varchar2
  ) return varchar2;
   */

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 5 Parametern fuer 'raise_...' Aufrufe
  function create_p5(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2,
    in_p3 in varchar2,
    in_p4 in varchar2,
    in_p5 in varchar2
  ) return varchar2;
   */

end;
/



-- sqlcl_snapshot {"hash":"df1d11f16b53d8232d608e200da9146c826ca4c3","type":"PACKAGE_SPEC","name":"PZM_P_LC","schemaName":"DIRKSPZM32","sxml":""}