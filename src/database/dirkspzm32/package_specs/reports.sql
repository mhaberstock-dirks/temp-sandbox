create or replace package dirkspzm32.reports is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  29.04.2004 09:21:05
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;
  /*
	*  Versionsverlauf
	*     Date         Ver.     Comment
	*     -----------  -------  ---------------------
  *     21.09.2007   3.4.3.1  (-WK-) Durch erweiterung der Tabelle rep_abfragen hat sich auch
  *                                  "rep_abfragen%rowtype" für Delphi verändert
  *     14.11.2006   3.3.4.4  (-TS-) Cut & Paste Fehler in GET_REP_USER_TOP_PARAMS
  *     09.11.2006   3.3.4.3  (-TS-) Proc GET_REP_USER_TOP_PARAMS
  *                                  Ermittlung der letzten Laufzeit, der letzten Parameter und
  *                                  Zeitpunkt des letzten Report Aufrufs, je SID, FIRMA_NR, LOGIN_ID, REP_ID
  *     08.11.2006   3.3.4.2  (-TS-) Proc SET_REP_USER_TOP_PARAMS, ersetzt C_ABFRAGE_AUSGEFUEHRT
  *                                  Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt
  *     24.10.2006   3.3.4.1  (-WK-) Versionierung erstellt
	*     29.04.2004   3.3.4.0  (-WK-) Erstellt
  */

 -- (-TS-) obsolete: replaced by SET_REP_USER_TOP_PARAMS
    procedure c_abfrage_ausgefuehrt (
        in_sid      in isi_user.sid%type,
        in_firma_nr in isi_user.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        in_rep_id   in rep_abfragen.rep_id%type
    );

  -- (-TS-) new: SET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061108
    procedure c_set_rep_user_top_params (
        in_sid              in isi_user.sid%type,
        in_firma_nr         in isi_user.firma_nr%type,
        in_login_id         in isi_user.login_id%type,
        in_rep_id           in rep_abfragen.rep_id%type,
        in_exec_ms_last     in integer,
        in_exec_params_last in clob
    );

  -- (-TS-) new: GET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061109
    procedure get_rep_user_top_params (
        in_sid               in isi_user.sid%type,
        in_firma_nr          in isi_user.firma_nr%type,
        in_login_id          in isi_user.login_id%type,
        in_rep_id            in rep_abfragen.rep_id%type,
        out_counter          out integer,
        out_exec_ms_min      out integer,
        out_exec_ms_max      out integer,
        out_exec_ms_last     out integer,
        out_exec_date_min    out date,
        out_exec_date_max    out date,
        out_exec_date_last   out date,
        out_exec_params_min  out clob,
        out_exec_params_max  out clob,
        out_exec_params_last out clob
    );

    procedure get_report_gruppen (
        in_sid                in isi_sid.sid%type,
        in_firma_nr           in isi_firma.firma_nr%type,
        in_isi_module_cs      in varchar2,
        in_security_level     in integer,
        out_report_gruppen_cs out varchar2
    );

    procedure get_report_liste (
        out_report_liste out clob
    );

    procedure get_report_liste (
        in_gruppe        in varchar2,
        out_report_liste out clob
    );

    procedure execute_report (
        in_report_id         in rep_abfragen.rep_id%type,
        in_report_parameters in varchar2,
        out_result           out clob
    );

    function get_report_data (
        in_report_name           in varchar2,
        in_report_gruppe         in varchar2,
        out_abfrage_daten        out rep_abfragen%rowtype,
        out_abfrage_parameter_cs out varchar2
    ) return boolean;

end reports;
/


-- sqlcl_snapshot {"hash":"15ce40da575ccee10776d95ac987b197799e5aa1","type":"PACKAGE_SPEC","name":"REPORTS","schemaName":"DIRKSPZM32","sxml":""}