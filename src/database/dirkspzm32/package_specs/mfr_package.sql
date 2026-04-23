create or replace package dirkspzm32.mfr_package is

  /*
  __________________________________________________
  Author
  BWELLING (-BW-)  08.06.2004 13:12:38
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  17.11.2009   3.4.12      (-BW-)   Neue Funktion c_we_lte_suche_einl_platz für LVS Palettentransport auf LVS WE!
               3.3.4.0     (-BW-)   Neue Funktion fuer Externen WE
  */

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;

    function mfr_sim_get_einlager_lte_id (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type
    ) return varchar2;

    procedure c_sc_ean_create_lte_print (
        in_scanner_name in isi_scanner_cfg.scanner_name%type,
        in_barcode      in isi_scanner_cfg.scanner_daten%type,
        in_login_id     in isi_user.login_id%type
    );

    procedure c_lte_artikel_erz_lgr_ort_text (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type,
        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
        in_lam_text            in lvs_lam.lam_text%type
    );

    procedure c_erzeuge_lte_einl_lgr_ort_v (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_artikel              in isi_artikel.artikel%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_menge                in lvs_lam.menge%type,
        in_login_id             in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_fahrzeuge_ids        in varchar2,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        in_lte_hoehe            in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite           in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe            in lvs_lte.lte_vol_tiefe%type,
        out_lte_id              out lvs_lte.lte_id%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type,
        io_error                in out varchar2
    );

    procedure c_erzeuge_lte_einl_lgr_ort (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_artikel              in isi_artikel.artikel%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_menge                in lvs_lam.menge%type,
        in_login_id             in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_fahrzeuge_ids        in varchar2,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lte_id              out lvs_lte.lte_id%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type
    );

    procedure c_erzeuge_lte_lgr_ort (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_artikel              in isi_artikel.artikel%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_menge                in lvs_lam.menge%type,
        in_login_id             in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lte_id              out lvs_lte.lte_id%type
    );

    procedure c_erzeuge_artikel_ausl_auf (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_artikel  in isi_artikel.artikel%type,
        in_charge   in lvs_charge.charge_bez%type,
        in_menge    in lvs_lam.menge%type,
        in_login_id in isi_user.login_id%type,
        in_lgr_orte in varchar2,
        in_ziel     in lvs_lgr.lgr_platz%type
    );

    function pruefe_transport_f_ziel (
        in_ziel in varchar2
    ) return varchar2;

    procedure c_we_lte_transp_einl_platz (
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

    function lte_anfordern_name (
        in_lte_sid      in lvs_lte.sid%type,
        in_lte_firma_nr in lvs_lte.firma_nr%type,
        in_lte_id       in lvs_lte.lte_id%type
    ) return lvs_lte.lte_name%type;

    procedure c_art_id_suche_ausl (
        in_sid            in lvs_lam.sid%type,
        in_firma_nr       in lvs_lam.firma_nr%type,
        in_artikel_id     in lvs_lam.artikel_id%type,
        in_lager_orte     in varchar2,
        in_ziel_lgr_platz in lvs_lgr.lgr_platz%type,
        in_login_id       in isi_user.login_id%type
    );

    procedure c_art_nr_suche_ausl (
        in_sid            in lvs_lam.sid%type,
        in_firma_nr       in lvs_lam.firma_nr%type,
        in_artikel        in isi_artikel.artikel%type,
        in_lager_orte     in varchar2,
        in_ziel_lgr_platz in lvs_lgr.lgr_platz%type,
        in_login_id       in isi_user.login_id%type
    );

    function c_erzeuge_art_nr_ausl_auf_tms (
        in_sid            in lvs_lam.sid%type,
        in_firma_nr       in lvs_lam.firma_nr%type,
        in_artikel        in isi_artikel.artikel%type,
        in_lager_orte     in varchar2,
        in_ziel_lgr_platz in lvs_lgr.lgr_platz%type,
        in_login_id       in isi_user.login_id%type,
        in_prio           in isi_transport.prio%type
    ) return number;

    function c_erzeuge_art_id_ausl_auf_tms (
        in_sid            in lvs_lam.sid%type,
        in_firma_nr       in lvs_lam.firma_nr%type,
        in_artikel_id     in isi_artikel.artikel_id%type,
        in_lager_orte     in varchar2,
        in_ziel_lgr_platz in lvs_lgr.lgr_platz%type,
        in_login_id       in isi_user.login_id%type,
        in_prio           in isi_transport.prio%type
    ) return number;

    procedure c_transp_log (
        in_type          in mfr_transp_log.type%type,
        in_element       in mfr_transp_log.element%type,
        in_source        in mfr_transp_log.source%type,
        in_target        in mfr_transp_log.target%type,
        in_origin_source in mfr_transp_log.origin_source%type,
        in_final_dest    in mfr_transp_log.final_dest%type,
        in_lte_id        in mfr_transp_log.lte_id%type,
        in_mfr_unique_id in mfr_transp_log.mfr_unique_id%type,
        in_is_nio        in mfr_transp_log.is_nio%type,
        out_guid         out mfr_transp_log.guid%type,
        in_duration_sec  in mfr_transp_log.duration_sec%type
    );

    procedure c_transp_log_nio (
        in_guid          mfr_transp_log_nio.mfr_transp_log_id%type,
        in_nio_bit_index number
    );

    procedure c_transp_log_with_nio (
        in_type          in mfr_transp_log.type%type,
        in_element       in mfr_transp_log.element%type,
        in_source        in mfr_transp_log.source%type,
        in_target        in mfr_transp_log.target%type,
        in_origin_source in mfr_transp_log.origin_source%type,
        in_final_dest    in mfr_transp_log.final_dest%type,
        in_lte_id        in mfr_transp_log.lte_id%type,
        in_mfr_unique_id in mfr_transp_log.mfr_unique_id%type,
        in_is_nio        in mfr_transp_log.is_nio%type,
        in_nio_bits      number,
        out_guid         out mfr_transp_log.guid%type,
        in_duration_sec  in mfr_transp_log.duration_sec%type
    );

    function lvs_check_transport_ziel (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_transport_id in isi_transport.transp_id%type
    ) return lvs_lgr.lgr_platz%type;

    function lte_lhm_info (
        in_lte_id   in lvs_lte.lte_id%type,
        out_akt_lhm out number,
        out_max_lhm out number
    ) return varchar2;

    function c_lvs_transp_lte (
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
        in_kunde_nr             in lvs_lam.kunden_nr%type, -- Hier Adress_ID
        in_lieferschein         in isi_transport.lieferschein%type,
        in_li_nr                in isi_transport.li_nr%type,
        in_li_pos_nr            in isi_transport.li_pos_nr%type,
        in_vorgang_id           in isi_transport.vorgang_id%type,
        in_fahrzeuge_ids        in varchar2,
        in_lkw_nr               in isi_transport.lkw_nr%type,
        in_out_transport_gruppe in out isi_transport.transport_gruppe%type,
        out_transp_id           out isi_transport.transp_id%type,
        in_parent_transp_id     in isi_transport.transp_id%type default null,
        in_fetig_bis            in date default null
    ) return number;

    function lvs_c_transp_lte_353 (
        in_sid                     in isi_sid.sid%type,
        in_firma_nr                in isi_firma.firma_nr%type,
        in_modul_erzeuger          in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter        in isi_transport.modul_bearbeiter%type,
        in_frei_fahren             in varchar2,
        in_trans_typ               in varchar2,
        in_user_id                 in isi_user.login_id%type,
        in_auftrag_id              in isi_transport.auf_id%type,
        in_auftrag_id_extern       in isi_transport.auf_id_extern%type,
        in_prio                    in isi_transport.prio%type,
        in_progr_nr                in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr    in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr      in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_quell_lgr_platz     in lvs_lte.lgr_platz%type,
        in_lgr_ziel_lgr_platz      in lvs_lte.lgr_platz%type,
        in_lte_id                  in lvs_lte.lte_id%type,
        in_kunde_nr                in lvs_lam.kunden_nr%type,
        in_lieferschein            in isi_transport.lieferschein%type,
        in_li_nr                   in isi_transport.li_nr%type,
        in_li_pos_nr               in isi_transport.li_pos_nr%type,
        in_vorgang_id              in isi_transport.vorgang_id%type,
        in_lkw_nr                  in isi_transport.lkw_nr%type,
        in_fahrzeuge_ids           in varchar2,
        in_komm_id                 in isi_transport.p_komm_id%type,
        in_komm_lte_lhm_lagen      in isi_transport.p_komm_lte_lhm_lagen%type,
        in_komm_lte_lhm_pro_lage   in isi_transport.p_komm_lte_lhm_pro_lage%type,
        in_komm_lhm_hoehe_lage     in isi_transport.p_komm_lhm_hoehe_lage%type,
        in_komm_packscheme_kopf_id in isi_transport.p_komm_packschema_kopf_id%type,
        in_out_transport_gruppe    in out isi_transport.transport_gruppe%type
    ) return number;

    procedure c_import_mfr_element;

    function c_add_empty_mfr_element_cfg (
        in_count             in number,
        in_element_name      in mfr_element_cfg.fahrzeug%type, --'RB11_'  'RB11_401'
        in_start_elem_pos_nr in number,                        -- 401
        in_start_pos_nr      in number                         -- 11401
    ) return boolean;

    procedure c_transp_suche_einl_p_rid_lte (
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
        in_lte_hoehe            in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite           in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe            in lvs_lte.lte_vol_tiefe%type,
        in_lte_name             in lvs_lte.lte_name%type,
        in_lte_gew_kg           in lvs_lte.lte_akt_kg%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type
    );

    function get_doc_elem_text (
        in_mfr_element_id in mfr_element_cfg.element_id%type
    ) return varchar2;

    procedure c_change_lte_properties (
        in_lte_id         in lvs_lte.lte_id%type,
        in_lte_name       in lvs_lte.lte_name%type,
        in_lte_hoehe      in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite     in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe      in lvs_lte.lte_vol_tiefe%type,
        in_lte_gewicht    in lvs_lte.lte_akt_kg%type,
        in_wickelprogramm in lvs_lte.wickelprogramm%type,
        in_auto_depal     in lvs_lte.auto_depal%type
    );

    function c_pruef_einl_err_text_del_t (
        in_lte_id        in lvs_lte.lte_id%type,
        in_lgr_platz     in lvs_lgr.lgr_platz%type,
        in_fahrzeuge_ids in varchar2,
        in_transport_id  in isi_transport.transp_id%type
    ) return varchar2;

    procedure c_transp_depal_lte (
        in_lte_id                  in lvs_lte.lte_id%type,
        in_lgr_ort                 in lvs_lgr_ort.lgr_ort%type,
        in_modul_erzeuger          in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter        in isi_transport.modul_bearbeiter%type,
        in_user_id                 in isi_user.login_id%type,
        in_prio                    in isi_transport.prio%type,
        in_aktuelle_position       in lvs_lam.lam_text%type,
        in_lte_hoehe               in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite              in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe               in lvs_lte.lte_vol_tiefe%type,
        in_lte_name                in lvs_lte.lte_name%type,
        in_lte_gew_kg              in lvs_lte.lte_akt_kg%type,
        in_komm_lgr_platz          in lvs_lgr.lgr_platz%type,
        in_ziel_packschema_kopf_id in lvs_packschema_kopf.packschema_kopf_id%type,
        out_transport_id           out number,
        out_p_komm_id              out number
    );

    procedure lvs_c_lte_lhm_umpacken (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_res_id   in isi_resource.res_id%type,
        in_q_lte_id in lvs_lhm.lhm_id%type,
        in_z_lte_id in lvs_lte.lte_id%type,
        in_auf_id   in isi_order_pos.auf_id%type,
        in_lhm_uanz in number
    );

    procedure c_del_transp_depal_lte (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_user_id        in isi_user.login_id%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_transport_id   in isi_transport.transp_id%type,
        in_immer_loeschen in varchar2
    );

    procedure c_change_order_ziel (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_vorgang_id in isi_order_pos.vorgang_id%type,
        in_von_ziel   in isi_order_pos.ziel%type,
        in_neues_ziel in isi_order_pos.ziel%type
    );

    function c_mfr_server_start return varchar2;

    function c_res_stat (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_res_id      in isi_resource.res_id%type,
        in_ls_login_id in isi_user.login_id%type,
        in_res_st_id   in isi_res_status_cfg.res_st_id%type,
        in_res_typ     in isi_res_status_cfg.res_typ%type
    ) return number;

    procedure c_mfr_elem_cfg_change_plc_nr (
        in_new_plc_connector in mfr_element_cfg.telegr_koppl_nr%type,
        in_old_plc_connector in mfr_element_cfg.telegr_koppl_nr%type
    );

    procedure c_mfr_elem_cfg_move_up_plc_nr (
        start_move_up_at_plc_connector in mfr_element_cfg.telegr_koppl_nr%type
    );

end mfr_package;
/


-- sqlcl_snapshot {"hash":"0cb2cfb9e1ea7fbc1600305e8269d8037555d3f1","type":"PACKAGE_SPEC","name":"MFR_PACKAGE","schemaName":"DIRKSPZM32","sxml":""}