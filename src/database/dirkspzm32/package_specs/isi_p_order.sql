create or replace 
package DIRKSPZM32.isi_p_order is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  08.06.2004 09:57:11
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
               3.4.2.1:    (-AG-)   Erweiterung um die Berücksichtigung des Zeichnungsindex und Paramezer WA nicht Überliefern aus ISIOrder
  09.03.2009   3.3.10.1    (-AG-)   Funktionen um Tour_Nr erweitert
  24.10.2006   3.3.1.1     (-WK-)   Versionierung eingebaut
  08.06.2004   3.3.1.0     (-AG-)   Erstellt
  */



  v_version_str    constant  varchar2(25) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

  procedure abbruch_transporte(in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_vorgang_id  in isi_order_kopf.vorgang_id%type,
                               in_auf_id      in isi_order_pos.auf_id%type,
                               in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
                               in_satzart     in isi_order_kopf.satzart%type,
                               in_user_id     in isi_user.login_id%type,
                               in_res_rueck   in varchar2               -- False (Reservirung stehen lassen)
                              );

  procedure abbruch_transporte_359(in_sid         in isi_sid.sid%type,
                                   in_firma_nr    in isi_firma.firma_nr%type,
                                   in_vorgang_id  in isi_order_kopf.vorgang_id%type,
                                   in_li_nr       in isi_order_pos.li_nr%type,
                                   in_li_pos_nr   in isi_order_pos.li_pos_nr%type,
                                   in_auf_id      in isi_order_pos.auf_id%type,
                                   in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
                                   in_satzart     in isi_order_kopf.satzart%type,
                                   in_user_id     in isi_user.login_id%type,
                                   in_del_transp  in varchar2,              -- FALSE (Keine Transporte löschen)
                                   in_res_rueck   in varchar2               -- False (Reservirung stehen lassen)
                                  );

  procedure c_abbruch_transporte(in_sid         in isi_sid.sid%type,
                                 in_firma_nr    in isi_firma.firma_nr%type,
                                 in_vorgang_id  in isi_order_kopf.vorgang_id%type,
                                 in_auf_id      in isi_order_pos.auf_id%type,
                                 in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
                                 in_satzart     in isi_order_kopf.satzart%type,
                                 in_user_id     in isi_user.login_id%type,
                                 in_res_rueck   in varchar2               -- False (Reservirung stehen lassen)
                                );

  procedure C_ABBR_TRANS_LIEF(in_sid         in isi_sid.sid%type,
                              in_firma_nr    in isi_firma.firma_nr%type,
                              in_tour_nr     in isi_order_kopf.vorgang_id%type,
                              in_user_id     in isi_user.login_id%type,
                              in_res_rueck   in varchar2               -- False (Reservirung stehen lassen)
                             );

  procedure c_vorbereiten_trans_lief (in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_tour_nr     in isi_order_kopf.vorgang_id%type,
                                      in_user_id     in isi_user.login_id%type
                                     );

  procedure c_abbr_trans_lief_359(in_sid         in isi_sid.sid%type,
                                  in_firma_nr    in isi_firma.firma_nr%type,
                                  in_tour_nr     in isi_order_kopf.vorgang_id%type,
                                  in_li_nr       in isi_order_pos.li_nr%type,
                                  in_li_pos_nr   in isi_order_pos.li_pos_nr%type,
                                  in_user_id     in isi_user.login_id%type,
                                  in_del_transp  in varchar2,              -- FALSE (Keine Transporte löschen)
                                  in_res_rueck   in varchar2               -- False (Reservirung stehen lassen)
                                 );

  procedure C_AKTIV_TRANS_LIEF(in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_tour_nr     in isi_order_kopf.vorgang_id%type,
                               in_user_id     in isi_user.login_id%type,
                               in_aktivieren  in varchar2               -- False (Nur Reservieren)
                              );

  function AKTIV_TRANS_LIEF(in_sid         in isi_sid.sid%type,
                            in_firma_nr    in isi_firma.firma_nr%type,
                            in_tour_nr     in isi_order_kopf.vorgang_id%type,
                            in_user_id     in isi_user.login_id%type,
                            in_aktivieren  in varchar2               -- False (Nur Reservieren)
                           ) return varchar2;

  procedure C_AKTIV_TRANS_LIEF_359(in_sid         in isi_sid.sid%type,
                                   in_firma_nr    in isi_firma.firma_nr%type,
                                   in_tour_nr     in isi_order_kopf.vorgang_id%type,
                                   in_li_nr       in isi_order_pos.li_nr%type,
                                   in_li_pos_nr   in isi_order_pos.li_pos_nr%type,
                                   in_anz_pos     in number,
                                   in_user_id     in isi_user.login_id%type,
                                   in_aktivieren  in varchar2               -- False (Nur Reservieren)
                                  );

  function AKTIV_TRANS_LIEF_359(in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_tour_nr     in isi_order_kopf.vorgang_id%type,
                                in_li_nr       in isi_order_pos.li_nr%type,
                                in_li_pos_nr   in isi_order_pos.li_pos_nr%type,
                                in_anz_pos     in number,
                                in_user_id     in isi_user.login_id%type,
                                in_aktivieren  in varchar2               -- False (Nur Reservieren)
                               ) return varchar2;

  procedure C_DEL_LIEF(in_sid        in isi_sid.sid%type,
                      in_firma_nr    in isi_firma.firma_nr%type,
                      in_lief_nr     in isi_order_kopf.li_nr%type,
                      in_user_id     in isi_user.login_id%type,
                      in_tour_nr     in isi_order_kopf.vorgang_id%type
                      );

  procedure C_DEL_LIEF_359 (in_sid        in isi_sid.sid%type,
                            in_firma_nr    in isi_firma.firma_nr%type,
                            in_lief_nr     in isi_order_pos.li_nr%type,
                            in_lief_pos    in isi_order_pos.li_pos_nr%type,
                            in_user_id     in isi_user.login_id%type,
                            in_tour_nr     in isi_order_kopf.vorgang_id%type
                            );

  procedure C_RES_LIEF_POS(in_sid         in isi_sid.sid%type,
                           in_firma_nr    in isi_firma.firma_nr%type,
                           in_lief_nr     in isi_order_pos.li_nr%type,
                           in_lief_pos    in isi_order_pos.li_pos_nr%type,
                           in_user_id     in isi_user.login_id%type,
                           in_typ         in varchar2,
                           in_tour_nr     in isi_order_kopf.vorgang_id%type
                          );

  procedure RES_LIEF_POS(in_sid         in isi_sid.sid%type,
                         in_firma_nr    in isi_firma.firma_nr%type,
                         in_lief_nr     in isi_order_pos.li_nr%type,
                         in_lief_pos    in isi_order_pos.li_pos_nr%type,
                         in_user_id     in isi_user.login_id%type,
                         in_typ         in varchar2,
                         in_satzart     in varchar2,
                         in_tour_nr     in isi_order_kopf.vorgang_id%type
                        );

  procedure RES_LIEF_POS_359(in_sid         in isi_sid.sid%type,
                             in_firma_nr    in isi_firma.firma_nr%type,
                             in_lief_nr     in isi_order_pos.li_nr%type,
                             in_lief_pos    in isi_order_pos.li_pos_nr%type,
                             in_user_id     in isi_user.login_id%type,
                             in_typ         in varchar2,
                             in_satzart     in varchar2,
                             in_tour_nr     in isi_order_kopf.vorgang_id%type,
                             in_lte_id      in lvs_lte.lte_id%type
                            );

  procedure RES_RUECK_LIEF_POS(in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_lief_nr     in isi_order_pos.li_nr%type,
                               in_lief_pos    in isi_order_pos.li_pos_nr%type,
                               in_user_id     in isi_user.login_id%type,
                               in_typ         in varchar2,
                               in_tour_nr     in isi_order_kopf.vorgang_id%type
                              );

  procedure C_RES_RUECK_LIEF_POS(in_sid         in isi_sid.sid%type,
                                 in_firma_nr    in isi_firma.firma_nr%type,
                                 in_lief_nr     in isi_order_pos.li_nr%type,
                                 in_lief_pos    in isi_order_pos.li_pos_nr%type,
                                 in_user_id     in isi_user.login_id%type,
                                 in_typ         in varchar2,
                                 in_tour_nr     in isi_order_kopf.vorgang_id%type
                                );

  procedure res_rueck_order_pos(in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_user_id     in isi_user.login_id%type,
                                in_vorgang_id  in isi_order_pos.vorgang_id%type,
                                in_auf_id      in isi_order_pos.auf_id%type,
                                in_vorgang_typ in isi_order_pos.vorgang_typ%type,
                                in_satzart     in isi_order_pos.satzart%type
                               );

  procedure c_res_rueck_order_pos(in_sid         in isi_sid.sid%type,
                                  in_firma_nr    in isi_firma.firma_nr%type,
                                  in_user_id     in isi_user.login_id%type,
                                  in_vorgang_id  in isi_order_pos.vorgang_id%type,
                                  in_auf_id      in isi_order_pos.auf_id%type,
                                  in_vorgang_typ in isi_order_pos.vorgang_typ%type,
                                  in_satzart     in isi_order_pos.satzart%type
                                 );

  procedure C_AKTIV_TRANS_UMLA(in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_umla_nr     in isi_order_kopf.vorgang_id%type,
                               in_user_id     in isi_user.login_id%type,
                               in_aktivieren  in varchar2               -- False (Nur Reservieren)
                              );

  function HOLE_LGR_ORTE_IN_STR(in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_adress_id   in isi_adressen.adress_id%type
                              ) return varchar2;

  procedure C_DEL_UMLA(in_sid        in isi_sid.sid%type,
                      in_firma_nr    in isi_firma.firma_nr%type,
                      in_umla_nr     in isi_order_kopf.li_nr%type,
                      in_user_id     in isi_user.login_id%type
                      );

  procedure C_DEL_BEST(in_sid         in isi_sid.sid%type,
                       in_firma_nr    in isi_firma.firma_nr%type,
                       in_vorgang_id  in isi_order_kopf.vorgang_id%type,
                       in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
                       in_satzart     in isi_order_kopf.satzart%type,
                       in_user_id     in isi_user.login_id%type
                      );

  function is_vorbestellung(in_sid in isi_order_pos.sid%type,
                            in_auf_id in isi_order_pos.auf_id%type) return varchar2;

  function get_liefer_lgr_orte_fifo(in_sid in isi_order_pos.sid%type,
                                    in_auf_id in isi_order_pos.auf_id%type,
                                    in_adress_id in lvs_lgr_ort.adress_id%type) return varchar2;

  function C_ORDER_V_DELETE(in_von_datum    in varchar2,
                            in_bis_datum    in varchar2,
                            in_login_id     in isi_user.login_id%type,
                            in_sid          in isi_sid.sid%type,
                            in_firma_nr     in isi_firma.firma_nr%type,
                            in_vorgang_typ  in isi_order_kopf.vorgang_typ%type,
                            in_satzart      in isi_order_kopf.satzart%type
                           ) return number;

  procedure C_TOUR_VORB_RES(in_sid         in isi_sid.sid%type,
                            in_firma_nr    in isi_firma.firma_nr%type,
                            in_tour_nr     in isi_order_kopf.vorgang_id%type,
                            in_user_id     in isi_user.login_id%type
                          );

  procedure C_TOUR_VORB_TRANS(in_sid         in isi_sid.sid%type,
                              in_firma_nr    in isi_firma.firma_nr%type,
                              in_tour_nr     in isi_order_kopf.vorgang_id%type,
                              in_platz_grp   in varchar2,
                              in_user_id     in isi_user.login_id%type
                             );

  procedure TOUR_VORB_TRANS(in_sid         in isi_sid.sid%type,
                            in_firma_nr    in isi_firma.firma_nr%type,
                            in_tour_nr     in isi_order_kopf.vorgang_id%type,
                            in_platz_grp   in varchar2,
                            in_user_id     in isi_user.login_id%type,
                            in_lkw_nr      in isi_transport.lkw_nr%type
                           );

  procedure C_TOUR_VORB_Start(in_sid         in isi_sid.sid%type,
                              in_firma_nr    in isi_firma.firma_nr%type,
                              in_tour_nr     in isi_order_kopf.vorgang_id%type,
                              in_user_id     in isi_user.login_id%type
                             );

  procedure TOUR_VORB_START(in_sid         in isi_sid.sid%type,
                            in_firma_nr    in isi_firma.firma_nr%type,
                            in_tour_nr     in isi_order_kopf.vorgang_id%type,
                            in_user_id     in isi_user.login_id%type
                           );

  function TOUR_ANZ_RES(in_sid         in isi_sid.sid%type,
                        in_firma_nr    in isi_firma.firma_nr%type,
                        in_tour_nr     in isi_order_kopf.vorgang_id%type
                       ) return number;

  procedure C_CHECK_LIEF_FUER_LIEF_ENDE(in_sid        in isi_sid.sid%type,
                                        in_firma_nr    in isi_firma.firma_nr%type,
                                        in_vorgang_typ in isi_order_pos.vorgang_typ%type,
                                        in_lief_nr     in isi_order_kopf.li_nr%type,
                                        in_user_id     in isi_user.login_id%type,
                                        in_tour_nr     in isi_order_kopf.vorgang_id%type
                                        );

  procedure C_LIEF_ENDE(in_sid        in isi_sid.sid%type,
                        in_firma_nr    in isi_firma.firma_nr%type,
                        in_lief_nr     in isi_order_kopf.li_nr%type,
                        in_user_id     in isi_user.login_id%type,
                        in_tour_nr     in isi_order_kopf.vorgang_id%type
                        );

  procedure LIEF_ENDE(in_sid        in isi_sid.sid%type,
                      in_firma_nr    in isi_firma.firma_nr%type,
                      in_lief_nr     in isi_order_kopf.li_nr%type,
                      in_user_id     in isi_user.login_id%type,
                      in_tour_nr     in isi_order_kopf.vorgang_id%type
                      );

  procedure LTE_LIEF_ENDE(in_out_order_pos   in out isi_order_pos%rowtype,
                          in_user_id         in     isi_user.login_id%type
                         );

  procedure C_BEST_ENDE(in_sid        in isi_sid.sid%type,
                        in_firma_nr    in isi_firma.firma_nr%type,
                        in_best_nr     in isi_order_kopf.li_nr%type,
                        in_user_id     in isi_user.login_id%type
                        );

  procedure pruefe_lte_kompl_in_order(in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_vorgang     in isi_order_kopf.vorgang_id%type,
                                      in_lte_id      in lvs_lte.lte_id%type
                                     );
  procedure c_duplicate_best(in_sid             in isi_sid.sid%type,
                             in_firma_nr        in isi_firma.firma_nr%type,
                             in_vorgang_id      in isi_order_kopf.vorgang_id%type,
                             in_vorgang_typ     in isi_order_kopf.vorgang_typ%type,
                             in_satzart         in isi_order_kopf.satzart%type,
                             in_user_id         in isi_user.login_id%type,
                             in_arbeitsplatz_id in isi_arbeitsplatz.arbeitsplatz_id%type,
                             out_vorgang_id     out isi_order_kopf.vorgang_id%type
                            );

  procedure teilmg_transport_begonnen(in_sid             in isi_sid.sid%type,
                                      in_firma_nr        in isi_firma.firma_nr%type,
                                      in_transp_id       in isi_transport.transp_id%type);

  procedure rest_mg_wai_ma_pruefen(in_sid             in isi_sid.sid%type,
                                   in_firma_nr        in isi_firma.firma_nr%type,
                                   in_auf_id          in isi_order_pos.auf_id%type);

  procedure man_lvs_wai_ma_order(io_order_pos in out isi_order_pos%rowtype);

  function get_lgr_orte_vorbereitung (in_sid            in isi_sid.sid%type,
                                      in_firma_nr       in isi_firma.firma_nr%type,
                                      in_vorgang_id     in isi_order_kopf.vorgang_typ%type,
                                      in_transport_ziel in lvs_lgr.lgr_platz%type)
                                      return varchar2;
  function gen_trans_check_order(in_sid              in isi_sid.sid%type,
                                  in_firma_nr        in isi_firma.firma_nr%type,
                                  in_lte_id          in lvs_lte.lte_id%type,
                                  in_quell_lgr_platz in lvs_lgr.lgr_platz%type,
                                  in_auf_id          in isi_order_pos.auf_id%type)
                                  return boolean;
end isi_p_order;
/



-- sqlcl_snapshot {"hash":"2f327ac21689f3cfe5455fe6f0a89547b801c111","type":"PACKAGE_SPEC","name":"ISI_P_ORDER","schemaName":"DIRKSPZM32","sxml":""}