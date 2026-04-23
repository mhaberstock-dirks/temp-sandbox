create or replace package dirkspzm32.lvs_p_base is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  04.10.2006 21:49:27
  __________________________________________________
  Description
  Hilfsprozeduren für Konfig-Daten
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
               3.4.4.1     (-AG-)   Erweiterung für Sasol Spez_Barcode
               3.3.4.0              Package erstellt
  */

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;
  /*
  *  Versionsverlauf
  */
    function get_lte_cfg (
        in_sid      in lvs_lte_cfg.sid%type,
        in_lte_name in lvs_lte_cfg.lte_name%type,
        io_lte_cfg  in out lvs_lte_cfg%rowtype
    ) return boolean;

    function get_lhm_cfg (
        in_sid      in lvs_lhm_cfg.sid%type,
        in_lhm_name in lvs_lhm_cfg.lhm_name%type,
        io_lhm_cfg  in out lvs_lhm_cfg%rowtype
    ) return boolean;

    function get_lgr_ort (
        in_sid      in lvs_lgr_ort.sid%type,
        in_firma_nr in lvs_lgr_ort.firma_nr%type,
        in_lgr_ort  in lvs_lgr_ort.lgr_ort%type,
        io_lgr_ort  in out lvs_lgr_ort%rowtype
    ) return boolean;

    function get_lgr_platz (
        in_lgr_platz in lvs_lgr.lgr_platz%type,
        io_lgr       in out lvs_lgr%rowtype
    ) return boolean;

    function get_lgr_komm_info (
        in_lgr_platz                in lvs_lgr.lgr_platz%type,
        out_komm_direkt_moegl       out lvs_lgr_ort.komm_direkt_moegl%type,
        out_komm_ausweich_lgr_platz out lvs_lgr_ort.komm_ausweich_lgr_platz%type,
        out_komm_picken_moegl       out lvs_lgr_ort.komm_picken_moegl%type,
        out_komm_neu_lte_lgr_platz  out lvs_lgr_ort.komm_neu_lte_lgr_platz%type
    ) return boolean;

    function get_lgr_wa_info (
        in_lgr_platz          in lvs_lgr.lgr_platz%type,
        out_wa_menge_uebelief out lvs_lgr.wa_menge_ueberlief%type
    ) return boolean;

    function get_artikel_status (
        in_sid            in lvs_artikel_status.sid%type,
        in_firma_nr       in lvs_artikel_status.firma_nr%type,
        in_artikel_id     in lvs_artikel_status.artikel_id%type,
        in_leitzahl       in lvs_artikel_status.leitzahl%type,
        in_fa_ag          in lvs_artikel_status.fa_ag%type,
        io_artikel_status in out lvs_artikel_status%rowtype,
        in_auto_insert    in boolean
    ) return boolean;

    procedure set_artikel_letztes_einl_datum (
        in_sid                in lvs_artikel_status.sid%type,
        in_firma_nr           in lvs_artikel_status.firma_nr%type,
        in_artikel_id         in lvs_artikel_status.artikel_id%type,
        in_leitzahl           in lvs_artikel_status.leitzahl%type,
        in_fa_ag              in lvs_artikel_status.fa_ag%type,
        in_letztes_einl_datum in lvs_artikel_status.letztes_einl_datum%type
    );

    procedure set_artikel_letztes_ausl_datum (
        in_sid                in lvs_artikel_status.sid%type,
        in_firma_nr           in lvs_artikel_status.firma_nr%type,
        in_artikel_id         in lvs_artikel_status.artikel_id%type,
        in_leitzahl           in lvs_artikel_status.leitzahl%type,
        in_fa_ag              in lvs_artikel_status.fa_ag%type,
        in_letztes_ausl_datum in lvs_artikel_status.letztes_ausl_datum%type
    );

    procedure set_artikel_letzte_buchung (
        in_sid            in lvs_artikel_status.sid%type,
        in_firma_nr       in lvs_artikel_status.firma_nr%type,
        in_artikel_id     in lvs_artikel_status.artikel_id%type,
        in_leitzahl       in lvs_artikel_status.leitzahl%type,
        in_fa_ag          in lvs_artikel_status.fa_ag%type,
        in_letzte_buchung in lvs_artikel_status.letzte_buchung%type
    );

    function get_lte (
        in_lte_id in lvs_lte.lte_id%type,
        io_lte    in out lvs_lte%rowtype
    ) return boolean;

    function get_lte_hist (
        in_lte_id in lvs_lte.lte_id%type,
        io_lte    in out lvs_lte%rowtype
    ) return boolean;

    function get_lhm (
        in_lhm_id in lvs_lhm.lhm_id%type,
        io_lhm    in out lvs_lhm%rowtype
    ) return boolean;

    function get_lhm_by_lte_id (
        in_lte_id in lvs_lhm.lte_id%type,
        in_lhm_id in lvs_lhm.lhm_id%type,
        io_lhm    in out lvs_lhm%rowtype
    ) return boolean;

    function get_lam (
        in_sid      in lvs_lam.sid%type,
        in_firma_nr in lvs_lam.firma_nr%type,
        in_lam_id   in lvs_lam.lam_id%type,
        io_lam      in out lvs_lam%rowtype
    ) return boolean;

    function get_lam_by_lhm_id (
        in_sid      in lvs_lam.sid%type,
        in_firma_nr in lvs_lam.firma_nr%type,
        in_lhm_id   in lvs_lam.lhm_id%type,
        io_lam      in out lvs_lam%rowtype
    ) return boolean;

    function get_lam_by_lte_id (
        in_sid      in lvs_lam.sid%type,
        in_firma_nr in lvs_lam.firma_nr%type,
        in_lte_id   in lvs_lam.lte_id%type,
        io_lam      in out lvs_lam%rowtype
    ) return boolean;

    function get_lam_bh_by_id (
        in_lam_bh_id in lvs_lam_bh.lam_bh_id%type,
        io_lam_bh    in out lvs_lam_bh%rowtype
    ) return boolean;

    function get_charge (
        in_charge_id in lvs_charge.charge_id%type,
        io_charge    in out lvs_charge%rowtype
    ) return boolean;

    function get_charge_bez (
        in_sid        in lvs_charge.sid%type,
        in_charge     in lvs_charge.charge_bez%type,
        in_artikel_id in lvs_charge.artikel_id%type,
        io_charge     in out lvs_charge%rowtype
    ) return boolean;

    function get_transport (
        in_sid       in isi_transport.sid%type,
        in_transp_id in isi_transport.transp_id%type,
        io_transport in out isi_transport%rowtype
    ) return boolean;

    function get_transport_by_lte_id (
        in_lte_id    in isi_transport.lte_id%type,
        io_transport in out isi_transport%rowtype
    ) return boolean;

    function get_fahrzeug (
        in_res_id   in lvs_fahrzeuge.res_id%type,
        io_fahrzeug in out lvs_fahrzeuge%rowtype
    ) return boolean;

    function get_lvs_lgr_ort_ue_platz (
        in_sid                  in lvs_lam.sid%type,
        in_firma_nr             in lvs_lam.firma_nr%type,
        in_lgr_ort_quelle       in lvs_lgr_ort_ue_platz.lgr_ort_quelle%type,
        in_lgr_ort_ziel         in lvs_lgr_ort_ue_platz.lgr_ort_ziel%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_name             in lvs_lte.lte_name%type,
        io_lvs_lgr_ort_ue_platz in out lvs_lgr_ort_ue_platz%rowtype
    ) return boolean;

    function lagerbestand_vorhanden_menge (
        in_sid             in lvs_lam.sid%type,
        in_firma_nr        in lvs_lam.firma_nr%type,
        in_artikel_id      in lvs_lam.artikel_id%type,
        in_leitzahl        in lvs_lam.leitzahl%type,
        in_fa_ag           in lvs_lam.fa_ag%type,
        in_zeichnung_index in lvs_lam.zeichnung_index%type,
        in_lgr_ort         in lvs_lgr.lgr_ort%type,
        out_menge_ges      out number,
        out_anzahl_lam     out number
    ) return boolean;

    function lagerbestand_verfuegbar_menge (
        in_sid             in lvs_lam.sid%type,
        in_firma_nr        in lvs_lam.firma_nr%type,
        in_artikel_id      in lvs_lam.artikel_id%type,
        in_leitzahl        in lvs_lam.leitzahl%type,
        in_fa_ag           in lvs_lam.fa_ag%type,
        in_zeichnung_index in lvs_lam.zeichnung_index%type,
        in_lgr_ort         in lvs_lgr.lgr_ort%type,
        out_menge_ges      out number,
        out_anzahl_lam     out number
    ) return boolean;

    function lagerbestand_vorhanden (
        in_sid             in lvs_lam.sid%type,
        in_firma_nr        in lvs_lam.firma_nr%type,
        in_artikel_id      in lvs_lam.artikel_id%type,
        in_leitzahl        in lvs_lam.leitzahl%type,
        in_fa_ag           in lvs_lam.fa_ag%type,
        in_zeichnung_index in lvs_lam.zeichnung_index%type,
        in_lgr_ort         in lvs_lgr.lgr_ort%type
    ) return boolean;

    function lagerbestand_verfuegbar (
        in_sid             in lvs_lam.sid%type,
        in_firma_nr        in lvs_lam.firma_nr%type,
        in_artikel_id      in lvs_lam.artikel_id%type,
        in_leitzahl        in lvs_lam.leitzahl%type,
        in_fa_ag           in lvs_lam.fa_ag%type,
        in_zeichnung_index in lvs_lam.zeichnung_index%type,
        in_lgr_ort         in lvs_lgr.lgr_ort%type
    ) return boolean;

    function get_packschema_kopf (
        in_sid                in lvs_packschema_kopf.sid%type,
        in_firma_nr           in lvs_packschema_kopf.firma_nr%type,
        in_packschema_kopf_id in lvs_packschema_kopf.packschema_kopf_id%type,
        io_packschema_kopf    in out lvs_packschema_kopf%rowtype
    ) return boolean;

    function get_transp_by_lte_id (
        in_sid     in isi_sid.sid%type,
        in_lte_id  in lvs_lte.lte_id%type,
        out_transp out isi_transport%rowtype
    ) return boolean;

    function get_transp_by_transp_id (
        in_sid       in isi_sid.sid%type,
        in_transp_id in isi_transport.transp_id%type,
        out_transp   out isi_transport%rowtype
    ) return boolean;

    function get_transp_grp_by_lte_id (
        in_sid         in isi_sid.sid%type,
        in_lte_id      in lvs_lte.lte_id%type,
        out_transp_grp out isi_transport_grp%rowtype
    ) return boolean;

    function get_transp_grp_by_lte_grp_id (
        in_sid         in isi_sid.sid%type,
        in_lte_grp_id  in lvs_lte.lte_id%type,
        out_transp_grp out isi_transport_grp%rowtype
    ) return boolean;

    function get_transp_grp_by_transp_id (
        in_sid           in isi_sid.sid%type,
        in_transp_grp_id in isi_transport.transp_id%type,
        out_transp_grp   out isi_transport_grp%rowtype
    ) return boolean;

    function get_transp_id_by_lte_id (
        in_sid        in isi_sid.sid%type,
        in_lte_id     in lvs_lte.lte_id%type,
        out_transp_id out isi_transport.transp_id%type
    ) return boolean;

    function get_lgr_ort_fuellg_chk_by_p (
        in_sid                       in isi_sid.sid%type,
        in_firma_nr                  in isi_firma.firma_nr%type,
        in_lgr_ort                   in lvs_lgr_ort.lgr_ort%type,
        in_lgr_gruppe_id             in lvs_lgr.lgr_gruppe_id%type,
        in_lte_name                  in lvs_lte_cfg.lte_name%type,
        out_lvs_lgr_ort_fuellg_check out lvs_lgr_ort_fuellg_check%rowtype
    ) return boolean;

end lvs_p_base;
/


-- sqlcl_snapshot {"hash":"eb9d17f51347d45eed8b417ec57558a09f8fff73","type":"PACKAGE_SPEC","name":"LVS_P_BASE","schemaName":"DIRKSPZM32","sxml":""}