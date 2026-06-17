create or replace 
package DIRKSPZM32.tms_p_loading is

  -- Author  : WKROEKER
  -- Created : 05.03.2009 15:07:28
  -- Purpose :

  /* -WK-: zum Test, ob wir evtl getrennte Versionskonstanten pflegen sollten */
  v_release_major  constant number := 3;
  v_release_minor  constant number := 4;
  v_revision       constant number := 10;
  -- the build number is counted in the package body
  v_rev_date       constant varchar2(20) := '05.03.2009';
  v_release_str    constant  varchar2(20) := to_char(v_release_major) || '.' ||
                                             to_char(v_release_minor) || '.' ||
                                             to_char(v_revision) || ' / ' ||
                                             v_rev_date;

  --v_version_str    constant  varchar2(20) := '3.4.10.1 / 05.03.2009';
  function get_release return varchar2;
  function get_version return varchar2;
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2);

  /*
  *  Revision history
  *  date       | revision   | Info
  *  ---------------------------------------------------------------------------------
  *  05.03.2009 | 3.4.10     | (-WK-) package created
  */

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/
  procedure c_activate_loading(in_vorgang_id in tms_loading_points.order_vorgang_id%type,
                               in_lgr_platz in tms_loading_points.lgr_platz%type,
                               in_login_id in tms_loading_points.last_change_login_id%type,
                               in_firma_nr in tms_loading_points.firma_nr%type,
                               in_sid in tms_loading_points.sid%type);

  procedure c_loading_complete(in_vorgang_id in tms_loading_points.order_vorgang_id%type,
                               in_lgr_platz  in tms_loading_points.lgr_platz%type,
                               in_login_id   in tms_loading_points.last_change_login_id%type,
                               in_firma_nr   in tms_loading_points.firma_nr%type,
                               in_sid        in tms_loading_points.sid%type);

  procedure c_dup_order_kopf_by_auf_id(in_sid                 in isi_sid.sid%type,
                                       in_firma_nr            in isi_firma.firma_nr%type,
                                       in_auf_id              in isi_order_pos.auf_id%type,
                                       in_user_id             in isi_user.login_id%type,
                                       in_out_new_vorgang_id  in out isi_order_kopf.vorgang_id%type,
                                       in_out_new_li_nr       in out isi_order_kopf.li_nr%type
                                      );

  procedure c_dup_order_kopf (in_sid                 in isi_sid.sid%type,
                              in_firma_nr            in isi_firma.firma_nr%type,
                              in_vorgang_id          in isi_order_kopf.vorgang_id%type,
                              in_li_nr               in isi_order_kopf.li_nr%type,
                              in_user_id             in isi_user.login_id%type,
                              in_out_new_vorgang_id  in out isi_order_kopf.vorgang_id%type,
                              in_out_new_li_nr       in out isi_order_kopf.li_nr%type
                             );

  procedure c_dup_order_pos(in_sid                 in isi_sid.sid%type,
                            in_firma_nr            in isi_firma.firma_nr%type,
                            in_auf_id              in isi_order_pos.auf_id%type,
                            in_user_id             in isi_user.login_id%type,
                            in_new_vorgang_id      in isi_order_kopf.vorgang_id%type,
                            in_new_li_nr           in isi_order_kopf.li_nr%type,
                            in_out_auf_id          in out isi_order_pos.auf_id%type
                           );

  function chk_order_pos_by_li_nr_artikel(in_sid                 in isi_sid.sid%type,
                                          in_firma_nr            in isi_firma.firma_nr%type,
                                          in_artikel_id          in isi_artikel.artikel_id%type,
                                          in_vorgang_id          in isi_order_kopf.vorgang_id%type,
                                          in_li_nr               in isi_order_kopf.li_nr%type
                                         ) return boolean;

  function chk_order_kopf_by_li_nr_vor_id(in_sid                 in isi_sid.sid%type,
                                          in_firma_nr            in isi_firma.firma_nr%type,
                                          in_vorgang_id          in isi_order_kopf.vorgang_id%type,
                                          in_li_nr               in isi_order_kopf.li_nr%type
                                         ) return boolean;

end tms_p_loading;
/



-- sqlcl_snapshot {"hash":"fc310381e66d2a6550870b878955c739b1ed6dfc","type":"PACKAGE_SPEC","name":"TMS_P_LOADING","schemaName":"DIRKSPZM32","sxml":""}