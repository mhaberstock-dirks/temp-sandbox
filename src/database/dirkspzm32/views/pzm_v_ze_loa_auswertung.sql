
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_ZE_LOA_AUSWERTUNG" ("UNION_ORDER", "DATA_SRC", "PERS_NR", "TS_DATUM", "KST_ID", "SA_KURZNAME", "AA_ID", "ZE_IST_START", "ZE_IST_ENDE", "ZE_CALC_START", "ZE_CALC_ENDE", "TS_DAY_ABW_STD", "TS_DAY_ARB_STD", "TS_DAY_PAUSE_STD", "TS_DAY_UEB_STD", "TS_DAY_FLEX_STD", "TS_GES_ARB_STD", "LOA_LIST_CR") AS 
  select 0 union_order,
       'ZE' data_src, -- ZE = tägliche Zeiterfassung (time collection)
       ts.ts_pers_nr pers_nr,
       ts.ts_datum,
       nvl(ts.ts_day_kst_id, get_pers_kst_id(ts.ts_pers_nr)) kst_id,
       ts.ts_sa_kurzname sa_kurzname,
       ts.ts_aa_id aa_id,

       to_char(ts.ts_day_ist_start, 'hh24:mi') ze_ist_start,
       to_char(ts.ts_day_ist_ende, 'hh24:mi') ze_ist_ende,
       to_char(ts.ts_day_wert_start, 'hh24:mi') ze_calc_start,
       to_char(ts.ts_day_wert_ende, 'hh24:mi') ze_calc_ende,

       ts.ts_day_abw_std,
       ts.ts_day_arb_std,
       ts.ts_day_pause_std,
       decode(ts_ueb_ok_datum,
         null, 0,
         decode(ts_ueb_storno_datum,
           null, nvl(ts_day_ueb_std, 0), -- genehmigte Überstunden
           0)) ts_day_ueb_std,
       decode(ts_ueb_ok_datum,
         null, 0,
         decode(ts_ueb_storno_datum,
           null, nvl(ts_day_flex_std, 0), -- genehmigte Flexi-Stunden
           0)) ts_day_flex_std,
       (decode(ts_ueb_ok_datum,
         null, 0,
         decode(ts_ueb_storno_datum,
           null, nvl(ts_day_ueb_std, 0) + nvl(ts_day_flex_std, 0), -- genehmigte Überstunden und Flexi-Stunden
           0))
        + nvl(ts_day_arb_std, 0)
        + nvl(ts_day_korr_std, 0)
       ) ts_ges_arb_std,

       (select listagg(
                 loa_ausw.zeaw_lz_lohnart
                   || ': '
                   || case when loa_ausw.zeaw_lz_loa_std > 0 and loa_ausw.zeaw_lz_loa_std < 1 then '0' else '' end -- display leading '0'
                   || decode(loa.lz_einheit,
                        'HH24', round(loa_ausw.zeaw_lz_loa_std, 3) || ' h',
                        round(loa_ausw.zeaw_lz_loa_std, 1) || ' d')
                   || ' (' || loa.lz_bemerkungen || ')',
                 cr_lf()
               ) within group (order by loa_ausw.zeaw_lz_lohnart)
          from pzm_ze_loa_ausw loa_ausw
               left join pzm_lohnarten loa
                 on loa.lz_id = loa_ausw.zeaw_lz_id
         where loa_ausw.zeaw_pers_nr = ts.ts_pers_nr
           and loa_ausw.zeaw_datum = ts.ts_datum) loa_list_cr
  from pzm_ze_tagessatz ts
 where ts.ts_day_wert_ende is not null -- aktuelle Anwesenheit ausblenden

union

-- ERP/HOST (Lohnbuchhaltungssoftware) Datensätze, die erst am Monatsende verfügbar sind
select 1 union_order,
       'LOA_EXP' data_src, -- für den Export generierte LOA-Daten
       loa_exp.pers_nr,
       trunc(loa_exp.datum) - 1 ts_datum,
       nvl(loa_exp.kst_id, get_pers_kst_id(loa_exp.pers_nr)) kst_id,
       null sa_kurzname,
       null aa_id,

       null ze_ist_start,
       null ze_ist_ende,
       null ze_calc_start,
       null ze_calc_ende,

       null ts_day_abw_std,
       null ts_day_arb_std,
       null ts_day_pause_std,

       null ts_day_ueb_std,
       null ts_day_flex_std,
       null ts_ges_arb_std,

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
       trunc(loa_exp.datum),
       loa_exp.kst_id

union

-- Statistik-Werte aus der Zeiterfassung für ERP/HOST (Lohnbuchhaltungssoftware),
-- die erst am Monatsende verfügbar sind
select 2 union_order,
       'STAT_EXP' data_src, -- für den Export generierte LOA-Daten
       loa_stat.pers_nr,
       trunc(loa_stat.datum) - 1 ts_datum,
       get_pers_kst_id(loa_stat.pers_nr) kst_id,
       null sa_kurzname,
       null aa_id,

       null ze_ist_start,
       null ze_ist_ende,
       null ze_calc_start,
       null ze_calc_ende,

       null ts_day_abw_std,
       null ts_day_arb_std,
       null ts_day_pause_std,

       null ts_day_ueb_std,
       null ts_day_flex_std,
       null ts_ges_arb_std,

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


-- sqlcl_snapshot {"hash":"0663275351eb17a4fde5c100751db1278ada69aa","type":"VIEW","name":"PZM_V_ZE_LOA_AUSWERTUNG","schemaName":"DIRKSPZM32","sxml":""}