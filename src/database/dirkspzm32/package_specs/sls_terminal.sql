create or replace 
package DIRKSPZM32.sls_terminal is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-WK-)  06.09.2004 14:15:12
  __________________________________________________
  Description

   *************************************************************************
   * !! ACHTUNG !! diese Package ist veraltet neue Routinen in TERM_TRANSP, TERM_XXXX
   * --> neues Package ist TERM_TRANSP, TERM_xxx
   *************************************************************************
  __________________________________________________
  TODO
  mit Release 3.6 entfernen!!
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
	10.08.2007   3.4.1.1     (-WK-)   Einbau der Versionierung
  *                                 Neue Funktion: c_log_transport_check
  */




  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

  function get_next_auftrag(in_sid               in  isi_sid.sid%type,
                            in_firma_nr          in  isi_firma.firma_nr%type,
                            in_modul_erzeuger    in  isi_transport.modul_bearbeiter%type,
                            in_modul_bearbeiter  in  isi_transport.modul_bearbeiter%type,
                            in_freifahren        in  isi_transport.freifahrauftrag%type,
                            in_user_id           in  isi_user.login_id%type,
                            in_res_id            in  isi_resource.res_id%type,
                            out_transport        out isi_transport%rowtype
                           ) return number;

  function c_lte_insert(in_sid in isi_sid.sid%type,
                        in_firma_nr    in isi_user.login_id%type,
                        in_ls_login_id in isi_user.login_id%type,
                        in_lte_name in lvs_lte_cfg.lte_name%type
                       ) return varchar2;

  procedure c_lhm_umpacken (in_sid                  in isi_sid.sid%type,
                            in_firma_nr             in isi_firma.firma_nr%type,
                             in_user_id              in isi_user.login_id%type,
                             in_res_id               in isi_resource.res_id%type,
                             in_lhm_id               in lvs_lhm.Lhm_Id%TYPE,
                             in_lte_id               in lvs_lte.lte_id%type
                            );

  procedure c_platz_leer(in_sid                  in isi_sid.sid%type,
                         in_firma                in isi_firma.firma_nr%type,
                         in_user_id              in isi_user.login_id%type,
                         in_transport            in isi_transport%rowtype
                        );
  procedure c_platz_voll(in_sid                  in isi_sid.sid%type,
                         in_firma                in isi_firma.firma_nr%type,
                         in_user_id              in isi_user.login_id%type,
                         in_transport            in isi_transport%rowtype
                        );

  procedure c_transport_abbr(in_sid                  in isi_sid.sid%type,
                             in_firma                in isi_firma.firma_nr%type,
                             in_res_id               in isi_resource.res_id%type
                            );

  function c_transport_pal_tauschen(in_sid                  in isi_sid.sid%type,
                                     in_firma                in isi_firma.firma_nr%type,
                                     in_res_id               in isi_resource.res_id%type,
                                     in_user_id              in isi_user.login_id%type,
                                     in_soll_lte_id          in lvs_lte.lte_id%type,
                                     in_scann_lte_id         in lvs_lte.lte_id%type
                                   ) return varchar2;

  procedure c_log_transport_check(in_sid in isi_transport_log.sid%type,
                                  in_firma_nr in isi_transport_log.firma_nr%type,
                                  in_transp_id in isi_transport_log.transp_id%type,
                                  in_login_id in isi_transport_log.login_id%type,
                                  in_arbeitsplatz_id in isi_transport_log.arbeitsplatz_id%type,
                                  in_check_typ in isi_transport_log.check_typ%type,
                                  in_scan_data in isi_transport_log.scan_data%type,
                                  in_check_q_eti_typ in isi_transport_log.check_q_eti_typ%type,
                                  in_check_passed in isi_transport_log.check_passed%type);

  procedure transp_check_ausl_ware(in_sid in isi_transport_log.sid%type,
                                   in_firma_nr in isi_transport_log.firma_nr%type,
                                   in_transp_id in isi_transport_log.transp_id%type,
                                   in_lhm_id in lvs_lam.lhm_id%type,
                                   in_old_id in lvs_lam.lte_id%type,
                                   out_check_passed out isi_transport_log.check_passed%type,
                                   out_fail_reason_id out number,
                                   out_lgr_platz_quelle out lvs_lam.lgr_platz%type);

end sls_terminal;
/



-- sqlcl_snapshot {"hash":"90f4c9bd8b24a68e1ed27f40985f2f77b3123432","type":"PACKAGE_SPEC","name":"SLS_TERMINAL","schemaName":"DIRKSPZM32","sxml":""}