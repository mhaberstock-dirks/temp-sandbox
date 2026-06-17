create or replace 
package DIRKSPZM32.LVS_P_INVENTUR is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  05.10.2006 16:14:56
  __________________________________________________
  Description
  Inventurfunktionen
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
	             3.3.1.0              Package erstellt
  */

  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

  procedure set_artikel_akt_inventur_id(in_sid             in lvs_artikel_status.sid%type,
                                        in_firma_nr        in lvs_artikel_status.firma_nr%type,
                                        in_artikel_id      in lvs_artikel_status.artikel_id%type,
                                        in_leitzahl        in lvs_artikel_status.leitzahl%type,
                                        in_fa_ag           in lvs_artikel_status.fa_ag%type,
                                        in_akt_inventur_id in lvs_artikel_status.akt_inventur_id%type
                                       );

  procedure set_artikel_letzte_inventur(in_sid                in lvs_artikel_status.sid%type,
                                        in_firma_nr           in lvs_artikel_status.firma_nr%type,
                                        in_artikel_id         in lvs_artikel_status.artikel_id%type,
                                        in_leitzahl           in lvs_artikel_status.leitzahl%type,
                                        in_fa_ag              in lvs_artikel_status.fa_ag%type,
                                        in_letzte_inventur_id in lvs_artikel_status.akt_inventur_id%type,
                                        in_letzte_inv_datum   in lvs_artikel_status.letzte_inventur_datum%type,
                                        in_letzte_in_login_id in lvs_artikel_status.letzte_inventur_login_id%type,
                                        in_reset_akt_inv_id   in varchar2
                                       );

  function artikel_fuer_inventur_da(in_sid                in lvs_lam.sid%type,
                                    in_firma_nr           in lvs_lam.firma_nr%type,
                                    in_artikel_id         in lvs_lam.artikel_id%type,
                                    in_leitzahl           in lvs_lam.leitzahl%type,
                                    in_fa_ag              in lvs_lam.fa_ag%type,
                                    in_zeichnung_index    in lvs_lam.zeichnung_index%type,
                                    in_lgr_ort            in lvs_lgr.lgr_ort%type) return boolean;

end LVS_P_INVENTUR;
/



-- sqlcl_snapshot {"hash":"64fce3b6694c224b60c91ffa3f3fba8cc12b8d29","type":"PACKAGE_SPEC","name":"LVS_P_INVENTUR","schemaName":"DIRKSPZM32","sxml":""}