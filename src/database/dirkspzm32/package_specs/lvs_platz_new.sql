create or replace 
PACKAGE DIRKSPZM32.lvs_platz_new IS

  /*
  __________________________________________________
  Author
  AGoedeke (-AG-)  17.03.2004 15:31:34
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  26.01.2011   3.5.2.1     (-AG-)   Umstellung der Parameter für die Einlagerstrategie im Lagerort
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  29.01.2007   3.3.4.2              Optimierung bei Segmenten (Füllen)
  26.01.2007   3.3.4.1              Einbau von Fehlermeldungen wenn Lagerplatz nicht gefunden
  19.06.2006   3.3.4.0              Einbau der Versionierung
  */


v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
function get_version return varchar2;
  /*
  *  Versionsverlauf
  */

  v_ort                lvs_lgr_ort%ROWTYPE;
  v_faktor_belegung_akt         number;
  v_dat_lgr_l_buchung           date;
  v_dat_lgr_bestand_ausl_faktor number;
  v_dat_lgr_regal_ebene_faktor  number;
  v_lgr_abstand_faktor          number;
  v_fahrz_res_id                isi_resource.res_id%type;
  v_fahrz_ziel_res_id           isi_resource.res_id%type;

  v_last_lgr_ort                lvs_lgr_ort.lgr_ort%type;

  v_lgr_platz_fehler            number;
  v_ignor_inventur              boolean := false;
  v_ignor_einl_suche_uml        number := 0;
  v_einl_ziel_lte_id            lvs_lte.lte_id%type := NULL;
  v_lvs_lgr_ref_platz           lvs_lgr.lgr_platz%type;

  procedure LVS_PLATZ_AUSL_BUCHEN(in_lte    in     lvs_lte%ROWTYPE,
                                  inout_lgr in out lvs_lgr%ROWTYPE);

  PROCEDURE LVS_C_LGR_PLATZ_RESERV_ART_ID(in_lgr_platz_gruppe IN lvs_lgr.lgr_platz_gruppe%TYPE,
                                          in_lvs_artikel_id   IN isi_artikel.artikel_id%TYPE,
                                          in_res_statisch     IN lvs_lgr.res_art_statisch%TYPE);

  PROCEDURE LVS_C_KORR_TE_DISP_RUECKSETZEN(in_te_sid               IN lvs_lte.sid%TYPE,
                                           in_te_firma_nr          IN lvs_lte.firma_nr%TYPE,
                                           in_lte_id               IN LVS_LTE.LTE_ID%TYPE,
                                           in_lte_status           IN lvs_lte.lte_status%TYPE,
                                           in_lte_dispo_lagerplatz IN LVS_LTE.LGR_PLATZ%TYPE,
                                           in_ls_login_id          IN isi_user.login_id%TYPE);

  PROCEDURE LVS_GET_LGR_SPERR_STATUS(in_lgr_platz     IN lvs_lgr.lgr_platz%TYPE,
                                     out_lgr_gruppe   OUT lvs_lgr.lgr_platz_gruppe%TYPE,
                                     out_sperr_status OUT lvs_lgr.gesperrt%TYPE,
                                     out_beschreibung OUT lvs_lgr.gesp_grund%TYPE);

  PROCEDURE LVS_C_SET_LGR_SPERR_STATUS(in_sperr_status     IN CHAR,
                                       in_lgr_platz        IN lvs_lgr.lgr_platz%TYPE,
                                       in_beschreibung     IN lvs_lgr.gesp_grund%TYPE);

  Procedure LVS_C_SET_LGR_VOLL_RES_STRING(in_lgr_platz        in lvs_lgr.lgr_platz%TYPE);

  PROCEDURE LVS_C_LGR_PLAETZE_KONFIG(in_abc             IN lvs_lgr.abc%TYPE,
                                     in_gefahren_klasse IN lvs_lgr.Gefahren_Klasse%TYPE,
                                     in_Wert_klasse     IN lvs_lgr.Wert_Klasse%TYPE,
                                     in_Gruppe          IN lvs_lgr.Gruppe%TYPE,
                                     in_von_lgr_platz   IN lvs_lgr.lgr_platz%TYPE,
                                     in_bis_lgr_platz   IN lvs_lgr.lgr_platz%TYPE,
                                     in_ls_login_id     IN isi_user.login_id%TYPE);

  function LVS_PLATZ_EINL_PRUEF_ERR_TEXT(in_lte           in lvs_lte%ROWTYPE,
                                         in_basis_lte_name in   lvs_lte_cfg.basis_lte_name%type,
                                         in_flaechen_stellplatz_erf  in   lvs_lte_cfg.flaechen_stellplatz_erf%type,
                                         in_lgr           in lvs_lgr%ROWTYPE,
                                         in_fahrzeuge_IDs in varchar2)
    return varchar2;

  function LVS_PLATZ_EINL_PRUEF_ERR_T_R30(in_lte           in lvs_lte%ROWTYPE,
                                          in_basis_lte_name in   lvs_lte_cfg.basis_lte_name%type,
                                          in_flaechen_stellplatz_erf  in   lvs_lte_cfg.flaechen_stellplatz_erf%type,
                                          in_lgr           in lvs_lgr%ROWTYPE,
                                          in_transport_typ            in   isi_transport.transp_typ%type,
                                          in_fahrzeuge_IDs in varchar2)
    return varchar2;

  procedure LVS_PLATZ_EINL_PRUEFEN(in_lte           in lvs_lte%ROWTYPE,
                                   in_basis_lte_name in   lvs_lte_cfg.basis_lte_name%type,
                                   in_flaechen_stellplatz_erf  in   lvs_lte_cfg.flaechen_stellplatz_erf%type,
                                   in_lgr           in lvs_lgr%ROWTYPE,
                                   in_fahrzeuge_IDs in varchar2);

  procedure LVS_PLATZ_EINL_PRUEFEN_R30(in_lte           in lvs_lte%ROWTYPE,
                                       in_basis_lte_name in   lvs_lte_cfg.basis_lte_name%type,
                                       in_flaechen_stellplatz_erf  in   lvs_lte_cfg.flaechen_stellplatz_erf%type,
                                       in_lgr           in lvs_lgr%ROWTYPE,
                                       in_transport_typ            in   isi_transport.transp_typ%type,
                                       in_fahrzeuge_IDs in varchar2);

  procedure LVS_PLATZ_EINL_BUCHEN(in_lte in lvs_lte%ROWTYPE,
                                  in_lgr in lvs_lgr%ROWTYPE);

  Procedure LVS_PLATZ_EINL_DISP_RUECKS(in_lte in lvs_lte%ROWTYPE,
                                       in_lgr in lvs_lgr%ROWTYPE);

  procedure LVS_PLATZ_EINL_DISP_SETZEN(in_lte in lvs_lte%ROWTYPE,
                                       in_lgr in lvs_lgr%ROWTYPE);

  procedure LVS_PLATZ_AUSL_DISP_SETZEN(in_lte in lvs_lte%ROWTYPE,
                                       in_lgr in lvs_lgr%ROWTYPE);

  Procedure LVS_PLATZ_AUSL_DISP_RUECKS(in_lte in lvs_lte%ROWTYPE,
                                       in_lgr in lvs_lgr%ROWTYPE);

  procedure LVS_C_PLATZ_STATISCH_RES(in_sid              in isi_sid.sid%type,
                                     in_lgr_platz_gruppe in lvs_lgr.lgr_platz_gruppe%TYPE,
                                     in_res_string       in lvs_lgr.res_string%TYPE,
                                     in_res_artikel_id   in lvs_lgr.res_artikel_id%TYPE,
                                     in_kanal_leer       in varchar2);

  function LVS_PLATZ_BEWERTEN(in_sid                 in lvs_lgr.sid%type,
                              in_firma_nr            in lvs_lgr.firma_nr%type,
                              in_lgr_ort_typ         in lvs_lgr.lgr_typ%type,
                              in_res_string          in lvs_lte.res_string%type,
                              in_lte_res_art         in lvs_lte.res_artikel_id%type,
                              in_lte_abc             in lvs_lte.abc%type,
                              in_lte_waren_typ       in lvs_lte.waren_typ%type,
                              in_lgr_platz_gruppe    in lvs_lgr.lgr_platz_gruppe%type,
                              in_lgr_res_artikel_id  in lvs_lgr.res_artikel_id%type,
                              in_lgr_res_string      in lvs_lgr.res_string%type,
                              in_lgr_abc             in lvs_lgr.abc%type,
                              in_ref_dim_lager_platz in lvs_lgr.lgr_dim_platz%type,
                              in_ref_dim_lager_ort   in lvs_lgr.lgr_ort%type,
                              in_lte_lte_akt_kg      in lvs_lte.lte_akt_kg%type,
                              in_lte_lte_vol_hoehe   in lvs_lte.lte_vol_hoehe%type,
                              in_lte_lte_vol_tiefe   in lvs_lte.lte_vol_tiefe%type,
                              in_lte_lte_vol_breite  in lvs_lte.lte_vol_breite%type,
                              in_lgr_platz           in lvs_lgr.lgr_platz%type,
                              in_lgr_opti            in lvs_lgr_ort.lgr_einl_opti%type,
                              in_sych_transport      in isi_transport.lgr_platz_quelle%type,
                              in_fahrzeuge_IDs       in varchar2,
                              in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
                              in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type                              ,
                              in_lgr_dim_g           in lvs_lgr.lgr_dim_g%type,
                              in_lgr_dim_r           in lvs_lgr.lgr_dim_r%type,
                              in_lgr_dim_p           in lvs_lgr.lgr_dim_p%type,
                              in_lgr_dim_e           in lvs_lgr.lgr_dim_e%type,
                              in_lgr_dim_t           in lvs_lgr.lgr_dim_t%type,
                              in_r_g_u_gegenueber    in lvs_lgr_ort.lgr_dim_r_g_u_gegenueber%type,
                              in_dim_platz           in lvs_lgr.lgr_dim_platz%type,
                              in_max_kg              in lvs_lgr.lgr_max_kg%type,
                              in_akt_kg              in lvs_lgr.lgr_akt_kg%type,
                              in_frei_hoehe          in lvs_lgr.lgr_frei_hoehe%type,
                              in_frei_breite         in lvs_lgr.lgr_frei_breite%type,
                              in_frei_tiefe          in lvs_lgr.lgr_frei_tiefe%type)
    return number;

  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- für individuelle Daten ohne angelegte Palette
  -------------------------------------------------------------------------
  procedure lvs_suche_allg_einl_platz(in_sid            in lvs_lte.sid%type,
                                      in_firma_nr       in lvs_lte.firma_nr%type,
                                      in_artikel_id     in lvs_lte.res_artikel_id%type,
                                      in_res_string     in lvs_lte.res_string%type,
                                      in_lte_vol_hoehe  in lvs_lte.lte_vol_hoehe%type,
                                      in_lte_vol_breite in lvs_lte.lte_vol_breite%type,
                                      in_lte_vol_tiefe  in lvs_lte.lte_vol_tiefe%type,
                                      in_lte_name       in lvs_lte.lte_name%type,
                                      in_lgr_orte       in varchar2,
                                      out_lgr_platz     out lvs_lgr.lgr_platz%type);
  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- für Liniendaten ohne angelegte Palette
  -------------------------------------------------------------------------
  procedure lvs_suche_linie_einl_platz(in_sid in lvs_prod_linie.sid%type,
                                       in_firma_nr in lvs_prod_linie.firma_nr%type,
                                       in_linie_nr in lvs_prod_linie.linie_nr%type,
                                       out_lgr_platz out lvs_lgr.lgr_platz%type);

  procedure LVS_SUCHE_LTE_EINL_PLATZ(in_lte_id         in lvs_lte.lte_id%TYPE,
                                     in_lgr_orte       in varchar2,
                                     in_fahrzeuge_IDs  in varchar2,
                                     out_lgr_platz     out lvs_lgr.lgr_platz%TYPE);

  procedure LVS_C_TRANSP_SUCHE_EINL_P_RID(in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                          in_lgr_orte             in varchar2,
                                          in_fahrzeuge_IDs        in varchar2,
                                          in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                          in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                          in_user_ID              in isi_user.login_id%TYPE,
                                          in_prio                 in isi_transport.Prio%TYPE,
                                          in_progr_nr             in isi_transport.progr_nr%TYPE,
                                          in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                          in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                          in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                          in_aktuelle_position    in lvs_lam.lam_text%type,
                                          out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                          out_transport_id        out number,
                                          out_res_id              out isi_resource.res_id%type
                                          );

  procedure LVS_TRANSP_SUCHE_EINL_P_RID(in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                        in_lgr_orte             in varchar2,
                                        in_fahrzeuge_IDs        in varchar2,
                                        in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                        in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                        in_user_ID              in isi_user.login_id%TYPE,
                                        in_prio                 in isi_transport.Prio%TYPE,
                                        in_progr_nr             in isi_transport.progr_nr%TYPE,
                                        in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                        in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                        in_aktuelle_position    in lvs_lam.lam_text%type,
                                        out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                        out_transport_id        out number,
                                        out_res_id              out isi_resource.res_id%type
                                        );

  PROCEDURE LVS_C_TRANSP_SUCHE_EINL_P_OQ(in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                         in_lgr_orte             in varchar2,
                                         in_fahrzeuge_IDs        in varchar2,
                                         in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                         in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                         in_user_ID              in isi_user.login_id%TYPE,
                                         in_prio                 in isi_transport.Prio%TYPE,
                                         in_progr_nr             in isi_transport.progr_nr%TYPE,
                                         in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                         in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                         in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                         in_aktuelle_position    in lvs_lam.lam_text%type,
                                         out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                         out_transport_id        out number);

  procedure LVS_C_TRANSP_SUCHE_EINL_PLATZ(in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                          in_lgr_orte             in varchar2,
                                          in_fahrzeuge_IDs        in varchar2,
                                          in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                          in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                          in_user_ID              in isi_user.login_id%TYPE,
                                          in_prio                 in isi_transport.Prio%TYPE,
                                          in_progr_nr             in isi_transport.progr_nr%TYPE,
                                          in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                          in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                          in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                          out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                          out_transport_id        out number);

  FUNCTION LVS_C_TRANSP_LTE(in_sid                  IN isi_sid.sid%TYPE,
                            in_firma_nr             IN isi_firma.firma_nr%TYPE,
                            in_modul_erzeuger       IN isi_transport.Modul_Erzeuger%TYPE,
                            in_modul_bearbeiter     IN isi_transport.Modul_Bearbeiter%TYPE,
                            in_frei_fahren          IN VARCHAR2,
                            in_trans_typ            in varchar2,
                            in_user_ID              IN isi_user.login_id%TYPE,
                            in_auftrag_id           IN isi_transport.Auf_Id%TYPE,
                            in_auftrag_id_extern    IN isi_transport.Auf_Id_extern%TYPE,
                            in_prio                 IN isi_transport.Prio%TYPE,
                            in_progr_nr             IN isi_transport.progr_nr%TYPE,
                            in_quelle_Leer_progr_nr IN isi_transport.quelle_leer_progr_nr%TYPE,
                            in_ziel_voll_Progr_nr   IN isi_transport.ziel_voll_progr_nr%TYPE,
                            in_lgr_quell_lgr_platz  IN LVS_LTE.LGR_PLATZ%TYPE,
                            in_lgr_ziel_lgr_platz   IN LVS_LTE.LGR_PLATZ%TYPE,
                            in_lte_id               IN lvs_lte.lte_id%TYPE,
                            in_kunde_nr             IN lvs_lam.kunden_nr%TYPE,
                            in_lieferschein         in isi_transport.lieferschein%type,
                            in_li_nr                in isi_transport.li_nr%type,
                            in_li_pos_nr            in isi_transport.li_pos_nr%type,
                            in_vorgang_id           in isi_transport.vorgang_id%type,
                            in_lkw_nr               in isi_transport.lkw_nr%type,
                            in_fahrzeuge_IDs        in varchar2,
                            in_out_transport_gruppe in out isi_transport.transport_gruppe%type)
    RETURN NUMBER;

  FUNCTION LVS_C_TRANSP_LOESCHEN(in_sid          IN isi_sid.sid%TYPE,
                                 in_firma_nr     IN isi_firma.firma_nr%TYPE,
                                 in_user_id      IN isi_user.login_id%TYPE,
                                 in_transport_id IN isi_transport.transp_id%TYPE)
    RETURN INTEGER;

  FUNCTION LVS_C_TRANSP_ZUWEISEN(in_sid          IN isi_sid.sid%TYPE,
                                 in_firma_nr     IN isi_firma.firma_nr%TYPE,
                                 in_user_id      IN isi_user.login_id%TYPE,
                                 in_transport_id IN isi_transport.transp_id%TYPE,
                                 in_res_id       in isi_resource.res_id%type)
    RETURN INTEGER;

  function lvs_c_transp_reset(in_sid          in isi_sid.sid%type,
                            in_firma_nr     IN isi_firma.firma_nr%TYPE,
                            in_user_id      IN isi_user.login_id%TYPE,
                            in_transport_id IN isi_transport.transp_id%TYPE,
                            in_res_id       in isi_resource.res_id%type)
    return integer;

  procedure lvs_c_transport_abbr(in_sid                  in isi_sid.sid%type,
                             in_firma                in isi_firma.firma_nr%type,
                             in_res_id               in isi_resource.res_id%type
                            );

  FUNCTION LVS_C_TRANSP_BEGINNEN(in_sid          IN isi_sid.sid%TYPE,
                                 in_firma_nr     IN isi_firma.firma_nr%TYPE,
                                 in_user_id      IN isi_user.login_id%TYPE,
                                 in_transport_id IN isi_transport.transp_id%TYPE,
                                 in_lte_id       in lvs_lte.lte_id%type,
                                 in_res_id       in isi_resource.res_id%type)
    RETURN INTEGER;

  FUNCTION LVS_C_TRANSP_TRANSPORT(in_sid             IN isi_sid.sid%TYPE,
                                  in_firma_nr        IN isi_firma.firma_nr%TYPE,
                                  in_user_id         IN isi_user.login_id%TYPE,
                                  in_transport_id    IN isi_transport.transp_id%TYPE,
                                  in_lte_id          in lvs_lte.lte_id%type,
                                  in_res_id          in isi_resource.res_id%type,
                                  in_out_lam_bh_vorg in out isi_transport.lam_bh_vorgang_id%type)
    RETURN INTEGER;

  FUNCTION LVS_C_TRANSP_NEUES_ZIEL(in_sid           IN  isi_sid.sid%TYPE,
                                   in_firma_nr      IN  isi_firma.firma_nr%TYPE,
                                   in_user_id       IN  isi_user.login_id%TYPE,
                                   in_transport_id  IN  isi_transport.transp_id%TYPE,
                                   in_neues_ziel    IN  isi_transport.lgr_platz_ziel %TYPE,
                                   out_res_id       out isi_resource.res_id%type)
    RETURN INTEGER;

  FUNCTION LVS_C_TRANSP_FERTIG(in_sid          IN isi_sid.sid%TYPE,
                               in_firma_nr     IN isi_firma.firma_nr%TYPE,
                               in_user_id      IN isi_user.login_id%TYPE,
                               in_transport_id IN isi_transport.transp_id%TYPE,
                               in_lte_id       in lvs_lte.lte_id%type,
                               in_res_id       in isi_resource.res_id%type,
                               in_lgr_platz    in lvs_lgr.lgr_platz%type,
                               in_ausgelagert  in varchar2) RETURN INTEGER;


  FUNCTION LVS_C_TRANSP_FERTIG_353(in_sid          IN isi_sid.sid%TYPE,
                                   in_firma_nr     IN isi_firma.firma_nr%TYPE,
                                   in_user_id      IN isi_user.login_id%TYPE,
                                   in_transport_id IN isi_transport.transp_id%TYPE,
                                   in_lte_id       in lvs_lte.lte_id%type,
                                   in_res_id       in isi_resource.res_id%type,
                                   in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                   in_ausgelagert  in varchar2,
                                   in_offset_x     in lvs_lte.lte_offset_x%type,
                                   in_offset_y     in lvs_lte.lte_offset_y%type,
                                   in_offset_z        in lvs_lte.lte_offset_z%type) RETURN INTEGER;

  procedure LVS_SUCHE_UM_PLATZ(in_lte            IN lvs_lte%ROWTYPE,
                               in_basis_lte_name in lvs_lte_cfg.basis_lte_name%type,
                               in_flaechen_stellplatz_erf  in   lvs_lte_cfg.flaechen_stellplatz_erf%type,
                               in_lvs_akt_lgr    IN lvs_lgr%ROWTYPE,
                               in_fahrzeuge_IDs  in varchar2,
                               out_lvs_lgr       OUT lvs_lgr%ROWTYPE);

  procedure c_lvs_lte_transport_353(in_lte_id        in lvs_lte.lte_id%type,
                                    in_von_lgr_platz in lvs_lgr.lgr_platz%type,
                                    in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
                                    in_user_id       in isi_user.login_id%type,
                                    in_offset_x      in lvs_lte.lte_offset_x%type,
                                    in_offset_y      in lvs_lte.lte_offset_y%type,
                                    in_offset_z      in lvs_lte.lte_offset_z%type);

  FUNCTION LVS_C_TRANSP_CHECK_ZUGRIFF(in_sid              in isi_sid.sid%type,
                                      in_firma_nr         in isi_firma.firma_nr%type,
                                      in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
                                      in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
                                      in_frei_fahren      in varchar2,
                                      in_user_id          in isi_user.login_id%type,
                                      in_transport_id     in isi_transport.transp_id%type,
                                      in_fahrzeuge_IDs  in varchar2)
    RETURN PLS_INTEGER;

  procedure LVS_PLATZ_PRUEFEN(in_sid          in isi_sid.sid%type,
                              in_lte_id       in lvs_lte.lte_id%TYPE,
                              in_lgr_platz    in lvs_lgr.lgr_platz%TYPE,
                              in_module_bearb in lvs_lgr_ort.lgr_ort_modul%TYPE,
                              in_einl_ausl    in varchar2,
                              in_fahrzeuge_IDs  in varchar2);

  procedure LVS_C_PLATZ_GRUPPE_LOESCHEN(in_sid                    in isi_sid.sid%type,
                                        in_firma_nr               in isi_firma.firma_nr%type,
                                        in_lgr_ort                in lvs_lgr.lgr_ort%type,
                                        in_lgr_platz_gruppe       in lvs_lgr.lgr_platz_gruppe%type);


  procedure LVS_C_PLATZ_AENDERN(in_sid                    in isi_sid.sid%type,
                                        in_firma_nr               in isi_firma.firma_nr%type,
                                        in_lgr_ort                in lvs_lgr.lgr_ort%type,
                                        in_lgr_platz_alt          in lvs_lgr.lgr_platz%type,
                                        in_lgr_platz_neu          in lvs_lgr.lgr_platz%type,
                                        in_lgr_platz_gruppe_neu   in lvs_lgr.lgr_platz_gruppe%type,
                                        in_pos_x                  in lvs_lgr.lgr_pos_x%type,
                                        in_pos_y                  in lvs_lgr.lgr_pos_y%type,
                                        in_dim_p                  in lvs_lgr.lgr_dim_p%type,
                                        in_dim_t                  in lvs_lgr.lgr_dim_t%type,
                                        in_hoehe                  in lvs_lgr.lgr_vol_hoehe%type,
                                        in_breite                 in lvs_lgr.lgr_vol_breite%type,
                                        in_tiefe                  in lvs_lgr.lgr_vol_breite%type,
                                        in_lte_min_hoehe          in lvs_lgr.lgr_min_lte_hoehe%type,
                                        in_lte_min_breite         in lvs_lgr.lgr_min_lte_breite%type,
                                        in_lte_min_tiefe          in lvs_lgr.lgr_min_lte_tiefe%type,
                                        in_lte_max_te             in lvs_lgr.lgr_max_te%type,
                                        in_gesperrt               in lvs_lgr.gesperrt%type,

                                        in_abc                    in lvs_lgr.abc%type,
                                        login_id                   in lvs_lgr.lgr_usr_id_erstellt%type);
   procedure LVS_C_PLATZ_KLONEN(in_sid                    in isi_sid.sid%type,
                                        in_firma_nr               in isi_firma.firma_nr%type,
                                        in_lgr_ort                in lvs_lgr.lgr_ort%type,
                                        in_klonen_von_lgr_platz   in lvs_lgr.lgr_platz%type,
                                        in_lgr_platz              in lvs_lgr.lgr_platz%type,
                                        in_lgr_platz_gruppe       in lvs_lgr.lgr_platz_gruppe%type,
                                        in_pos_x                  in lvs_lgr.lgr_pos_x%type,
                                        in_pos_y                  in lvs_lgr.lgr_pos_y%type,
                                        in_dim_p                  in lvs_lgr.lgr_dim_p%type,
                                        in_dim_t                  in lvs_lgr.lgr_dim_t%type,
                                        in_hoehe                  in lvs_lgr.lgr_vol_hoehe%type,
                                        in_breite                 in lvs_lgr.lgr_vol_breite%type,
                                        in_tiefe                  in lvs_lgr.lgr_vol_breite%type,
                                        in_abc                    in lvs_lgr.abc%type,
                                        login_id                   in lvs_lgr.lgr_usr_id_erstellt%type);

  procedure LVS_C_PLATZ_LOESCHEN(in_sid             in isi_sid.sid%type,
                                 in_firma_nr        in isi_firma.firma_nr%type,
                                 in_lgr_ort         in lvs_lgr.lgr_ort%type,
                                 in_von_lgr_dim_g   in lvs_lgr.lgr_dim_g%type,
                                 in_bis_lgr_dim_g   in lvs_lgr.lgr_dim_g%type,
                                 in_von_lgr_dim_r   in lvs_lgr.lgr_dim_r%type,
                                 in_bis_lgr_dim_r   in lvs_lgr.lgr_dim_r%type,
                                 in_von_lgr_dim_p   in lvs_lgr.lgr_dim_p%type,
                                 in_bis_lgr_dim_p   in lvs_lgr.lgr_dim_p%type,
                                 in_von_lgr_dim_e   in lvs_lgr.lgr_dim_e%type,
                                 in_bis_lgr_dim_e   in lvs_lgr.lgr_dim_e%type,
                                 in_von_lgr_dim_t   in lvs_lgr.lgr_dim_t%type,
                                 in_bis_lgr_dim_t   in lvs_lgr.lgr_dim_t%type);

  function LVS_SUCHE_FLAECHENPLATZ(in_sid in isi_sid.sid%type,
                                    in_firma_nr               in isi_firma.firma_nr%type,
                                    in_lgr_ort                in lvs_lgr.lgr_ort%type,
                                    in_out_pos_x              in out lvs_lgr.lgr_pos_x%type,
                                    in_out_pos_y              in out lvs_lgr.lgr_pos_y%type,
                                    out_breite                out lvs_lgr.lgr_vol_breite%type,
                                    out_tiefe                 out lvs_lgr.lgr_vol_tiefe%type
                                                                       ) RETURN varchar2;


  function lvs_get_lgr_offset_z(in_lgr_platz     in lvs_lgr.lgr_platz%type)
                             return number;
  
  function LVS_PLATZ_BEWERTEN_EXT(in_sid                 in lvs_lgr.sid%type,
                              in_firma_nr            in lvs_lgr.firma_nr%type,
                              in_lgr_ort_typ         in lvs_lgr.lgr_typ%type,
                              in_res_string          in lvs_lte.res_string%type,
                              in_lte_res_art         in lvs_lte.res_artikel_id%type,
                              in_lte_abc             in lvs_lte.abc%type,
                              in_lte_waren_typ       in lvs_lte.waren_typ%type,
                              in_lgr_platz_gruppe    in lvs_lgr.lgr_platz_gruppe%type,
                              in_lgr_res_artikel_id  in lvs_lgr.res_artikel_id%type,
                              in_lgr_res_string      in lvs_lgr.res_string%type,
                              in_lgr_abc             in lvs_lgr.abc%type,
                              in_ref_dim_lager_platz in lvs_lgr.lgr_dim_platz%type,
                              in_ref_dim_lager_ort   in lvs_lgr.lgr_ort%type,
                              in_lte_lte_akt_kg      in lvs_lte.lte_akt_kg%type,
                              in_lte_lte_vol_hoehe   in lvs_lte.lte_vol_hoehe%type,
                              in_lte_lte_vol_tiefe   in lvs_lte.lte_vol_tiefe%type,
                              in_lte_lte_vol_breite  in lvs_lte.lte_vol_breite%type,
                              in_lgr_platz           in lvs_lgr.lgr_platz%type,
                              in_lgr_opti            in lvs_lgr_ort.lgr_einl_opti%type,
                              in_sych_transport      in isi_transport.lgr_platz_quelle%type,
                              in_fahrzeuge_IDs       in varchar2,
                              in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
                              in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type                              ,
                              in_lgr_dim_g           in lvs_lgr.lgr_dim_g%type,
                              in_lgr_dim_r           in lvs_lgr.lgr_dim_r%type,
                              in_lgr_dim_p           in lvs_lgr.lgr_dim_p%type,
                              in_lgr_dim_e           in lvs_lgr.lgr_dim_e%type,
                              in_lgr_dim_t           in lvs_lgr.lgr_dim_t%type,
                              in_r_g_u_gegenueber    in lvs_lgr_ort.lgr_dim_r_g_u_gegenueber%type,
                              in_dim_platz           in lvs_lgr.lgr_dim_platz%type,
                              in_max_kg              in lvs_lgr.lgr_max_kg%type,
                              in_akt_kg              in lvs_lgr.lgr_akt_kg%type,
                              in_frei_hoehe          in lvs_lgr.lgr_frei_hoehe%type,
                              in_frei_breite         in lvs_lgr.lgr_frei_breite%type,
                              in_frei_tiefe          in lvs_lgr.lgr_frei_tiefe%type,
                              in_lgr_ort             in lvs_lgr.lgr_ort%type) return number;
END lvs_platz_new;
/



-- sqlcl_snapshot {"hash":"ec282da3bbe14f7be79a64582a4ac456c1084b25","type":"PACKAGE_SPEC","name":"LVS_PLATZ_NEW","schemaName":"DIRKSPZM32","sxml":""}