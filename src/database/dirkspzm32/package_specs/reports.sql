create or replace 
package DIRKSPZM32.REPORTS is

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

  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
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
  procedure C_ABFRAGE_AUSGEFUEHRT(in_sid in isi_user.sid%TYPE,
                                  in_firma_nr in isi_user.firma_nr%TYPE,
                                  in_login_id in isi_user.login_id%TYPE,
                                  in_rep_id in rep_abfragen.rep_id%TYPE);

  -- (-TS-) new: SET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061108
  procedure C_SET_REP_USER_TOP_PARAMS(in_sid in isi_user.sid%TYPE,
                                      in_firma_nr in isi_user.firma_nr%TYPE,
                                      in_login_id in isi_user.login_id%TYPE,
                                      in_rep_id in rep_abfragen.rep_id%TYPE,
                                      in_exec_ms_last in integer,
                                      in_exec_params_last in clob);

  -- (-TS-) new: GET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061109
  procedure GET_REP_USER_TOP_PARAMS(in_sid in isi_user.sid%TYPE,
                                  in_firma_nr in isi_user.firma_nr%TYPE,
                                  in_login_id in isi_user.login_id%TYPE,
                                  in_rep_id in rep_abfragen.rep_id%TYPE,
                                  out_counter out integer,
                                  out_exec_ms_min out integer,
                                  out_exec_ms_max out integer,
                                  out_exec_ms_last out integer,
                                  out_exec_date_min out date,
                                  out_exec_date_max out date,
                                  out_exec_date_last out date,
                                  out_exec_params_min out clob,
                                  out_exec_params_max out clob,
                                  out_exec_params_last out clob);



  procedure GET_REPORT_GRUPPEN(in_sid in isi_sid.sid%TYPE,
                               in_firma_nr in isi_firma.firma_nr%TYPE,
                               in_isi_module_cs in varchar2,
                               in_security_level in integer,
                               out_report_gruppen_cs out varchar2);

  procedure GET_REPORT_LISTE(out_report_liste out clob);

  procedure GET_REPORT_LISTE(in_gruppe in varchar2,
                             out_report_liste out clob);

  procedure EXECUTE_REPORT(in_report_id in rep_abfragen.rep_id%TYPE,
                           in_report_parameters in varchar2,
                           out_result out clob);

  function GET_REPORT_DATA(in_report_name in varchar2,
                           in_report_gruppe in varchar2,
                           out_abfrage_daten out rep_abfragen%rowtype,
                           out_abfrage_parameter_cs out varchar2) return boolean;
end REPORTS;
/



-- sqlcl_snapshot {"hash":"006126c00e7d3d45dddd3e12210ef668117086e8","type":"PACKAGE_SPEC","name":"REPORTS","schemaName":"DIRKSPZM32","sxml":""}