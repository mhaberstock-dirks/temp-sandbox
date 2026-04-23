create or replace package dirkspzm32.lvs_platz_new is

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

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;
  /*
  *  Versionsverlauf
  */

    v_ort lvs_lgr_ort%rowtype;
    v_faktor_belegung_akt number;
    v_dat_lgr_l_buchung date;
    v_dat_lgr_bestand_ausl_faktor number;
    v_dat_lgr_regal_ebene_faktor number;
    v_lgr_abstand_faktor number;
    v_fahrz_res_id isi_resource.res_id%type;
    v_fahrz_ziel_res_id isi_resource.res_id%type;
    v_last_lgr_ort lvs_lgr_ort.lgr_ort%type;
    v_lgr_platz_fehler number;
    v_ignor_inventur boolean := false;
    v_ignor_einl_suche_uml number := 0;
    v_einl_ziel_lte_id lvs_lte.lte_id%type := null;
    v_lvs_lgr_ref_platz lvs_lgr.lgr_platz%type;
    procedure lvs_platz_ausl_buchen (
        in_lte    in lvs_lte%rowtype,
        inout_lgr in out lvs_lgr%rowtype
    );

    procedure lvs_c_lgr_platz_reserv_art_id (
        in_lgr_platz_gruppe in lvs_lgr.lgr_platz_gruppe%type,
        in_lvs_artikel_id   in isi_artikel.artikel_id%type,
        in_res_statisch     in lvs_lgr.res_art_statisch%type
    );

    procedure lvs_c_korr_te_disp_ruecksetzen (
        in_te_sid               in lvs_lte.sid%type,
        in_te_firma_nr          in lvs_lte.firma_nr%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_lte_dispo_lagerplatz in lvs_lte.lgr_platz%type,
        in_ls_login_id          in isi_user.login_id%type
    );

    procedure lvs_get_lgr_sperr_status (
        in_lgr_platz     in lvs_lgr.lgr_platz%type,
        out_lgr_gruppe   out lvs_lgr.lgr_platz_gruppe%type,
        out_sperr_status out lvs_lgr.gesperrt%type,
        out_beschreibung out lvs_lgr.gesp_grund%type
    );

    procedure lvs_c_set_lgr_sperr_status (
        in_sperr_status in char,
        in_lgr_platz    in lvs_lgr.lgr_platz%type,
        in_beschreibung in lvs_lgr.gesp_grund%type
    );

    procedure lvs_c_set_lgr_voll_res_string (
        in_lgr_platz in lvs_lgr.lgr_platz%type
    );

    procedure lvs_c_lgr_plaetze_konfig (
        in_abc             in lvs_lgr.abc%type,
        in_gefahren_klasse in lvs_lgr.gefahren_klasse%type,
        in_wert_klasse     in lvs_lgr.wert_klasse%type,
        in_gruppe          in lvs_lgr.gruppe%type,
        in_von_lgr_platz   in lvs_lgr.lgr_platz%type,
        in_bis_lgr_platz   in lvs_lgr.lgr_platz%type,
        in_ls_login_id     in isi_user.login_id%type
    );

    function lvs_platz_einl_pruef_err_text (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lgr                     in lvs_lgr%rowtype,
        in_fahrzeuge_ids           in varchar2
    ) return varchar2;

    function lvs_platz_einl_pruef_err_t_r30 (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lgr                     in lvs_lgr%rowtype,
        in_transport_typ           in isi_transport.transp_typ%type,
        in_fahrzeuge_ids           in varchar2
    ) return varchar2;

    procedure lvs_platz_einl_pruefen (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lgr                     in lvs_lgr%rowtype,
        in_fahrzeuge_ids           in varchar2
    );

    procedure lvs_platz_einl_pruefen_r30 (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lgr                     in lvs_lgr%rowtype,
        in_transport_typ           in isi_transport.transp_typ%type,
        in_fahrzeuge_ids           in varchar2
    );

    procedure lvs_platz_einl_buchen (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    );

    procedure lvs_platz_einl_disp_ruecks (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    );

    procedure lvs_platz_einl_disp_setzen (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    );

    procedure lvs_platz_ausl_disp_setzen (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    );

    procedure lvs_platz_ausl_disp_ruecks (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    );

    procedure lvs_c_platz_statisch_res (
        in_sid              in isi_sid.sid%type,
        in_lgr_platz_gruppe in lvs_lgr.lgr_platz_gruppe%type,
        in_res_string       in lvs_lgr.res_string%type,
        in_res_artikel_id   in lvs_lgr.res_artikel_id%type,
        in_kanal_leer       in varchar2
    );

    function lvs_platz_bewerten (
        in_sid                 in lvs_lgr.sid%type,
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
        in_fahrzeuge_ids       in varchar2,
        in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
        in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type,
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
        in_frei_tiefe          in lvs_lgr.lgr_frei_tiefe%type
    ) return number;

  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- für individuelle Daten ohne angelegte Palette
  -------------------------------------------------------------------------
    procedure lvs_suche_allg_einl_platz (
        in_sid            in lvs_lte.sid%type,
        in_firma_nr       in lvs_lte.firma_nr%type,
        in_artikel_id     in lvs_lte.res_artikel_id%type,
        in_res_string     in lvs_lte.res_string%type,
        in_lte_vol_hoehe  in lvs_lte.lte_vol_hoehe%type,
        in_lte_vol_breite in lvs_lte.lte_vol_breite%type,
        in_lte_vol_tiefe  in lvs_lte.lte_vol_tiefe%type,
        in_lte_name       in lvs_lte.lte_name%type,
        in_lgr_orte       in varchar2,
        out_lgr_platz     out lvs_lgr.lgr_platz%type
    );
  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- für Liniendaten ohne angelegte Palette
  -------------------------------------------------------------------------
    procedure lvs_suche_linie_einl_platz (
        in_sid        in lvs_prod_linie.sid%type,
        in_firma_nr   in lvs_prod_linie.firma_nr%type,
        in_linie_nr   in lvs_prod_linie.linie_nr%type,
        out_lgr_platz out lvs_lgr.lgr_platz%type
    );

    procedure lvs_suche_lte_einl_platz (
        in_lte_id        in lvs_lte.lte_id%type,
        in_lgr_orte      in varchar2,
        in_fahrzeuge_ids in varchar2,
        out_lgr_platz    out lvs_lgr.lgr_platz%type
    );

    procedure lvs_c_transp_suche_einl_p_rid (
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type
    );

    procedure lvs_transp_suche_einl_p_rid (
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type
    );

    procedure lvs_c_transp_suche_einl_p_oq (
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number
    );

    procedure lvs_c_transp_suche_einl_platz (
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number
    );

    function lvs_c_transp_lte (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_frei_fahren          in varchar2,
        in_trans_typ            in varchar2,
        in_user_id              in isi_user.login_id%type,
        in_auftrag_id           in isi_transport.auf_id%type,
        in_auftrag_id_extern    in isi_transport.auf_id_extern%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_quell_lgr_platz  in lvs_lte.lgr_platz%type,
        in_lgr_ziel_lgr_platz   in lvs_lte.lgr_platz%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_kunde_nr             in lvs_lam.kunden_nr%type,
        in_lieferschein         in isi_transport.lieferschein%type,
        in_li_nr                in isi_transport.li_nr%type,
        in_li_pos_nr            in isi_transport.li_pos_nr%type,
        in_vorgang_id           in isi_transport.vorgang_id%type,
        in_lkw_nr               in isi_transport.lkw_nr%type,
        in_fahrzeuge_ids        in varchar2,
        in_out_transport_gruppe in out isi_transport.transport_gruppe%type
    ) return number;

    function lvs_c_transp_loeschen (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type
    ) return integer;

    function lvs_c_transp_zuweisen (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_res_id       in isi_resource.res_id%type
    ) return integer;

    function lvs_c_transp_reset (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_res_id       in isi_resource.res_id%type
    ) return integer;

    procedure lvs_c_transport_abbr (
        in_sid    in isi_sid.sid%type,
        in_firma  in isi_firma.firma_nr%type,
        in_res_id in isi_resource.res_id%type
    );

    function lvs_c_transp_beginnen (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_lte_id       in lvs_lte.lte_id%type,
        in_res_id       in isi_resource.res_id%type
    ) return integer;

    function lvs_c_transp_transport (
        in_sid             in isi_sid.sid%type,
        in_firma_nr        in isi_firma.firma_nr%type,
        in_user_id         in isi_user.login_id%type,
        in_transport_id    in isi_transport.transp_id%type,
        in_lte_id          in lvs_lte.lte_id%type,
        in_res_id          in isi_resource.res_id%type,
        in_out_lam_bh_vorg in out isi_transport.lam_bh_vorgang_id%type
    ) return integer;

    function lvs_c_transp_neues_ziel (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_neues_ziel   in isi_transport.lgr_platz_ziel%type,
        out_res_id      out isi_resource.res_id%type
    ) return integer;

    function lvs_c_transp_fertig (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_lte_id       in lvs_lte.lte_id%type,
        in_res_id       in isi_resource.res_id%type,
        in_lgr_platz    in lvs_lgr.lgr_platz%type,
        in_ausgelagert  in varchar2
    ) return integer;

    function lvs_c_transp_fertig_353 (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_lte_id       in lvs_lte.lte_id%type,
        in_res_id       in isi_resource.res_id%type,
        in_lgr_platz    in lvs_lgr.lgr_platz%type,
        in_ausgelagert  in varchar2,
        in_offset_x     in lvs_lte.lte_offset_x%type,
        in_offset_y     in lvs_lte.lte_offset_y%type,
        in_offset_z     in lvs_lte.lte_offset_z%type
    ) return integer;

    procedure lvs_suche_um_platz (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lvs_akt_lgr             in lvs_lgr%rowtype,
        in_fahrzeuge_ids           in varchar2,
        out_lvs_lgr                out lvs_lgr%rowtype
    );

    procedure c_lvs_lte_transport_353 (
        in_lte_id        in lvs_lte.lte_id%type,
        in_von_lgr_platz in lvs_lgr.lgr_platz%type,
        in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
        in_user_id       in isi_user.login_id%type,
        in_offset_x      in lvs_lte.lte_offset_x%type,
        in_offset_y      in lvs_lte.lte_offset_y%type,
        in_offset_z      in lvs_lte.lte_offset_z%type
    );

    function lvs_c_transp_check_zugriff (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
        in_frei_fahren      in varchar2,
        in_user_id          in isi_user.login_id%type,
        in_transport_id     in isi_transport.transp_id%type,
        in_fahrzeuge_ids    in varchar2
    ) return pls_integer;

    procedure lvs_platz_pruefen (
        in_sid           in isi_sid.sid%type,
        in_lte_id        in lvs_lte.lte_id%type,
        in_lgr_platz     in lvs_lgr.lgr_platz%type,
        in_module_bearb  in lvs_lgr_ort.lgr_ort_modul%type,
        in_einl_ausl     in varchar2,
        in_fahrzeuge_ids in varchar2
    );

    procedure lvs_c_platz_gruppe_loeschen (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_lgr_ort          in lvs_lgr.lgr_ort%type,
        in_lgr_platz_gruppe in lvs_lgr.lgr_platz_gruppe%type
    );

    procedure lvs_c_platz_aendern (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lgr_ort              in lvs_lgr.lgr_ort%type,
        in_lgr_platz_alt        in lvs_lgr.lgr_platz%type,
        in_lgr_platz_neu        in lvs_lgr.lgr_platz%type,
        in_lgr_platz_gruppe_neu in lvs_lgr.lgr_platz_gruppe%type,
        in_pos_x                in lvs_lgr.lgr_pos_x%type,
        in_pos_y                in lvs_lgr.lgr_pos_y%type,
        in_dim_p                in lvs_lgr.lgr_dim_p%type,
        in_dim_t                in lvs_lgr.lgr_dim_t%type,
        in_hoehe                in lvs_lgr.lgr_vol_hoehe%type,
        in_breite               in lvs_lgr.lgr_vol_breite%type,
        in_tiefe                in lvs_lgr.lgr_vol_breite%type,
        in_lte_min_hoehe        in lvs_lgr.lgr_min_lte_hoehe%type,
        in_lte_min_breite       in lvs_lgr.lgr_min_lte_breite%type,
        in_lte_min_tiefe        in lvs_lgr.lgr_min_lte_tiefe%type,
        in_lte_max_te           in lvs_lgr.lgr_max_te%type,
        in_gesperrt             in lvs_lgr.gesperrt%type,
        in_abc                  in lvs_lgr.abc%type,
        login_id                in lvs_lgr.lgr_usr_id_erstellt%type
    );

    procedure lvs_c_platz_klonen (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lgr_ort              in lvs_lgr.lgr_ort%type,
        in_klonen_von_lgr_platz in lvs_lgr.lgr_platz%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lgr_platz_gruppe     in lvs_lgr.lgr_platz_gruppe%type,
        in_pos_x                in lvs_lgr.lgr_pos_x%type,
        in_pos_y                in lvs_lgr.lgr_pos_y%type,
        in_dim_p                in lvs_lgr.lgr_dim_p%type,
        in_dim_t                in lvs_lgr.lgr_dim_t%type,
        in_hoehe                in lvs_lgr.lgr_vol_hoehe%type,
        in_breite               in lvs_lgr.lgr_vol_breite%type,
        in_tiefe                in lvs_lgr.lgr_vol_breite%type,
        in_abc                  in lvs_lgr.abc%type,
        login_id                in lvs_lgr.lgr_usr_id_erstellt%type
    );

    procedure lvs_c_platz_loeschen (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_lgr_ort       in lvs_lgr.lgr_ort%type,
        in_von_lgr_dim_g in lvs_lgr.lgr_dim_g%type,
        in_bis_lgr_dim_g in lvs_lgr.lgr_dim_g%type,
        in_von_lgr_dim_r in lvs_lgr.lgr_dim_r%type,
        in_bis_lgr_dim_r in lvs_lgr.lgr_dim_r%type,
        in_von_lgr_dim_p in lvs_lgr.lgr_dim_p%type,
        in_bis_lgr_dim_p in lvs_lgr.lgr_dim_p%type,
        in_von_lgr_dim_e in lvs_lgr.lgr_dim_e%type,
        in_bis_lgr_dim_e in lvs_lgr.lgr_dim_e%type,
        in_von_lgr_dim_t in lvs_lgr.lgr_dim_t%type,
        in_bis_lgr_dim_t in lvs_lgr.lgr_dim_t%type
    );

    function lvs_suche_flaechenplatz (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_lgr_ort   in lvs_lgr.lgr_ort%type,
        in_out_pos_x in out lvs_lgr.lgr_pos_x%type,
        in_out_pos_y in out lvs_lgr.lgr_pos_y%type,
        out_breite   out lvs_lgr.lgr_vol_breite%type,
        out_tiefe    out lvs_lgr.lgr_vol_tiefe%type
    ) return varchar2;

    function lvs_get_lgr_offset_z (
        in_lgr_platz in lvs_lgr.lgr_platz%type
    ) return number;

    function lvs_platz_bewerten_ext (
        in_sid                 in lvs_lgr.sid%type,
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
        in_fahrzeuge_ids       in varchar2,
        in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
        in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type,
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
        in_lgr_ort             in lvs_lgr.lgr_ort%type
    ) return number;

end lvs_platz_new;
/


-- sqlcl_snapshot {"hash":"0ff4f0069a7483fccf897a5f4df841c94310d864","type":"PACKAGE_SPEC","name":"LVS_PLATZ_NEW","schemaName":"DIRKSPZM32","sxml":""}