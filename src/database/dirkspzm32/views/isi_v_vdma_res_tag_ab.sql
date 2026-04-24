create or replace force editionable view dirkspzm32.isi_v_vdma_res_tag_ab (
    res_ext_name,
    res_name,
    text,
    res_id,
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
        bde_funktionen.get_res_prod_std(r.res_id,(bde_funktionen.get_ausw_begin),(bde_funktionen.get_ausw_ende))                                  hnz
        ,
        bde_funktionen.get_res_prod_std(r.res_id,(bde_funktionen.get_ausw_begin),(bde_funktionen.get_ausw_ende)) + bde_funktionen.get_res_ruest_std
        + bde_funktionen.get_res_up_unterbr_std blz,
        bde_funktionen.get_res_prod_std(r.res_id,(bde_funktionen.get_ausw_begin),(bde_funktionen.get_ausw_ende)) + bde_funktionen.get_res_ruest_std baz
        ,
        bde_funktionen.get_anmelde_std(r.sid, r.firma_nr,(bde_funktionen.get_ausw_begin),(bde_funktionen.get_ausw_ende), r.res_id)                pbz
        ,
        bde_funktionen.get_res_ruest_std                                                                                                          trz
        ,
        nvl((
            select
                sum(pdx.menge_a + pdx.menge_b + pdx.schrott)
            from
                bde_pd_prod pdx
            where
                    r.res_id = pdx.res_id
                and pdx.vorg_typ = 'PA'
                and pdx.prod_ende >=(bde_funktionen.get_ausw_begin)
                and pdx.prod_ende <=(bde_funktionen.get_ausw_ende)
        ),
            0)                                                                                                                                    pm
            ,
        nvl((
            select
                sum(pdx.menge_a)
            from
                bde_pd_prod pdx
            where
                    r.res_id = pdx.res_id
                and pdx.vorg_typ = 'PP'
                and pdx.prod_ende >=(bde_funktionen.get_ausw_begin)
                and pdx.prod_ende <=(bde_funktionen.get_ausw_ende)
        ),
            0)                                                                                                                                    gm
            ,
        nvl((
            select
                sum(pdx.menge_b + pdx.schrott)
            from
                bde_pd_prod pdx
            where
                    r.res_id = pdx.res_id
                and pdx.vorg_typ = 'PA'
                and pdx.prod_ende >=(bde_funktionen.get_ausw_begin)
                and pdx.prod_ende <=(bde_funktionen.get_ausw_ende)
        ),
            0)                                                                                                                                    am
            ,
        max(rl_pez_sek.param_menge) / 3600                                                                                                        pez
        ,
        bde_funktionen.get_res_ruest_std                                                                                                          xx
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
        and pd.prod_ende <= bde_funktionen.get_ausw_ende() + 1
        and pd.prod_beginn <= bde_funktionen.get_ausw_ende()
    group by
        r.res_ext_name,
        r.res_name,
        r.sid,
        r.firma_nr,
        r.text,
        r.res_id;


-- sqlcl_snapshot {"hash":"785702cb02ec4ab340cf1c65f533affa7e15a7c9","type":"VIEW","name":"ISI_V_VDMA_RES_TAG_AB","schemaName":"DIRKSPZM32","sxml":""}