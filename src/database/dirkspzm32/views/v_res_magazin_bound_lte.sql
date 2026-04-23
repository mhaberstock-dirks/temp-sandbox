create or replace force editionable view dirkspzm32.v_res_magazin_bound_lte (
    lte_id,
    res_name,
    lager_roh,
    sid,
    firma_nr,
    res_id,
    created_date,
    created_login_id,
    last_change_date,
    last_change_login_id,
    usage,
    enabled,
    status,
    mag_params,
    menge_max,
    menge_min,
    artikel_id,
    zeichnung,
    zeichnung_index,
    charge,
    menge_ist,
    mag_type,
    modul_bearbeiter,
    lte_name,
    lhm_name
) as
    select
        lte.lte_id,
        r.res_name,
        r.lager_roh,
        t.sid,
        t.firma_nr,
        t.res_id,
        t.created_date,
        t.created_login_id,
        t.last_change_date,
        t.last_change_login_id,
        t.usage,
        t.enabled,
        t.status,
        t.mag_params,
        t.menge_max,
        t.menge_min,
        t.artikel_id,
        t.zeichnung,
        t.zeichnung_index,
        t.charge,
        t.menge_ist,
        t.mag_type,
        t.modul_bearbeiter,
        t.lte_name,
        t.lhm_name
    from
        isi_res_mag_cfg t,
        isi_resource    r,
        lvs_lte         lte
    where
            r.res_id = t.res_id
        and lte.lgr_platz (+) = r.lager_roh;


-- sqlcl_snapshot {"hash":"661bda7ea6d66fdb7d585fb0e232c7c4c15160ad","type":"VIEW","name":"V_RES_MAGAZIN_BOUND_LTE","schemaName":"DIRKSPZM32","sxml":""}