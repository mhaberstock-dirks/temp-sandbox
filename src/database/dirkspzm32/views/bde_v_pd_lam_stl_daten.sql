create or replace force editionable view dirkspzm32.bde_v_pd_lam_stl_daten (
    sid,
    firma_nr,
    pd_lam_stl_daten_id,
    fert_lam_id,
    fa_nr,
    fa_ag,
    fa_upos,
    fa_ag_stl_id,
    stl_lam_id,
    stl_lam_ab_menge,
    stl_lam_ist_menge,
    status,
    aend_datum,
    aend_login_id,
    res_id,
    res_status_id,
    result_params,
    res_name,
    fe_artikel_id,
    fe_artikel,
    fe_zeichnung,
    fe_zindex,
    ma_artikel_id,
    ma_art_gruppe_id,
    ma_artikel,
    ma_zeichnung,
    ma_zindex,
    ma_art_gruppe,
    ma_prod_params,
    prod_menge_ix,
    fa_satzart,
    fa_ag_bez1,
    fa_ag_bez2
) as
    select
        t.sid,
        t.firma_nr,
        t.pd_lam_stl_daten_id,
        t.fert_lam_id,
        t.fa_nr,
        t.fa_ag,
        t.fa_upos,
        t.fa_ag_stl_id,
        t.stl_lam_id,
        t.stl_lam_ab_menge,
        t.stl_lam_ist_menge,
        t.status,
        t.aend_datum,
        t.aend_login_id,
        t.res_id,
        t.res_status_id,
        t.result_params,
        r.res_name,
        lam.artikel_id      fe_artikel_id,
        fea.artikel         fe_artikel,
        lam.zeichnung       fe_zeichnung,
        lam.zeichnung_index fe_zindex,
        maa.artikel_id      ma_artikel_id,
        maa.art_gruppe_id   ma_art_gruppe_id,
        maa.artikel         ma_artikel,
        ma.zeichnung        ma_zeichnung,
        ma.zeichnung_index  ma_zindex,
        maag.art_gruppe     ma_art_gruppe,
        ma.prod_params      ma_prod_params,
        stl.prod_menge_ix,
        fa.satzart          fa_satzart,
        fa.ag_bez1          fa_ag_bez1,
        fa.ag_bez2          fa_ag_bez2
    from
        bde_pd_lam_stl_daten t,
        bde_fa_auftrag       fa,
        bde_fa_auftrag_stl   stl,
        bde_fa_auftrag       ma,
        isi_artikel          maa,
        isi_artikel_gruppe   maag,
        lvs_lam              lam,
        isi_artikel          fea,
        isi_resource         r
    where
            stl.fa_ag_stl_id (+) = t.fa_ag_stl_id
        and fa.sid = t.sid
        and fa.firma_nr = t.firma_nr
        and fa.leitzahl = t.fa_nr
        and fa.fa_ag = t.fa_ag
        and fa.fa_upos = t.fa_upos
        and ma.sid (+) = stl.sid
        and ma.firma_nr (+) = stl.firma_nr
        and ma.leitzahl (+) = stl.leitzahl
        and ma.fa_ag (+) = stl.ma_fa_ag
        and ma.fa_upos (+) = stl.ma_fa_upos
        and maa.sid (+) = ma.sid
        and maa.artikel_id (+) = ma.ag_artikel_id
        and maag.sid (+) = maa.sid
        and maag.art_gruppe_id (+) = maa.art_gruppe_id
        and lam.sid = t.sid
        and lam.firma_nr = t.firma_nr
        and lam.lam_id = t.fert_lam_id
        and fea.sid = lam.sid
        and fea.artikel_id = lam.artikel_id
        and r.sid (+) = t.sid
        and r.firma_nr (+) = t.firma_nr
        and r.res_id (+) = t.res_id;


-- sqlcl_snapshot {"hash":"873fb21d65e545be5575f2c5be3be5e7793f47a3","type":"VIEW","name":"BDE_V_PD_LAM_STL_DATEN","schemaName":"DIRKSPZM32","sxml":""}