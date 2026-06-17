create or replace 
package DIRKSPZM32.tms_p_delivery is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  06.03.2009 12:59:28
  __________________________________________________
  Description
  TMS transortManagementSystem Delivery Funktionen
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.01.2010   3.5.2.1     (-BW-)   Erweiterung Sped
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */



  /* -WK-: zum Test, ob wir evtl getrennte Versionskonstanten pflegen sollten */
  v_release_major  constant number := 3;
  v_release_minor  constant number := 5;
  v_revision       constant number := 0;
  -- the build number is counted in the package body
  v_rev_date       constant varchar2(20) := '27.11.2009';
  v_release_str    constant  varchar2(20) := to_char(v_release_major) || '.' ||
                                             to_char(v_release_minor) || '.' ||
                                             to_char(v_revision) || ' / ' ||
                                             v_rev_date;

  --v_version_str    constant  varchar2(20) := '3.4.10.1 / 27.02.2009';
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
  *  06.03.2009 | 3.4.10     | (-WK-) package created
  */

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/
  function c_create_new_delivery_order(in_sid        in isi_order_pos.sid%type,
                                       in_firma_nr   in isi_order_pos.firma_nr%type,
                                       in_auftrag_nr in isi_order_pos.auftrag%type,
                                       in_pos_nr     in isi_order_pos.pos_nr%type,
                                       in_upos_nr    in isi_order_pos.upos_nr%type,
                                       in_login_id   in isi_order_pos.login_id%type,
                                       in_sp_adress_id in isi_order_kopf.sp_adress_id%type
                                      ) return number;

  function create_new_tour_nr (in_sid        in isi_order_pos.sid%type,
                               in_firma_nr   in isi_order_pos.firma_nr%type
                                ) return number;

  function c_create_new_delivery_ord_3511 (in_sid        in isi_order_pos.sid%type,
                                           in_firma_nr   in isi_order_pos.firma_nr%type,
                                           in_auftrag_nr in isi_order_pos.auftrag%type,
                                           in_pos_nr     in isi_order_pos.pos_nr%type,
                                           in_upos_nr    in isi_order_pos.upos_nr%type,
                                           in_login_id   in isi_order_pos.login_id%type,
                                           in_sp_adress_id in isi_order_kopf.sp_adress_id%type,
                                           in_satzart      in isi_order_kopf.satzart%type,
                                           in_lam_sel1                  in lvs_lam.lam_sel1%type,
                                           in_lam_sel2                  in lvs_lam.lam_sel2%type,
                                           in_lam_sel3                  in lvs_lam.lam_sel3%type,
                                           in_lam_sel4                  in lvs_lam.lam_sel4%type,
                                           in_lam_sel5                  in lvs_lam.lam_sel5%type,
                                           in_lam_sel6                  in lvs_lam.lam_sel6%type,
                                           in_lam_sel7                  in lvs_lam.lam_sel7%type,
                                           in_lam_sel8                  in lvs_lam.lam_sel8%type,
                                           in_lam_sel9                  in lvs_lam.lam_sel9%type,
                                           in_lam_sel10                 in lvs_lam.lam_sel10%type,
                                           in_anbruch                   in isi_order_pos.anbruch%type,
                                           in_quell_lagerorte           in isi_order_pos.quell_lagerorte%type
                                          ) return number;

  procedure c_add_pos_to_delivery_order(in_sid        in isi_order_pos.sid%type,
                                        in_firma_nr   in isi_order_pos.firma_nr%type,
                                        in_vorgang_id in isi_order_pos.vorgang_id%type,
                                        in_auftrag_nr in isi_order_pos.auftrag%type,
                                        in_pos_nr     in isi_order_pos.pos_nr%type,
                                        in_upos_nr    in isi_order_pos.upos_nr%type,
                                        in_login_id   in isi_order_pos.login_id%type,
                                        in_sp_adress_id in isi_order_kopf.sp_adress_id%type  -- Neu 3.5.2
                                       );

  procedure c_add_pos_to_delivery_ord_3511 (in_sid        in isi_order_pos.sid%type,
                                            in_firma_nr   in isi_order_pos.firma_nr%type,
                                            in_vorgang_id in isi_order_pos.vorgang_id%type,
                                            in_auftrag_nr in isi_order_pos.auftrag%type,
                                            in_pos_nr     in isi_order_pos.pos_nr%type,
                                            in_upos_nr    in isi_order_pos.upos_nr%type,
                                            in_login_id   in isi_order_pos.login_id%type,
                                            in_sp_adress_id in isi_order_kopf.sp_adress_id%type,
                                            in_satzart      in isi_order_kopf.satzart%type,
                                            in_lam_sel1                  in lvs_lam.lam_sel1%type,
                                            in_lam_sel2                  in lvs_lam.lam_sel2%type,
                                            in_lam_sel3                  in lvs_lam.lam_sel3%type,
                                            in_lam_sel4                  in lvs_lam.lam_sel4%type,
                                            in_lam_sel5                  in lvs_lam.lam_sel5%type,
                                            in_lam_sel6                  in lvs_lam.lam_sel6%type,
                                            in_lam_sel7                  in lvs_lam.lam_sel7%type,
                                            in_lam_sel8                  in lvs_lam.lam_sel8%type,
                                            in_lam_sel9                  in lvs_lam.lam_sel9%type,
                                            in_lam_sel10                 in lvs_lam.lam_sel10%type,
                                            in_anbruch                   in isi_order_pos.anbruch%type,
                                            in_quell_lagerorte           in isi_order_pos.quell_lagerorte%type
                                           );

  procedure c_mov_pos_to_delivery_order(in_sid            in isi_order_pos.sid%type,
                                        in_firma_nr       in isi_order_pos.firma_nr%type,
                                        in_old_vorgang_id in isi_order_pos.vorgang_id%type,
                                        in_lief_nr        in isi_order_pos.li_nr%type,
                                        in_new_vorgang_id in isi_order_pos.vorgang_id%type,
                                        in_login_id   in isi_order_pos.login_id%type
                                       );

  procedure c_del_pos_from_delivery_order(in_sid        in isi_order_pos.sid%type,
                                          in_firma_nr   in isi_order_pos.firma_nr%type,
                                          in_vorgang_id in isi_order_pos.vorgang_id%type,
                                          in_li_nr      in isi_order_pos.li_nr%type,
                                          in_li_pos_nr  in isi_order_pos.li_pos_nr%type,
                                          in_login_id   in isi_order_pos.login_id%type
                                         );

end tms_p_delivery;
/



-- sqlcl_snapshot {"hash":"76d6bb1250ab4f0f6d0cc4ddcf9a32877b3eaaa0","type":"PACKAGE_SPEC","name":"TMS_P_DELIVERY","schemaName":"DIRKSPZM32","sxml":""}