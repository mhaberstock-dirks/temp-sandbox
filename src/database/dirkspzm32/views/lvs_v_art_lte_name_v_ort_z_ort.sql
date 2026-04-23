create or replace force editionable view dirkspzm32.lvs_v_art_lte_name_v_ort_z_ort (
    sid,
    artikel_id,
    artikel,
    bezeichnung1,
    lgr_ort_quelle,
    lgr_ort_ziel,
    lte_name_quelle,
    lte_name_ziel,
    lte_menge_ziel
) as
    select
        a_lte_cfg.sid,
        a.artikel_id,
        a.artikel,
        a.bezeichnung1,
        lu.lgr_ort_quelle,
        lu.lgr_ort_ziel,
        a.lte_name          lte_name_quelle,
        a_lte_cfg.lte_name  lte_name_ziel,
        a_lte_cfg.lte_menge lte_menge_ziel
    from
        lvs_lgr_ort_ue_platz lu,
        isi_artikel_lte_cfg  a_lte_cfg,
        isi_artikel          a
    where
            lu.lte_name = a.lte_name
        and lu.lte_name_ziel = a_lte_cfg.lte_name
        and a_lte_cfg.artikel_id = a.artikel_id;


-- sqlcl_snapshot {"hash":"e16701101ecb5ffd8c5307c12d1b50e4b11ec5a9","type":"VIEW","name":"LVS_V_ART_LTE_NAME_V_ORT_Z_ORT","schemaName":"DIRKSPZM32","sxml":""}