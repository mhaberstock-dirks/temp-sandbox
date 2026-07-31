create or replace 
package DIRKSPZM32.PZM_P_LC is

  -- Author  : WKROEKER
  -- Created : 26.01.2026 12:25:01
  -- Purpose : PZM related language and error constants
  
  
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
  PZM_EXCEPT_PERS_NR_404          Exception;
  PZM_EXCEPT_RFID_PERS_NR_404     Exception; -- Personalnummer zur RFID nicht gefunden
  PZM_EXCEPT_ABT_ID_404           Exception; -- Abteilungs-ID nicht gefunden
  PZM_EXCEPT_SA_KURZNAME_404      Exception; -- Schichtart-Kurzname nicht gefunden
  PZM_EXCEPT_KST_ID_404           Exception; -- Kostenstelle nicht gefunden

  PZM_EXCEPT_BUCHUNG              Exception; -- generischer Buchungsfehler, Fallback fuer beliebige nicht spezifische Fehler

  PZM_EXCEPT_ZE_KEINE_OFFENE_VORH Exception; -- Fehler beim Schliessen einer Stempelzeit, da keine offene ZE-Buchung vorhanden ist.
  PZM_EXCEPT_ZE_STATUS_MISMATCH   Exception; -- Fehler beim Schliessen einer Stempelzeit, da der Status (der geschlossen werden soll) nicht uebereinstimmt.
  PZM_EXCEPT_ZE_BEREITS_OFFEN     Exception; -- Fehler beim (erneuten) Oeffnen einer Stempelzeit am selben Schichttag, wenn bereits eine Offene vorh. ist.
  PZM_EXCEPT_ZE_DATEN_INVALID     Exception; -- Fehler beim verbuchen einer Stempelzeit, da die erforderlichen (Stamm-)Daten fehlen oder ungueltig sind.
  PZM_EXCEPT_ZE_GEHEN_OHNE_KOMMEN Exception; -- Fehler beim Buchen einer Stempelzeit, da ein Gehen ohne vorheriges Kommen versucht wurde.
  PZM_EXCEPT_ZE_TAGESAUSWERTUNG   Exception; -- Fehler beim Aktualisieren der Tagesauswertung nach Stempelzeitbuchung.

  PZM_EXCEPT_ZE_KST_CHANGE_DENIED Exception; -- Fehler, das Wechseln der Kostenstelle ist dem Benutzer nicht erlaubt 
  PZM_EXCEPT_ZE_EMPLOYEE_ABSENT   Exception; -- Fehler, Wechseln Kostenstelle nur erlaubt, wenn anwesend 
  
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_PERS_NR_404         ,  -20001);
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_RFID_PERS_NR_404     , -20002); -- Personalnummer zur RFID nicht gefunden
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_ABT_ID_404           , -20004); -- Abteilungs-ID nicht gefunden
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_SA_KURZNAME_404      , -20005); -- Schichtart-Kurzname nicht gefunden
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_KST_ID_404           , -20006); -- Kostenstelle nicht gefunden

  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_BUCHUNG              , -20010); -- generischer Buchungsfehler, Fallback fuer beliebige nicht spezifische Fehler

  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_ZE_KEINE_OFFENE_VORH , -20020); -- Fehler beim Schliessen einer Stempelzeit, da keine offene ZE-Buchung vorhanden ist.
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_ZE_STATUS_MISMATCH   , -20025); -- Fehler beim Schliessen einer Stempelzeit, da der Status (der geschlossen werden soll) nicht uebereinstimmt.
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_ZE_BEREITS_OFFEN     , -20030); -- Fehler beim (erneuten) Oeffnen einer Stempelzeit am selben Schichttag, wenn bereits eine Offene vorh. ist.
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_ZE_DATEN_INVALID     , -20035); -- Fehler beim verbuchen einer Stempelzeit, da die erforderlichen (Stamm-)Daten fehlen oder ungueltig sind.
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_ZE_GEHEN_OHNE_KOMMEN , -20040); -- Fehler beim Buchen einer Stempelzeit, da ein Gehen ohne vorheriges Kommen versucht wurde.
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_ZE_TAGESAUSWERTUNG   , -20045); -- Fehler beim Aktualisieren der Tagesauswertung nach Stempelzeitbuchung.

  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_ZE_KST_CHANGE_DENIED , -20050); -- Fehler, das Wechseln der Kostenstelle ist dem Benutzer nicht erlaubt  
  PRAGMA EXCEPTION_INIT (PZM_EXCEPT_ZE_EMPLOYEE_ABSENT   , -20051); -- Fehler, Wechseln Kostenstelle nur erlaubt, wenn anwesend   

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
   * @param in_code     Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_message  Nutzer-/Domaenenfreundlicher Text
   */
  procedure raise_app_error(
    in_code     in pls_integer,
    in_message  in varchar2
  );

  /**
   * Wirft einen Anwendungsfehler mit kombinierten 
   * Errorkonstante-Parameter-Text aus Errorkonstante mit 1 Parameter und optionalem zweiten Parameter
   *
   * @param in_code         Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_const_name   vordefinierter, konstanter Fehlerschlüssel (referenziert R3LangConstMapper.cs)
   * @param in_p1           Parameter, der in finalem Fehlertext ergänzt wird
   * @param in_p2           optionaler Parameter, der in finalem Fehlertext ergänzt wird (falls gefüllt)
   *
   */
  procedure raise_app_error_p(
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_p1         in varchar2,
    in_p2         in varchar2 default null
  );

  /**
   * Wirft einen Anwendungsfehler mit kombinierten 
   * Errorkonstante-Parameter-Text aus Errorkonstante mit 1 Parameter und optionalem zweiten Parameter
   *
   * @param in_code         Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_const_name   vordefinierter, konstanter Fehlerschlüssel (referenziert R3LangConstMapper.cs)
   * @param in_p1           Parameter, der in finalem Fehlertext ergänzt wird
   * @param in_p2           optionaler Parameter, der in finalem Fehlertext ergänzt wird (falls gefüllt)
   *
   */
  procedure raise_app_error_p(
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



-- sqlcl_snapshot {"hash":"7463885803aff2d9acd0f35188530a75cb980698","type":"PACKAGE_SPEC","name":"PZM_P_LC","schemaName":"DIRKSPZM32","sxml":""}