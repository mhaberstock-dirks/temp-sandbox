create or replace force editionable view dirkspzm32.lvs_v_lhm (
    sid,
    firma_nr,
    lhm_id,
    lte_id,
    lhm_name,
    lgr_platz,
    lhm_vol_hoehe,
    lhm_vol_breite,
    lhm_vol_tiefe,
    lhm_vol,
    lhm_akt_kg,
    lhm_letzte_buchung,
    lhm_eti_druck_status,
    komm_quell_lte_id,
    komm_quell_lgr_platz,
    komm_neu_lhm_name
) as
    select
        lhm.sid,
        lhm.firma_nr,
        lhm.lhm_id,
        lhm.lte_id,
        lhm.lhm_name,
        lhm.lgr_platz,
        lhm.lhm_vol_hoehe,
        lhm.lhm_vol_breite,
        lhm.lhm_vol_tiefe,
        lhm.lhm_vol,
        lhm.lhm_akt_kg,
        lhm.lhm_letzte_buchung,
        lhm.lhm_eti_druck_status,
        lhm.komm_quell_lte_id,
        lhm.komm_quell_lgr_platz,
        lhm.komm_neu_lhm_name
    from
        lvs_lhm lhm
    union
    select
        lhm_hist.sid,
        lhm_hist.firma_nr,
        lhm_hist.lhm_id,
        lhm_hist.lte_id,
        lhm_hist.lhm_name,
        lhm_hist.lgr_platz,
        lhm_hist.lhm_vol_hoehe,
        lhm_hist.lhm_vol_breite,
        lhm_hist.lhm_vol_tiefe,
        lhm_hist.lhm_vol,
        lhm_hist.lhm_akt_kg,
        lhm_hist.lhm_letzte_buchung,
        lhm_hist.lhm_eti_druck_status,
        lhm_hist.komm_quell_lte_id,
        lhm_hist.komm_quell_lgr_platz,
        lhm_hist.komm_neu_lhm_name
    from
        lvs_lhm_hist lhm_hist;


-- sqlcl_snapshot {"hash":"56036c18964f5b44a4002e927ea32714a438097d","type":"VIEW","name":"LVS_V_LHM","schemaName":"DIRKSPZM32","sxml":""}