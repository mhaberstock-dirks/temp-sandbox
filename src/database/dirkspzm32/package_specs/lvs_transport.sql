create or replace 
package DIRKSPZM32.lvs_transport is

  -- Public type declarations
  function get_version return varchar2;
  /*
  *  Versionsverlauf
  */

  -- Public function and procedure declarations
  function lvs_c_gesperrter_transp_lte (in_sid                  in isi_sid.sid%TYPE,
                                        in_firma_nr             in isi_firma.firma_nr%TYPE,
                                        in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                        in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                        in_frei_fahren          in varchar2,
                                        in_trans_typ            in varchar2,
                                        in_user_ID              in isi_user.login_id%TYPE,
                                        in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                                        in_auftrag_id_extern    in isi_transport.Auf_Id_extern%TYPE,
                                        in_prio                 in isi_transport.Prio%TYPE,
                                        in_progr_nr             in isi_transport.progr_nr%TYPE,
                                        in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                        in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                        in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                                        in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                                        in_lte_id               in lvs_lte.lte_id%TYPE,
                                        in_kunde_nr             in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                                        in_lieferschein         in isi_transport.lieferschein%type,
                                        in_li_nr                in isi_transport.li_nr%type,
                                        in_li_pos_nr            in isi_transport.li_pos_nr%type,
                                        in_vorgang_id           in isi_transport.vorgang_id%type,
                                        in_fahrzeuge_IDs        in varchar2,
                                        in_lkw_nr               in isi_transport.lkw_nr%type,
                                        in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                                        out_transp_id           out isi_transport.transp_id%type)
                                        return number;

  function lvs_gesperrter_transp_lte (in_sid                  in isi_sid.sid%TYPE,
                                      in_firma_nr             in isi_firma.firma_nr%TYPE,
                                      in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                      in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                      in_frei_fahren          in varchar2,
                                      in_trans_typ            in varchar2,
                                      in_user_ID              in isi_user.login_id%TYPE,
                                      in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                                      in_auftrag_id_extern    in isi_transport.Auf_Id_extern%TYPE,
                                      in_prio                 in isi_transport.Prio%TYPE,
                                      in_progr_nr             in isi_transport.progr_nr%TYPE,
                                      in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                      in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                      in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                                      in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                                      in_lte_id               in lvs_lte.lte_id%TYPE,
                                      in_kunde_nr             in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                                      in_lieferschein         in isi_transport.lieferschein%type,
                                      in_li_nr                in isi_transport.li_nr%type,
                                      in_li_pos_nr            in isi_transport.li_pos_nr%type,
                                      in_vorgang_id           in isi_transport.vorgang_id%type,
                                      in_fahrzeuge_IDs        in varchar2,
                                      in_lkw_nr               in isi_transport.lkw_nr%type,
                                      in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                                      out_transp_id           out isi_transport.transp_id%type,
                                      in_parent_transp_id     in isi_transport.transp_id%type default NULL,
                                      in_fetig_bis            in date default NULL)
                                      return number;

  function lvs_transp_lte_intern (in_sid                  in isi_sid.sid%TYPE,
                                  in_firma_nr             in isi_firma.firma_nr%TYPE,
                                  in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                  in_user_ID              in isi_user.login_id%TYPE,
                                  in_prio                 in isi_transport.Prio%TYPE,
                                  in_lte_id               in lvs_lte.lte_id%TYPE,
                                  in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_fahrzeuge_IDs        in varchar2,
                                  in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                                  out_transp_id           out isi_transport.transp_id%type,
                                  in_fetig_bis            in date default NULL
                                  )
                                  return number;

 function lvs_transp_lte(in_sid                  in isi_sid.sid%TYPE,
                          in_firma_nr             in isi_firma.firma_nr%TYPE,
                          in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                          in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                          in_frei_fahren          in varchar2,
                          in_trans_typ            in varchar2,
                          in_user_ID              in isi_user.login_id%TYPE,
                          in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                          in_auftrag_id_extern    in isi_transport.Auf_Id_extern%TYPE,
                          in_prio                 in isi_transport.Prio%TYPE,
                          in_progr_nr             in isi_transport.progr_nr%TYPE,
                          in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                          in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                          in_lgr_quell_lgr_platz  in LVS_LTE.LGR_PLATZ%TYPE,
                          in_lgr_ziel_lgr_platz   in LVS_LTE.LGR_PLATZ%TYPE,
                          in_lte_id               in lvs_lte.lte_id%TYPE,
                          in_kunde_nr             in lvs_lam.kunden_nr%TYPE,
                          in_lieferschein         in isi_transport.lieferschein%type,
                          in_li_nr                in isi_transport.li_nr%type,
                          in_li_pos_nr            in isi_transport.li_pos_nr%type,
                          in_vorgang_id           in isi_transport.vorgang_id%type,
                          in_fahrzeuge_IDs        in varchar2,
                          in_lkw_nr               in isi_transport.lkw_nr%type,
                          in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
                          out_transp_id           out isi_transport.transp_id%type,
                          in_parent_transp_id     in isi_transport.transp_id%type default NULL,
                          in_fetig_bis            in date default NULL
                          )
    return number;

  function lvs_transp_lte_353(in_sid                     in isi_sid.sid%TYPE,
                              in_firma_nr                in isi_firma.firma_nr%TYPE,
                              in_modul_erzeuger          in isi_transport.Modul_Erzeuger%TYPE,
                              in_modul_bearbeiter        in isi_transport.Modul_Bearbeiter%TYPE,
                              in_frei_fahren             in varchar2,
                              in_trans_typ               in varchar2,
                              in_user_ID                 in isi_user.login_id%TYPE,
                              in_auftrag_id              in isi_transport.Auf_Id%TYPE,
                              in_auftrag_id_extern       in isi_transport.Auf_Id_extern%TYPE,
                              in_prio                    in isi_transport.Prio%TYPE,
                              in_progr_nr                in isi_transport.progr_nr%TYPE,
                              in_quelle_Leer_progr_nr    in isi_transport.quelle_leer_progr_nr%TYPE,
                              in_ziel_voll_Progr_nr      in isi_transport.ziel_voll_progr_nr%TYPE,
                              in_lgr_quell_lgr_platz     in LVS_LTE.LGR_PLATZ%TYPE,
                              in_lgr_ziel_lgr_platz      in LVS_LTE.LGR_PLATZ%TYPE,
                              in_lte_id                  in lvs_lte.lte_id%TYPE,
                              in_kunde_nr                in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                              in_lieferschein            in isi_transport.lieferschein%type,
                              in_li_nr                   in isi_transport.li_nr%type,
                              in_li_pos_nr               in isi_transport.li_pos_nr%type,
                              in_vorgang_id              in isi_transport.vorgang_id%type,
                              in_fahrzeuge_IDs           in varchar2,
                              in_lkw_nr                  in isi_transport.lkw_nr%type,
                              in_komm_id                 in isi_transport.p_komm_id%type,
                              in_komm_lte_lhm_lagen      in isi_transport.p_komm_lte_lhm_lagen%type,
                              in_komm_lte_lhm_pro_lage   in isi_transport.p_komm_lte_lhm_pro_lage%type,
                              in_komm_lhm_hoehe_lage     in isi_transport.p_komm_lhm_hoehe_lage%type,
                              in_komm_packscheme_kopf_id in isi_transport.p_komm_packschema_kopf_id%type,
                              in_out_transport_gruppe    in out isi_transport.transport_gruppe%type,
                              out_transp_id           out isi_transport.transp_id%type,
                              in_parent_transp_id     in isi_transport.transp_id%type default NULL,
                              in_fetig_bis            in date default NULL
                              )
    return number;

  function lvs_transp_lte_insert (in_sid                     in isi_sid.sid%TYPE,
                                  in_firma_nr                in isi_firma.firma_nr%TYPE,
                                  in_modul_erzeuger          in isi_transport.Modul_Erzeuger%TYPE,
                                  in_modul_bearbeiter        in isi_transport.Modul_Bearbeiter%TYPE,
                                  in_frei_fahren             in varchar2,
                                  in_trans_typ               in varchar2,
                                  in_user_ID                 in isi_user.login_id%TYPE,
                                  in_auftrag_id              in isi_transport.Auf_Id%TYPE,
                                  in_auftrag_id_extern       in isi_transport.Auf_Id_extern%TYPE,
                                  in_prio                    in isi_transport.Prio%TYPE,
                                  in_progr_nr                in isi_transport.progr_nr%TYPE,
                                  in_quelle_Leer_progr_nr    in isi_transport.quelle_leer_progr_nr%TYPE,
                                  in_ziel_voll_Progr_nr      in isi_transport.ziel_voll_progr_nr%TYPE,
                                  in_lgr_quell_lgr_platz     in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_lgr_ziel_lgr_platz      in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_lte_id                  in lvs_lte.lte_id%TYPE,
                                  in_kunde_nr                in lvs_lam.kunden_nr%TYPE, -- Hier Adress_ID
                                  in_lieferschein            in isi_transport.lieferschein%type,
                                  in_li_nr                   in isi_transport.li_nr%type,
                                  in_li_pos_nr               in isi_transport.li_pos_nr%type,
                                  in_vorgang_id              in isi_transport.vorgang_id%type,
                                  in_fahrzeuge_IDs           in varchar2,
                                  in_lkw_nr                  in isi_transport.lkw_nr%type,
                                  in_komm_id                 in isi_transport.p_komm_id%type,
                                  in_komm_lte_lhm_lagen      in isi_transport.p_komm_lte_lhm_lagen%type,
                                  in_komm_lte_lhm_pro_lage   in isi_transport.p_komm_lte_lhm_pro_lage%type,
                                  in_komm_lhm_hoehe_lage     in isi_transport.p_komm_lhm_hoehe_lage%type,
                                  in_komm_packscheme_kopf_id in isi_transport.p_komm_packschema_kopf_id%type,
                                  in_out_transport_gruppe    in out isi_transport.transport_gruppe%type,
                                  out_transp_id              out isi_transport.transp_id%type,
                                  in_parent_transp_id        in isi_transport.transp_id%type default NULL,
                                  in_fetig_bis               in date default NULL
                                  ) return number;

  function transport_sperren(in_sid             in isi_sid.sid%type,
                             in_firma_nr        in isi_firma.firma_nr%type,
                             in_user_id         in isi_user.login_id%type,
                             in_transport_id    in isi_transport.transp_id%type)
                             return integer;

  function transport_freigeben(in_sid             in isi_sid.sid%type,
                               in_firma_nr        in isi_firma.firma_nr%type,
                               in_user_id         in isi_user.login_id%type,
                               in_transport_id    in isi_transport.transp_id%type)
                               return integer;

  function lvs_transp_reset(in_sid          in isi_sid.sid%type,
                            in_firma_nr     IN isi_firma.firma_nr%TYPE,
                            in_user_id      IN isi_user.login_id%TYPE,
                            in_transport_id IN isi_transport.transp_id%TYPE,
                            in_res_id       in isi_resource.res_id%type)
    return integer;

  procedure lvs_transport_abbr(in_sid                  in isi_sid.sid%type,
                               in_firma                in isi_firma.firma_nr%type,
                               in_res_id               in isi_resource.res_id%type
                              );

  FUNCTION lvs_transp_loeschen(in_sid            IN isi_sid.sid%TYPE,
                               in_firma_nr       IN isi_firma.firma_nr%TYPE,
                               in_user_id        IN isi_user.login_id%TYPE,
                               in_transport_id   IN isi_transport.transp_id%TYPE,
                               in_immer_loeschen IN varchar2)
    RETURN INTEGER;

  FUNCTION lvs_transp_beginnen(in_sid          IN isi_sid.sid%TYPE,
                               in_firma_nr     IN isi_firma.firma_nr%TYPE,
                               in_user_id      IN isi_user.login_id%TYPE,
                               in_transport_id IN isi_transport.transp_id%TYPE,
                               in_lte_id       in lvs_lte.lte_id%type,
                               in_res_id       in isi_resource.res_id%type)
    RETURN INTEGER;

  FUNCTION lvs_transp_transport(in_sid             IN isi_sid.sid%TYPE,
                                in_firma_nr        IN isi_firma.firma_nr%TYPE,
                                in_user_id         IN isi_user.login_id%TYPE,
                                in_transport_id    IN isi_transport.transp_id%TYPE,
                                in_lte_id          in lvs_lte.lte_id%type,
                                in_res_id          in isi_resource.res_id%type,
                                in_out_lam_bh_vorg in out isi_transport.lam_bh_vorgang_id%type)
    RETURN INTEGER;


  FUNCTION lvs_transp_fertig(in_sid          IN isi_sid.sid%TYPE,
                             in_firma_nr     IN isi_firma.firma_nr%TYPE,
                             in_user_id      IN isi_user.login_id%TYPE,
                             in_transport_id IN isi_transport.transp_id%TYPE,
                             in_lte_id       in lvs_lte.lte_id%type,
                             in_res_id       in isi_resource.res_id%type,
                             in_lgr_platz    in lvs_lgr.lgr_platz%type,
                             in_ausgelagert  in varchar2) RETURN INTEGER;

  FUNCTION lvs_transp_fertig_353(in_sid          in isi_sid.sid%type,
                                 in_firma_nr     IN isi_firma.firma_nr%TYPE,
                                 in_user_id      IN isi_user.login_id%TYPE,
                                 in_transport_id IN isi_transport.transp_id%TYPE,
                                 in_lte_id       in lvs_lte.lte_id%type,
                                 in_res_id       in isi_resource.res_id%type,
                                 in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                 in_ausgelagert  in varchar2,
                                 in_offset_x     in lvs_lte.lte_offset_x%type,
                                 in_offset_y     in lvs_lte.lte_offset_y%type,
                                 in_offset_z     in lvs_lte.lte_offset_z%type) RETURN INTEGER;

  FUNCTION lvs_transp_check_zugriff(in_sid              in isi_sid.sid%type,
                                    in_firma_nr         in isi_firma.firma_nr%type,
                                    in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
                                    in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
                                    in_frei_fahren      in varchar2,
                                    in_user_id          in isi_user.login_id%type,
                                    in_transport_id     in isi_transport.transp_id%type,
                                    in_fahrzeuge_IDs  in varchar2)
    RETURN PLS_INTEGER;

    function lvs_check_lte_stap_flae_frei(in_lte           in lvs_lte%rowtype)
    return number;


  function c_transport_freigeben(in_sid             in isi_sid.sid%type,
                                 in_firma_nr        in isi_firma.firma_nr%type,
                                 in_user_id         in isi_user.login_id%type,
                                 in_transport_id    in isi_transport.transp_id%type)
                                 return integer;

  function c_transport_sperren(in_sid             in isi_sid.sid%type,
                               in_firma_nr        in isi_firma.firma_nr%type,
                               in_user_id         in isi_user.login_id%type,
                               in_transport_id    in isi_transport.transp_id%type)
                               return integer;

  procedure lvs_uml_check_crt_lte(in_sid          in isi_sid.sid%type,
                                  in_firma_nr     in isi_firma.firma_nr%type,
                                  in_user_id      in isi_user.login_id%type,
                                  in_lte_id       in lvs_lte.lte_id%type,
                                  in_barcode      in lvs_lte.lte_id%type,
                                  in_res_id       in isi_resource.res_id%type,
                                  in_lgr_platz    in lvs_lgr.lgr_platz%type);

  procedure lvs_lte_transport(in_lte_id        in lvs_lte.lte_id%type,
                              in_von_lgr_platz in lvs_lgr.lgr_platz%type,
                              in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
                              in_user_id       in isi_user.login_id%type
                             );

  procedure c_transport_reihenfolge_set(in_sid                   in isi_sid.sid%type,
                                        in_firma_nr              in isi_firma.firma_nr%type,
                                        in_user_id               in isi_user.login_id%type,
                                        in_transport_id          in isi_transport.transp_id%type,
                                        in_transport_reihenfolge in isi_transport.transport_reihenfolge%type);

  procedure lvs_lte_transport_353(in_lte_id        in lvs_lte.lte_id%type,
                                  in_von_lgr_platz in lvs_lgr.lgr_platz%type,
                                  in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
                                  in_user_id       in isi_user.login_id%type,
                                  in_offset_x      in lvs_lte.lte_offset_x%type,
                                  in_offset_y      in lvs_lte.lte_offset_y%type,
                                  in_offset_z      in lvs_lte.lte_offset_z%type);

  procedure c_transport_reihenfolge_fix(in_sid                   in isi_sid.sid%type,
                                        in_firma_nr              in isi_firma.firma_nr%type,
                                        in_user_id               in isi_user.login_id%type,
                                        in_modul_bearbeiter      in isi_transport.Modul_Bearbeiter%TYPE,
                                        in_trans_typ             in varchar2,
                                        in_fixieren              in varchar2);

  function lvs_check_transport_ziel(in_sid                   in isi_sid.sid%type,
                                    in_firma_nr              in isi_firma.firma_nr%type,
                                    in_transport_id    in isi_transport.transp_id%type
                                    )
                                    return lvs_lgr.lgr_platz%type;

  procedure c_transport_grp_crt(in_sid                   in isi_sid.sid%type,
                                in_firma_nr              in isi_firma.firma_nr%type,
                                in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                                in_lte_id                in isi_transport_grp.lte_grp_id%type,
                                in_user_ID               in isi_user.login_id%TYPE);

  procedure c_transport_grp_add(in_sid                   in isi_sid.sid%type,
                                in_firma_nr              in isi_firma.firma_nr%type,
                                in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                                in_lte_id                in isi_transport_grp.lte_grp_id%type,
                                in_user_ID               in isi_user.login_id%TYPE);

  procedure c_transport_grp_sub(in_sid                   in isi_sid.sid%type,
                                in_firma_nr              in isi_firma.firma_nr%type,
                                in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                                in_lte_id                in isi_transport_grp.lte_grp_id%type,
                                in_user_ID               in isi_user.login_id%TYPE);

  procedure c_transport_grp_del(in_sid                   in isi_sid.sid%type,
                                in_firma_nr              in isi_firma.firma_nr%type,
                                in_lte_grp_id            in isi_transport_grp.lte_grp_id%type,
                                in_user_ID               in isi_user.login_id%TYPE);

end lvs_transport;
/



-- sqlcl_snapshot {"hash":"a4c29484240234dfbcce1b8e480f7a380d49dab1","type":"PACKAGE_SPEC","name":"LVS_TRANSPORT","schemaName":"DIRKSPZM32","sxml":""}