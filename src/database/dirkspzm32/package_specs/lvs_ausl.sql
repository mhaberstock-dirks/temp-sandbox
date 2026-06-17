create or replace 
package DIRKSPZM32.LVS_AUSL is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  24.05.2004 08:59:17
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
               3.4.9.3:    (-AG-)   In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
               3.4.2.2:    (-AG-)   Erweiterung der ISI_ORDER Anbruchpalette Reihenfolgeberücksichtigung IGNOR (Egal)
               3.4.2.1:    (-AG-)   Erweiterung um die Berücksichtigung des Zeichnungsindex und Paramezer WA nicht Überliefern aus ISIOrder
               3.3.4.4     (-WK-)   Bugfix in "LVS_LTE_PLATZ_BEWERTEN" -> dim_fifo_nr darf bei SEG_DUEDO nur beschränkt aktiv sein, da man in diesem Fall an beide LTEs dran kommt
               3.3.4.3     (-AG-)   Neue Funktion (Deckel) für Abgang, die gebuchte Menge zurueck gibt
	             3.3.4.2     (-WK-)   Bugfix in "transp_res_lam_mit_teilmg" -> Falsche Etikettierung (Quell-Lagerplatz bei Auslagerung nach Teil-Umlagerung (Picken)
	             3.3.4.1              Änderung in den Parametern von LVS_LTE_PLATZ_BEWERTEN
	*   - V3.3.4.0: > Versionierung Erstellt
  */

  -- Public variable declarations
  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

  v_sperr_transport_gruppe boolean;
  v_order_transport_gruppe isi_order_pos.transport_gruppe%type;
  v_transport_gruppe       isi_transport.transport_gruppe%type;

  -- Public function and procedure declarations
  function lvs_lam_abgang_r_menge (in_sid         in isi_sid.sid%type,
                                   in_firma_nr    in isi_firma.firma_nr%type,
                                   in_out_artikel_id  in out isi_artikel.artikel_id%type,
                                   in_lte_id      in lvs_lte.lte_id%type,
                                   in_lhm_id      in lvs_lhm.lhm_id%type,
                                   in_abnr        in bde_fa_auftrag.abnr%type,
                                   in_res_id      in isi_resource.res_id%type,
                                   in_abg_datum   in date,
                                   in_ls_login_id in isi_user.login_id%type,
                                   in_vorgag_id   in lvs_lam_bh.vorg_id%type,
                                   in_bew_id      in s_send_bew.bew_id%type,
                                   in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                                   in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                                   in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                   in_abnr_extern in bde_fa_auftrag.abnr%type,
                                   in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                   in_tour        in isi_order_pos.vorgang_id%type,
                                   in_li_nr       in isi_order_pos.li_nr%type,
                                   in_li_pos_nr   in isi_order_pos.li_pos_nr%type,
                                   out_menge     out number
                                  ) return number;

  function LVS_LAM_ABGANG (in_sid         in isi_sid.sid%type,
                           in_firma_nr    in isi_firma.firma_nr%type,
                           in_out_artikel_id  in out isi_artikel.artikel_id%type,
                           in_lte_id      in lvs_lte.lte_id%type,
                           in_lhm_id      in lvs_lhm.lhm_id%type,
                           in_abnr        in bde_fa_auftrag.abnr%type,
                           in_res_id      in isi_resource.res_id%type,
                           in_abg_datum   in date,
                           in_ls_login_id in isi_user.login_id%type,
                           in_vorgag_id   in lvs_lam_bh.vorg_id%type,
                           in_bew_id      in s_send_bew.bew_id%type,
                           in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                           in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                           in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                           in_abnr_extern in bde_fa_auftrag.abnr%type,
                           in_lam_bh_bus  in lvs_lam_bh.bus%type,
                           in_tour        in isi_order_pos.vorgang_id%type,
                           in_li_nr       in isi_order_pos.li_nr%type,
                           in_li_pos_nr   in isi_order_pos.li_pos_nr%type
                          ) return number;
  function LVS_PRUEFE_TOUR_AUSL (in_sid           in isi_sid.sid%type,
                                 in_firma_nr      in isi_firma.firma_nr%type,
                                 in_tour_nr       in isi_order_kopf.vorgang_id%type
                               )
                              return number;
  function LVS_PRUEFE_LIEF_POS  (in_sid           in isi_sid.sid%type,
                                 in_firma_nr      in isi_firma.firma_nr%type,
                                 in_lief_nr       in isi_order_pos.li_nr%type,
                                 in_lief_pos      in isi_order_pos.li_pos_nr%type,
                                 out_order_kopf  out isi_order_kopf%rowtype,         -- Auftragskopfdaten aus ISI-Order
                                 in_typ           in varchar2,
                                 in_satzart       in varchar2,
                                 in_tour_nr       in isi_order_kopf.vorgang_id%type
                               )
                              return number;

  function LVS_LTE_PLATZ_BEWERTEN(in_sid                     in     isi_sid.sid%type,
                                  in_firma_nr                in     isi_firma.firma_nr%type,
                                  in_order_strategie         in     isi_order_pos.strategie%type,
                                  in_order_anbruch           in     isi_order_pos.anbruch%type,
                                  in_lte_voll                in     lvs_lte.lte_voll%type,
                                  in_lam_mhd                 in     lvs_lam.lam_mhd%type,
                                  in_lam_prod_datum          in     lvs_lam.prod_datum%type,
                                  in_lte_id                  in     lvs_lte.lte_id%type,
                                  in_lte_lgr_platz           in     lvs_lgr.lgr_platz%type,
                                  in_lte_res_string          in     lvs_lgr.res_string%type,
                                  in_lgr_platz_gruppe        in     lvs_lgr.lgr_platz_gruppe%type,
                                  in_lgr_platz_typ           in     lvs_lgr.lgr_typ%type,
                                  in_artikel_id              in     isi_artikel.artikel_id%type
                                  ) return number;

  function lvs_lte_reservieren (in_sid                  in isi_sid.sid%TYPE,
                                in_firma_nr             in isi_firma.firma_nr%TYPE,
                                in_vorgang_id           in isi_transport.vorgang_id%type,
                                in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                                in_lte_id               in lvs_lte.lte_id%type,
                                in_lte_vorgang_id       in isi_transport.vorgang_id%type,
                                in_lte_lgr_platz        in LVS_LTE.LGR_PLATZ%TYPE,
                                in_artikel_id           in isi_artikel.artikel_id%type)
                                return number;

  function lvs_lte_reserv_user_ziel(in_sid                  in isi_sid.sid%TYPE,
                                    in_firma_nr             in isi_firma.firma_nr%TYPE,
                                    in_vorgang_id           in isi_transport.vorgang_id%type,
                                    in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                                    in_lte_id               in lvs_lte.lte_id%type,
                                    in_artikel_id           in isi_artikel.artikel_id%type,
                                    in_res_login_id         in lvs_lte.res_login_id%type,
                                    in_res_ziel_lgr_platz   in lvs_lte.res_ziel_lgr_platz%type,
                                    in_lhm_id               in lvs_lam.lhm_id%type default null)
                                    return number;

  function LVS_C_LTE_RESERVIEREN (in_sid                  in isi_sid.sid%TYPE,
                                  in_firma_nr             in isi_firma.firma_nr%TYPE,
                                  in_vorgang_id           in isi_transport.vorgang_id%type,
                                  in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                                  in_lte_id               in lvs_lte.lte_id%TYPE,
                                  in_lte_vorgang_id       in isi_transport.vorgang_id%type,
                                  in_lte_lgr_platz        in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_artikel_id           in isi_artikel.artikel_id%type)
                                  return number;

  function lvs_lte_res_rueck (in_sid                  in isi_sid.sid%type,
                              in_firma_nr             in isi_firma.firma_nr%type,
                              in_vorgang_id           in isi_transport.vorgang_id%type,
                              in_auftrag_id           in isi_transport.auf_id%type,
                              in_lte_id               in lvs_lte.lte_id%type,
                              in_lte_vorgang_id       in isi_transport.vorgang_id%type,
                              in_lte_lgr_platz        in lvs_lte.lgr_platz%type,
                              in_res_user_rueck       in varchar2)
                              return number;

  function lvs_c_lte_res_rueck (in_sid                  in isi_sid.sid%TYPE,
                                in_firma_nr             in isi_firma.firma_nr%TYPE,
                                in_vorgang_id           in isi_transport.vorgang_id%type,
                                in_auftrag_id           in isi_transport.Auf_Id%TYPE,
                                in_lte_id               in lvs_lte.lte_id%type,
                                in_lte_vorgang_id       in isi_transport.vorgang_id%type,
                                in_lte_lgr_platz        in LVS_LTE.LGR_PLATZ%TYPE)
                                return number;

  procedure c_ausl_res_rueck(in_sid        in lvs_lam.sid%type,
                             in_firma_nr   in lvs_lam.firma_nr%type,
                             in_lam_id     in lvs_lam.lam_id%type,
                             in_login_id   in isi_user.login_id%type,
                             in_fifo_pruef in varchar2);

  procedure c_transp_res_lam_mit_teilmg(in_sid                  in lvs_lam.sid%type,
                                        in_firma_nr             in lvs_lam.firma_nr%type,
                                        in_lam_id               in lvs_lam.lam_id%type,
                                        in_komm_neu_lte_name    in lvs_lte.lte_name%type,
                                        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
                                        in_login_id             in isi_user.login_id%type,
                                        in_eti_druck_status     in lvs_lte.lte_eti_druck_status%type
                                       );

  procedure c_lam_suche_res_ausl(in_sid                  in lvs_lam.sid%type,
                                 in_firma_nr             in lvs_lam.firma_nr%type,
                                 in_artikel_id           in lvs_lam.artikel_id%type,
                                 in_leitzahl             in lvs_lam.leitzahl%type,
                                 in_fa_ag                in lvs_lam.fa_ag%type,
                                 in_charge_id            in lvs_lam.charge_id%type,
                                 in_seriennr_id          in lvs_lam.serie_id%type,
                                 in_mhd                  in lvs_lam.lam_mhd%type,
                                 in_zeichnung_index      in lvs_lam.zeichnung_index%type,
                                 in_lgr_orte             in varchar2,
                                 in_menge                in number,
                                 in_ziel_lgr_platz       in lvs_lgr.lgr_platz%type,
                                 in_komm_ziel_lte_name   in lvs_lte_cfg.lte_name%type,
                                 in_komm_ziel_lte_id     in lvs_lte.lte_id%type,
                                 in_komm_anz_lhm_pro_lte in number,
                                 io_order_auf_id         in out lvs_lam.order_pos_auf_id%type,
                                 in_login_id             in isi_user.login_id%type,
                                 in_aktivieren           in varchar2 default 'F');

  function LVS_LTE_SUCHE_BUCH_AUSL (in_order_pos     in isi_order_pos%rowtype,
                                    in_order_kopf    in isi_order_kopf%rowtype,
                                    in_lgr_orte      in varchar2,
                                    in_user_id       in isi_user.login_id%type,
                                    in_aktivieren    in varchar2)
                              return number;

  function lvs_lam_suche_buch_ausl (in_order_pos            in isi_order_pos%rowtype,
                                    in_order_kopf           in isi_order_kopf%rowtype,
                                    in_lgr_orte             in varchar2,
                                    in_user_id              in isi_user.login_id%type,
                                    in_ganze_lte_res        in varchar2,
                                    in_komm_ziel_lte_id     in lvs_lte.lte_id%type,
                                    in_komm_anz_lhm_pro_lte in number,
                                    in_aktivieren           in varchar2) return number;

  function lvs_lam_suche_buch_ausl_359 (in_order_pos            in isi_order_pos%rowtype,
                                        in_order_kopf           in isi_order_kopf%rowtype,
                                        in_lgr_orte             in varchar2,
                                        in_user_id              in isi_user.login_id%type,
                                        in_ganze_lte_res        in varchar2,
                                        in_komm_ziel_lte_id     in lvs_lte.lte_id%type,
                                        in_komm_anz_lhm_pro_lte in number,
                                        in_aktivieren           in varchar2,
                                        in_lte_id               in lvs_lte.lte_id%type) return number;

function LVS_LAM_BH_UPDATE_MG(in_lam_bh  in lvs_lam_bh%rowtype,
                              in_menge   in lvs_lam_bh.menge%type
                             ) return integer;

procedure LVS_C_OHNE_TRANSP_START (in_sid         in  isi_sid.sid%type,
                                   in_firma_nr    in  isi_firma.firma_nr%type,
                                   in_vorgang_typ in  isi_order_kopf.vorgang_typ%type,
                                   in_vorgang_id  in  isi_order_kopf.vorgang_id%type,
                                   in_li_nr       in  isi_order_kopf.li_nr%type,
                                   in_res_id      in  isi_resource.res_id%type,
                                   out_lte_id     out lvs_lte.lte_id%type,
                                   out_transp_id  out isi_transport.transp_id%type);

procedure LVS_C_OHNE_TRANSP_LTE (in_sid         in  isi_sid.sid%type,
                                 in_firma_nr    in  isi_firma.firma_nr%type,
                                 in_vorgang_typ in  isi_order_kopf.vorgang_typ%type,
                                 in_vorgang_id  in  isi_order_kopf.vorgang_id%type,
                                 in_li_nr       in  isi_order_kopf.li_nr%type,
                                 in_res_id      in  isi_resource.res_id%type,
                                 in_user_id     in  isi_user.login_id%type,
                                 in_lte_id      in  lvs_lte.lte_id%type,
                                 out_transp_id  out isi_transport.transp_id%type);

procedure LVS_C_OHNE_TRANSP_TOR (in_sid         in isi_sid.sid%type,
                                 in_firma_nr    in isi_firma.firma_nr%type,
                                 in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
                                 in_vorgang_id  in isi_order_kopf.vorgang_id%type,
                                 in_li_nr       in isi_order_kopf.li_nr%type,
                                 in_res_id      in isi_resource.res_id%type,
                                 in_user_id     in isi_user.login_id%type,
                                 in_lte_id      in lvs_lte.lte_id%type,
                                 in_transp_id   in isi_transport.transp_id%type);

procedure LVS_C_OHNE_TRANSP_ABSCHLUSS (in_sid         in isi_sid.sid%type,
                                       in_firma_nr    in isi_firma.firma_nr%type,
                                       in_vorgang_typ in isi_order_kopf.vorgang_typ%type,
                                       in_vorgang_id  in isi_order_kopf.vorgang_id%type,
                                       in_li_nr       in isi_order_kopf.li_nr%type,
                                       in_res_id      in isi_resource.res_id%type,
                                       in_set_status  in varchar2);

function LVS_PRUEFE_UMLA_AUSL (in_sid           in isi_sid.sid%type,
                               in_firma_nr      in isi_firma.firma_nr%type,
                               in_umla_nr       in isi_order_kopf.vorgang_id%type
                             )
                            return number;

procedure LVS_LIEFERS_ERZEUGE_DATEN(in_isi_transport in isi_transport%rowtype,
                                    in_lam           in lvs_lam%rowtype,
                                    in_order_pos     in isi_order_pos%rowtype,
                                    in_lam_bh_id     in lvs_lam_bh.lam_bh_id%type,
                                    in_lte           in lvs_lte%rowtype,
                                    in_v_lhm         in isi_liefs.v_lhm_id%type);

end LVS_AUSL;
/



-- sqlcl_snapshot {"hash":"a45263c24f7f7ff680dfd24e3e868be89fc5577d","type":"PACKAGE_SPEC","name":"LVS_AUSL","schemaName":"DIRKSPZM32","sxml":""}