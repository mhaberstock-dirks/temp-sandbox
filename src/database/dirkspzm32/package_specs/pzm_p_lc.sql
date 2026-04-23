create or replace package dirkspzm32.pzm_p_lc is

  -- Author  : WKROEKER
  -- Created : 26.01.2026 12:25:01
  -- Purpose : PZM related language and error constants

  -----------------------------------------------------------------------------------------------
  -- Konstanten: PZM-Fehler-Codes fuer das ORA-20xxx Exception-Handling
  -----------------------------------------------------------------------------------------------
    pzm_error_pers_nr_404 constant pls_integer := -20001; -- Personalnummer nicht gefunden
    pzm_error_rfid_pers_nr_404 constant pls_integer := -20002; -- Personalnummer zur RFID nicht gefunden
    pzm_error_abt_id_404 constant pls_integer := -20004; -- Abteilungs-ID nicht gefunden
    pzm_error_sa_kurzname_404 constant pls_integer := -20005; -- Schichtart-Kurzname nicht gefunden

    pzm_error_buchung constant pls_integer := -20010; -- generischer Buchungsfehler, Fallback fuer beliebige nicht spezifische Fehler
    pzm_error_ze_keine_offene_vorh constant pls_integer := -20020; -- Fehler beim Schliessen einer Stempelzeit, da keine offene ZE-Buchung vorhanden ist.
    pzm_error_ze_status_mismatch constant pls_integer := -20025; -- Fehler beim Schliessen einer Stempelzeit, da der Status (der geschlossen werden soll) nicht uebereinstimmt.
    pzm_error_ze_bereits_offen constant pls_integer := -20030; -- Fehler beim (erneuten) Oeffnen einer Stempelzeit am selben Schichttag, wenn bereits eine Offene vorh. ist.
    pzm_error_ze_daten_invalid constant pls_integer := -20035; -- Fehler beim verbuchen einer Stempelzeit, da die erforderlichen (Stamm-)Daten fehlen oder ungueltig sind.
    pzm_error_ze_gehen_ohne_kommen constant pls_integer := -20040; -- Fehler beim Buchen einer Stempelzeit, da ein Gehen ohne vorheriges Kommen versucht wurde.
    pzm_error_ze_tagesauswertung constant pls_integer := -20045; -- Fehler beim Aktualisieren der Tagesauswertung nach Stempelzeitbuchung.

  -----------------------------------------------------------------------------------------------
  -- Konstanten: PZM-Fehler-Messages fuer das ORA-20xxx Exception-Handling
  -----------------------------------------------------------------------------------------------
    o_tp1_pzm_error_pers_nr_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_PERS_NR_404'; -- Personalnummer <%1> nicht gefunden!
    o_tp1_pzm_error_rfid_pers_nr_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_RFID_PERS_NR_404'; -- Personalnummer zur RFID <%1> nicht gefunden!
    o_tp1_pzm_error_abt_id_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_ABT_ID_404'; -- Abteilungs-ID <%1> nicht gefunden!
    o_tp1_pzm_error_sa_kurzname_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_SA_KURZNAME_404'; -- Schichtart-Kurzname <%1> nicht gefunden

    o_t_pzm_error_buchung constant varchar2(50 char) := 'O_T_PZM_ERROR_BUCHUNG'; -- Es ist ein Buchungsfehler in der PZM-Zeiterfassung aufgetreten!
    o_t_pzm_error_ze_invalid_no_start_time constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_NO_START_TIME'; -- FEHLER: Eintrag ohne Startzeit nicht erlaubt!
    o_tp2_pzm_error_ze_status_mismatch constant varchar2(50 char) := 'O_TP2_PZM_ERROR_ZE_STATUS_MISMATCH'; -- FEHLER: Stempelzeit (ID: <%1>) kann nicht mit Aktion <%2> geschlossen werden!
    o_tp2_pzm_error_ze_gehen_ohne_kommen constant varchar2(50 char) := 'O_TP2_PZM_ERROR_ZE_GEHEN_OHNE_KOMMEN'; -- FEHLER: Gehen ohne Kommen am Schichttag <%1> - Buchung abgelehnt. Terminal: <%2>
    o_tp1_pzm_error_ze_eintrag_404 constant varchar2(50 char) := 'O_TP1_PZM_ERROR_ZE_EINTRAG_404'; -- Zeiterfassungseintrag (ZE_ID: <%1>) nicht gefunden!
    o_tp1_pzm_error_ze_bereits_offen constant varchar2(50 char) := 'O_TP1_PZM_ERROR_ZE_BEREITS_OFFEN'; -- WARNUNG: Eine offene Stempelzeit (ID: <%1>) ist vorhanden - Buchung ignoriert.
    o_t_pzm_error_ze_invalid_no_pers_nr constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_NO_PERS_NR'; -- FEHLER: Eintrag ohne gueltige Personalnummer nicht moeglich
    o_t_pzm_error_ze_invalid_no_timestamp constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_NO_TIMESTAMP'; -- FEHLER: Eintrag ohne gueltigen Zeitstempel nicht moeglich
    o_t_pzm_error_ze_invalid_no_aktion constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_NO_AKTION'; -- FEHLER: Eintrag ohne gueltige Aktion (Kommen/Gehen) nicht moeglich
    o_t_pzm_error_ze_invalid_timestamp_in_future constant varchar2(50 char) := 'O_T_PZM_ERROR_ZE_INVALID_TIMESTAMP_IN_FUTURE'; -- FEHLER: Eintrag mit Zeitstempel in der Zukunft nicht erlaubt

  -----------------------------------------------------------------------------------------------
  -- OEFFENTLICHE API: Factory-Methoden fuer Error-Messages mit Parameter-Details
  -----------------------------------------------------------------------------------------------

  /**
   * Wirft einen Anwendungsfehler.
   *
   * @param in_code     Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   * @param in_message  Nutzer-/Domaenenfreundlicher Text
   */
    procedure raise_app_error (
        in_code    in pls_integer,
        in_message in varchar2
    );

  /**
   * Wirft einen Anwendungsfehler mit kombinierten 
   * Errorkonstante-Parameter-Text aus Errorkonstante mit 1 Parameter
   *
   * @param in_code     Eigener Code (-20xxx). Falls NULL, wird PZM_ERROR_BUCHUNG verwendet.
   */
    procedure raise_app_error_p1 (
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
    procedure raise_app_error_p2 (
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
    procedure catch_and_rethrow (
        in_location      in varchar2,                    -- z.B. 'ABSENCE_API.check_absence'
        in_fallback_code in pls_integer default pzm_error_buchung,
        in_user_message  in varchar2 default null     -- optional zusaetzlicher Domaenentext
    );

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 1 Parameter fuer 'raise_...' Aufrufe
   */
    function create_p1 (
        in_const_name in varchar2,
        in_p1         in varchar2
    ) return varchar2;

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 2 Parametern fuer 'raise_...' Aufrufe
   */
    function create_p2 (
        in_const_name in varchar2,
        in_p1         in varchar2,
        in_p2         in varchar2
    ) return varchar2;

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 3 Parametern fuer 'raise_...' Aufrufe
   */
    function create_p3 (
        in_const_name in varchar2,
        in_p1         in varchar2,
        in_p2         in varchar2,
        in_p3         in varchar2
    ) return varchar2;

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 4 Parametern fuer 'raise_...' Aufrufe
   */
    function create_p4 (
        in_const_name in varchar2,
        in_p1         in varchar2,
        in_p2         in varchar2,
        in_p3         in varchar2,
        in_p4         in varchar2
    ) return varchar2;

  /**
   * Baut einen kombinierten Errorkonstante-Parameter-Text
   * aus Errorkonstante mit 5 Parametern fuer 'raise_...' Aufrufe
   */
    function create_p5 (
        in_const_name in varchar2,
        in_p1         in varchar2,
        in_p2         in varchar2,
        in_p3         in varchar2,
        in_p4         in varchar2,
        in_p5         in varchar2
    ) return varchar2;

end;
/


-- sqlcl_snapshot {"hash":"3fb81f3c9511fd39b61a834653b36d45999965f6","type":"PACKAGE_SPEC","name":"PZM_P_LC","schemaName":"DIRKSPZM32","sxml":""}