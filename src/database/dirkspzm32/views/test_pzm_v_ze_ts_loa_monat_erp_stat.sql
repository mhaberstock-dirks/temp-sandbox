create or replace force editionable view dirkspzm32.test_pzm_v_ze_ts_loa_monat_erp_stat (
    union_order,
    data_src,
    pers_nr,
    ts_datum,
    kst_id,
    sa_kurzname,
    aa_id,
    d_arb_std_pro_tag,
    sa_std_pro_tag,
    ts_day_soll_std,
    ze_ist_start,
    ze_ist_ende,
    ze_calc_start,
    ze_calc_ende,
    ts_day_anwesenheit_std,
    ts_day_abw_std,
    ts_day_arb_std,
    ts_day_pause_std,
    ts_day_pause_min,
    ts_day_ueb_std,
    ts_day_flex_std,
    ts_ges_arb_std,
    ist_zeiten_list_cr,
    calc_zeiten_list_cr,
    aa_kurzname_list_cr,
    aa_std_list_cr,
    loa_list_cr
) as
    select
        0                   union_order,
        'ZE'                data_src, -- ZE = tägliche Zeiterfassung (time collection)
        vts.pers_nr,
        vts.ts_datum,
        to_char(vts.kst_id) kst_id,
        vts.sa_kurzname,
        vts.aa_id,
        vts.d_arb_std_pro_tag,
        vts.sa_std_pro_tag,
        vts.ts_day_soll_std,
        vts.ze_ist_start,
        vts.ze_ist_ende,
        vts.ze_calc_start,
        vts.ze_calc_ende,
        vts.ts_day_anwesenheit_std,
        vts.ts_day_abw_std,
        vts.ts_day_arb_std,
        vts.ts_day_pause_std,
        vts.ts_day_pause_min,
        vts.ts_day_ueb_std,
        vts.ts_day_flex_std,
        vts.ts_ges_arb_std,
        vts.ist_zeiten_list_cr,
        vts.calc_zeiten_list_cr,
        vts.aa_kurzname_list_cr,
        vts.aa_std_list_cr,
        vts.loa_list_cr
    from
        pzm_v_ze_ts_loa_monat vts
    union

-- ERP/HOST (Lohnbuchhaltungssoftware) Datensätze, die erst am Monatsende verfügbar sind
    select
        1                        union_order,
        'LOA_EXP'                data_src, -- für den Export generierte LOA-Daten
        loa_exp.pers_nr,
        trunc(loa_exp.datum) - 1 ts_datum,
       -- Performance-Verbesserung: Ersetze Funktionsaufruf durch LEFT JOIN
        nvl(
            stradd_distinct(to_char(loa_exp.kst_id)),
            to_char(p.pers_kst_id)
        )                        kst_id,
        null                     sa_kurzname,
        null                     aa_id,
        null                     d_arb_std_pro_tag,
        null                     sa_std_pro_tag,
        null                     ts_day_soll_std,
        null                     ze_ist_start,
        null                     ze_ist_ende,
        null                     ze_calc_start,
        null                     ze_calc_ende,
        null                     ts_day_anwesenheit_std,
        null                     ts_day_abw_std,
        null                     ts_day_arb_std,
        null                     ts_day_pause_std,
        null                     ts_day_pause_min,
        null                     ts_day_ueb_std,
        null                     ts_day_flex_std,
        null                     ts_ges_arb_std,
        null                     ist_zeiten_list_cr,
        null                     calc_zeiten_list_cr,
        null                     aa_kurzname_list_cr,
        null                     aa_std_list_cr,
        listagg(loa_exp.lohnart
                || ': '
                ||
                case
                    when loa_exp.loa_value > 0
                         and loa_exp.loa_value < 1 then
                        '0'
                    else
                        ''
                end -- display leading '0'
                || decode(loa_exp.loa_unit,
                          'HH24',
                          round(loa_exp.loa_value, 2)
                          || ' h',
                          'STD',
                          round(loa_exp.loa_value, 2)
                          || ' h',
                          loa_exp.loa_value || ' d')
                || ' ('
                || loae.lz_bemerkungen
                || ')',
                cr_lf()) within group(
        order by
            loa_exp.lohnart
        )                        loa_list_cr
    from
        pzm_ze_loa_exp_host loa_exp
        left join pzm_lohnarten       loae on loae.lz_id = loa_exp.lz_id
       -- NEUER JOIN: Holt die Kostenstelle direkt aus PZM_PERSONAL
        left join pzm_personal        p on p.pers_nr = loa_exp.pers_nr
    group by
        loa_exp.pers_nr,
        trunc(loa_exp.datum),
        p.pers_kst_id  -- Füge die Spalte zum GROUP BY hinzu
        ;


-- sqlcl_snapshot {"hash":"0b75e5c4006e7e691e2b150ed9868368c976b465","type":"VIEW","name":"TEST_PZM_V_ZE_TS_LOA_MONAT_ERP_STAT","schemaName":"DIRKSPZM32","sxml":""}