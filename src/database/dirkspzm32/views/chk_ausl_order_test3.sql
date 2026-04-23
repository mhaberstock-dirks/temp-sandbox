create or replace force editionable view dirkspzm32.chk_ausl_order_test3 (
    ok_status,
    vorgang_id,
    auf_id,
    artikel,
    lte_id,
    lgr_platz,
    reserviert,
    lgr_verwendung_lte_status,
    check_fa,
    q_lgr_ort_semikolon,
    lam_menge_ulhm,
    q_lgr_ort_order_lte,
    order_pos_auto_depal,
    order_pos_ware_disponiert,
    m_inv,
    labor_st,
    lam_sel1_10,
    charge,
    serie,
    mhd,
    min_mhd,
    anbruch,
    chk_reserv,
    konsi,
    p_datum,
    lgr_gesperrt,
    l_inv,
    l_orte,
    farzeug_ok,
    z_idx,
    z_menge,
    leitzahl,
    fa_ag,
    menge,
    reservierte_menge,
    "ReifeZeit",
    lam_text,
    zug_datum,
    labor_status,
    lam_res_fuer_auf_id,
    lte_res_fuer_vorgang_id,
    platz_gesp,
    lgr_verwendung,
    lam_mhd,
    res_mhd,
    charge_bez,
    min_mhd_r,
    ausl_sort,
    ausl_sort2,
    kunden_nr,
    name_1
) as
    select
        case
            when t.reserviert = 'Frei'
                 and t.check_fa like '%OK%'
                 and t.order_pos_auto_depal like '%OK%'
                 and t.q_lgr_ort_semikolon like '%OK%'
                 and t.lam_menge_ulhm like '%OK%'
                 and t.q_lgr_ort_order_lte like '%OK%'
                 and t.order_pos_ware_disponiert like '%OK%'
                 and t.lgr_verwendung_lte_status like '%OK%'
                 and t.m_inv like '%OK%'
                 and t.labor_st like '%OK%'
                 and t.lam_sel1_10 like '%OK%'
                 and t.charge like '%OK%'
                 and t.serie like '%OK%'
                 and t.mhd like '%OK%'
                 and t.min_mhd like '%OK%'
                 and t.anbruch like '%OK%'
                 and t.chk_reserv like '%OK%'
                 and t.konsi like '%OK%'
                 and t.p_datum like '%OK%'
                 and t.lgr_gesperrt like '%OK%'
                 and t.l_inv like '%OK%'
                 and t.l_orte like '%OK%'
                 and t.z_idx like '%OK%'
                 and t.z_menge like '%OK%'
                 and ( t.farzeug_ok like '%OK%'
                       or t.farzeug_ok like '%T%' ) then
                'OK'
            else
                'ERR'
        end ok_status,
        t.vorgang_id,
        t.auf_id,
        t.artikel,
        t.lte_id,
        t.lgr_platz,
        t.reserviert,
        t.lgr_verwendung_lte_status,
        t.check_fa,
        t.q_lgr_ort_semikolon,
        t.lam_menge_ulhm,
        t.q_lgr_ort_order_lte,
        t.order_pos_auto_depal,
        t.order_pos_ware_disponiert,
        t.m_inv,
        t.labor_st,
        t.lam_sel1_10,
        t.charge,
        t.serie,
        t.mhd,
        t.min_mhd,
        t.anbruch,
        t.chk_reserv,
        t.konsi,
        t.p_datum,
        t.lgr_gesperrt,
        t.l_inv,
        t.l_orte,
        t.farzeug_ok,
        t.z_idx,
        t.z_menge,
        t.leitzahl,
        t.fa_ag,
        t.menge,
        t.reservierte_menge,
        t."ReifeZeit",
        t.lam_text,
        t.zug_datum,
        t.labor_status,
        t.lam_res_fuer_auf_id,
        t.lte_res_fuer_vorgang_id,
        t.platz_gesp,
        t.lgr_verwendung,
        t.lam_mhd,
        t.res_mhd,
        t.charge_bez,
        t.min_mhd_r,
        t.ausl_sort,
        t.ausl_sort2,
        t.kunden_nr,
        t.name_1
    from
        chk_ausl_order_test t;


-- sqlcl_snapshot {"hash":"734db3c2dec668b6eeb39129312468f0bf8b26a6","type":"VIEW","name":"CHK_AUSL_ORDER_TEST3","schemaName":"DIRKSPZM32","sxml":""}