create or replace force editionable view dirkspzm32.a1_test_lager_artikel_vert (
    lgr_ort,
    lte_name,
    artikel_id,
    artikel,
    bezeichnung1,
    charge_bez,
    lhm_name,
    anzahl_lam,
    anzahl_reserviert
) as
    select
        lgr.lgr_ort,
        lte.lte_name,
        lam.artikel_id,
        a.artikel,
        a.bezeichnung1,
        ch.charge_bez,
        lhm.lhm_name,
        count(lam.lam_id)           anzahl_lam,
        count(lam.order_pos_auf_id) anzahl_reserviert
    from
             lvs_lam lam
        join isi_artikel a on ( a.artikel_id = lam.artikel_id )
        join lvs_charge  ch on ( ch.charge_id = lam.charge_id )
        join lvs_lgr     lgr on ( lgr.lgr_platz = lam.lgr_platz )
        join lvs_lhm     lhm on ( lhm.lhm_id = lam.lhm_id )
        join lvs_lte     lte on ( lte.lte_id = lam.lte_id )
    where
        lte.lte_status = 'LF'
    group by
        lam.artikel_id,
        a.artikel,
        a.bezeichnung1,
        ch.charge_bez,
        lgr.lgr_ort,
        lte.lte_name,
        lhm.lhm_name
    order by
        lgr.lgr_ort,
        lte.lte_name,
        a.artikel,
        lhm.lhm_name;


-- sqlcl_snapshot {"hash":"faa6c837f009ae250bbf560bd5d3ee4777ab545b","type":"VIEW","name":"A1_TEST_LAGER_ARTIKEL_VERT","schemaName":"DIRKSPZM32","sxml":""}