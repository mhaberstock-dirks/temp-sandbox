create or replace force editionable view dirkspzm32.isi_v_vdma_res (
    res_ext_name,
    res_name,
    text,
    res_id,
    prod_std,
    hnz,
    blz,
    baz,
    pbz,
    trz,
    pm,
    gm,
    am,
    pez,
    xx
) as
    select
        r.res_ext_name,
        r.res_name,
        r.text,
        r.res_id,
        bde_funktionen.get_res_prod_std(r.res_id, bde_funktionen.get_ausw_begin, bde_funktionen.get_ausw_ende)                     prod_std
        ,
        bde_funktionen.get_res_hnz_std                                                                                             hnz
        ,
        bde_funktionen.get_res_hnz_std + bde_funktionen.get_res_ruest_std + bde_funktionen.get_res_su_std                          blz
        ,
        bde_funktionen.get_res_hnz_std + bde_funktionen.get_res_ruest_std                                                          baz
        ,
        bde_funktionen.get_anmelde_std(r.sid, r.firma_nr,(bde_funktionen.get_ausw_begin),(bde_funktionen.get_ausw_ende), r.res_id) pbz
        ,
        bde_funktionen.get_res_ruest_std                                                                                           trz
        ,
        sum(pd.menge_a) + sum(pd.menge_b) + sum(pd.schrott)                                                                        pm
        ,
        sum(pd.menge_a)                                                                                                            gm
        ,
        sum(pd.menge_b) + sum(pd.schrott)                                                                                          am
        ,
        max(rl_pez_sek.param_menge) / 3600                                                                                         pez
        ,
        bde_funktionen.get_res_ruest_std                                                                                           xx
    from
        isi_resource         r,
        isi_res_leistung_cfg rl_pez_sek,
        bde_pd_prod          pd
    where
            r.typ = 'MS'
        and r.res_id = pd.res_id
        and r.res_id = rl_pez_sek.res_id (+)
        and rl_pez_sek.param_name (+) = 'PEZ_SEK'
        and pd.vorg_typ = 'PA'
        and pd.prod_ende >= bde_funktionen.get_ausw_begin()
        and pd.prod_ende <= bde_funktionen.get_ausw_ende()
    group by
        r.res_ext_name,
        r.res_name,
        r.sid,
        r.firma_nr,
        r.text,
        r.res_id;


-- sqlcl_snapshot {"hash":"4c08fc58f6c07a4aaee1d6ad657b5e8ef668c1ff","type":"VIEW","name":"ISI_V_VDMA_RES","schemaName":"DIRKSPZM32","sxml":""}