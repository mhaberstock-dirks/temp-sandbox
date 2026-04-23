create or replace package dirkspzm32.lvs_komm is
    function get_komm_anz_lam_fuer_lte (
        in_sid              lvs_lam.sid%type,
        in_firma_nr         lvs_lam.firma_nr%type,
        in_komm_ziel_lte_id lvs_lam.lte_id%type,
        in_artikel_id       lvs_lam.artikel_id%type
    ) return number;

    procedure lvs_komm_direct_r359 (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_user_id       in isi_user.login_id%type,
        in_quelle_lte_id in lvs_lte.lte_id%type,
        in_lam_id        in lvs_lam.lam_id%type,
        in_menge         in lvs_lam.menge%type,
        in_ziel_lte_id   in lvs_lte.lte_id%type,
        in_ziel_lhm_id   in lvs_lhm.lhm_id%type,
        out_neu_lam_id   out lvs_lam.lam_id%type,
        out_neu_lhm_id   out lvs_lhm.lhm_id%type
    );

    procedure lvs_komm_direct (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_user_id       in isi_user.login_id%type,
        in_quelle_lte_id in lvs_lte.lte_id%type,
        in_lam_id        in lvs_lam.lam_id%type,
        in_menge         in lvs_lam.menge%type,
        in_ziel_lte_id   in lvs_lte.lte_id%type,
        out_neu_lam_id   out lvs_lam.lam_id%type,
        out_neu_lhm_id   out lvs_lhm.lhm_id%type
    );

    procedure lvs_c_komm_direct (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_user_id       in isi_user.login_id%type,
        in_quelle_lte_id in lvs_lte.lte_id%type,
        in_lam_id        in lvs_lam.lam_id%type,
        in_menge         in lvs_lam.menge%type,
        in_ziel_lte_id   in lvs_lte.lte_id%type
    );

    procedure lvs_c_lte_platz_loeschen (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lte_id   in lvs_lte.lte_id%type
    );

    function get_packschema_kopf_id (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) return lvs_packschema_kopf.packschema_kopf_id%type;

    function get_packschema_lfdn (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) return number;

    function get_packschema_max_lfdn (
        in_sid                in isi_sid.sid%type,
        in_firma_nr           in isi_firma.firma_nr%type,
        in_packschema_kopf_id in lvs_lte.lte_id%type
    ) return number;

    function get_packschema_max_lage (
        in_sid                in isi_sid.sid%type,
        in_firma_nr           in isi_firma.firma_nr%type,
        in_packschema_kopf_id in lvs_lte.lte_id%type
    ) return number;

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

    procedure lvs_c_lte_menge_umpacken (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_res_id   in isi_resource.res_id%type,
        in_q_lte_id in lvs_lhm.lhm_id%type,
        in_z_lte_id in lvs_lte.lte_id%type,
        in_auf_id   in isi_order_pos.auf_id%type,
        in_menge    in number,
        in_neg_komm in varchar2
    );

    procedure lvs_c_lte_umpack_q_platz_leer (
        in_q_platz_leeren in varchar2, -- T/F T = LTE vom Quellplatz ausbuchen
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_user_id        in isi_user.login_id%type,
        in_res_id         in isi_resource.res_id%type,
        in_q_lte_id       in lvs_lhm.lhm_id%type,
        in_z_lte_id       in lvs_lte.lte_id%type,
        in_auf_id         in isi_order_pos.auf_id%type,
        in_lhm_uanz       in number
    );

    procedure lvs_lte_menge_umpacken (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_res_id   in isi_resource.res_id%type,
        in_q_lte_id in lvs_lhm.lhm_id%type,
        in_z_lte_id in lvs_lte.lte_id%type,
        in_auf_id   in isi_order_pos.auf_id%type,
        in_menge    in number,
        in_neg_komm in varchar2
    );

end lvs_komm;
/


-- sqlcl_snapshot {"hash":"1cca342bd6b0a8a16fd831d94e475528bce46226","type":"PACKAGE_SPEC","name":"LVS_KOMM","schemaName":"DIRKSPZM32","sxml":""}