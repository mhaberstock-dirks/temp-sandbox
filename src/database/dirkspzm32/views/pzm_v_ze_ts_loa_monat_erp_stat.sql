
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_ZE_TS_LOA_MONAT_ERP_STAT" ("UNION_ORDER", "DATA_SRC", "PERS_NR", "TS_DATUM", "KST_ID", "SA_KURZNAME", "AA_ID", "D_ARB_STD_PRO_TAG", "SA_STD_PRO_TAG", "TS_DAY_SOLL_STD", "ZE_IST_START", "ZE_IST_ENDE", "ZE_CALC_START", "ZE_CALC_ENDE", "TS_DAY_ANWESENHEIT_STD", "TS_DAY_ABW_STD", "TS_DAY_ARB_STD", "TS_DAY_PAUSE_STD", "TS_DAY_PAUSE_MIN", "TS_DAY_UEB_STD", "TS_DAY_FLEX_STD", "TS_GES_ARB_STD", "IST_ZEITEN_LIST_CR", "CALC_ZEITEN_LIST_CR", "AA_KURZNAME_LIST_CR", "AA_STD_LIST_CR", "LOA_LIST_CR") AS 
  select 0 union_order,
       'ZE' data_src, -- ZE = tägliche Zeiterfassung (time collection)
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
  from pzm_v_ze_ts_loa_monat vts

union

-- ERP/HOST (Lohnbuchhaltungssoftware) Datensätze, die erst am Monatsende verfügbar sind
select 1 union_order,
       'LOA_EXP' data_src, -- für den Export generierte LOA-Daten
       loa_exp.pers_nr,
       trunc(loa_exp.datum) - 1 ts_datum,
       nvl(stradd_distinct(to_char(loa_exp.kst_id)), to_char(get_pers_kst_id(loa_exp.pers_nr))) kst_id,
       null sa_kurzname,
       null aa_id,

       null d_arb_std_pro_tag,
       null sa_std_pro_tag,
       null ts_day_soll_std,

       null ze_ist_start,
       null ze_ist_ende,
       null ze_calc_start,
       null ze_calc_ende,

       null ts_day_anwesenheit_std,
       null ts_day_abw_std,
       null ts_day_arb_std,
       null ts_day_pause_std,
       null ts_day_pause_min,

       null ts_day_ueb_std,
       null ts_day_flex_std,
       null ts_ges_arb_std,

       null ist_zeiten_list_cr,
       null calc_zeiten_list_cr,
       null aa_kurzname_list_cr,
       null aa_std_list_cr,
       listagg(
         loa_exp.lohnart
           || ': '
           || case when loa_exp.loa_value > 0 and loa_exp.loa_value < 1 then '0' else '' end -- display leading '0'
           || decode(loa_exp.loa_unit,
                'HH24', round(loa_exp.loa_value, 2) || ' h',
                'STD', round(loa_exp.loa_value, 2) || ' h',
                loa_exp.loa_value || ' d'
              )
           || ' (' || loae.lz_bemerkungen || ')',
         cr_lf()
       ) within group (order by loa_exp.lohnart) loa_list_cr
  from pzm_ze_loa_exp_host loa_exp
       left join pzm_lohnarten loae
         on loae.lz_id = loa_exp.lz_id
 group by
       loa_exp.pers_nr,
       trunc(loa_exp.datum)--,
       --loa_exp.kst_id

union

-- Statistik-Werte aus der Zeiterfassung für ERP/HOST (Lohnbuchhaltungssoftware),
-- die erst am Monatsende verfügbar sind
select 2 union_order,
       'STAT_EXP' data_src, -- für den Export generierte LOA-Daten
       loa_stat.pers_nr,
       trunc(loa_stat.datum) - 1 ts_datum,
       to_char(get_pers_kst_id(loa_stat.pers_nr)) kst_id,
       null sa_kurzname,
       null aa_id,

       null d_arb_std_pro_tag,
       null sa_std_pro_tag,
       null ts_day_soll_std,

       null ze_ist_start,
       null ze_ist_ende,
       null ze_calc_start,
       null ze_calc_ende,

       null ts_day_anwesenheit_std,
       null ts_day_abw_std,
       null ts_day_arb_std,
       null ts_day_pause_std,
       null ts_day_pause_min,

       null ts_day_ueb_std,
       null ts_day_flex_std,
       null ts_ges_arb_std,

       null ist_zeiten_list_cr,
       null calc_zeiten_list_cr,
       null aa_kurzname_list_cr,
       null aa_std_list_cr,
       listagg(
         loa_stat.stat_unit
           || ': '
           || case when loa_stat.stat_value > 0 and loa_stat.stat_value < 1 then '0' else '' end -- display leading '0'
           || decode(stat_cfg.value_unit,
                'HH24', round(loa_stat.stat_value, 2) || ' h',
                'STD', round(loa_stat.stat_value, 2) || ' h',
                loa_stat.stat_value || ' d'
              )
           || ' (' || stat_cfg.kommentar || ')',
         cr_lf()
       ) within group (order by loa_stat.stat_unit) loa_list_cr
  from pzm_ze_loa_statistik_exp_host loa_stat
       left join pzm_ze_loa_statistik_cfg stat_cfg
         on stat_cfg.stat_unit = loa_stat.stat_unit
 group by
       loa_stat.pers_nr,
       trunc(loa_stat.datum)

 order by ts_datum, union_order
;


-- sqlcl_snapshot {"hash":"0ab0d5c235c78ed69c62b047936bebde05972bf8","type":"VIEW","name":"PZM_V_ZE_TS_LOA_MONAT_ERP_STAT","schemaName":"DIRKSPZM32","sxml":""}