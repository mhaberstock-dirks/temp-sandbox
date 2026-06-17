
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_ARB_ZEIT_VERSTOESSE" ("LFDN", "VERSTOSS_ART", "TS_DATUM", "BU_ID", "BU_NAME", "PB_ID", "FIRMA", "MANDANT", "TS_PERS_NR", "TS_DAY_KST_ID", "TS_DAY_WERT_START", "TS_DAY_WERT_ENDE", "T2_TS_DAY_WERT_START", "DAY_ARB_UE_STD", "DAY_RUHE_STD", "LAST_CHANGE_DATE") AS 
  select to_char(t.ts_datum, 'yyyymmdd') || t.ts_pers_nr lfdn,
       case when t.ts_day_anw_std - t.ts_day_pause_std > 10
            then 'ARB_ZEIT'
            else 'RUHE_ZEIT'
            end verstoss_art,
       t.ts_datum,
       b.bu_id,
       b.bu_name,
              pb.pb_id,
       case when nvl(pb.pb_extern, 'F') = 'T'
            then nvl(pb.pb_bemerkungen, t.ts_day_pb_id)
            else to_char(t.ts_day_pb_id)
            end
            firma,
       (select a.abt_pb_id
          from pzm_abteilungen a
         where (select min(z.ze_abt_id) from pzm_zeiterfassung z where z.ze_schicht_tag = t.ts_datum and z.ze_pers_nr = t.ts_pers_nr) = a.abt_id
       ) mandant,
       t.ts_pers_nr,
       t.ts_day_kst_id,
       t.ts_day_wert_start,
       t.ts_day_wert_ende,
       t2.ts_day_wert_start t2_ts_day_wert_start,
       t.ts_day_anw_std - t.ts_day_pause_std day_arb_ue_std,
       case when (t2.ts_day_wert_start - t.ts_day_wert_ende)  * 24 < 11
            then (t2.ts_day_wert_start - t.ts_day_wert_ende) * 24
             else NULL
             end day_ruhe_std,
       case when nvl(nvl(t2.last_change_date, t2.created_date), nvl(t.last_change_date, t.created_date)) > nvl(t.last_change_date, t.created_date)
            then nvl(t2.last_change_date, t2.created_date)
            else nvl(t.last_change_date, t.created_date)
            end last_change_date
  from PZM_ZE_TAGESSATZ t,
       PZM_ZE_TAGESSATZ t2,
       pzm_produktionsbereiche pb,
       pzm_abteilungen a,
       pzm_produktionsbereiche_bu bu,
       pzm_prod_business_units_bereiche b
where t.ts_pers_nr = t2.ts_pers_nr(+)
  and t.ts_datum + 1 = t2.ts_datum(+)
  and t.ts_day_arb_std > 0
  and t2.ts_abwesenheit = 0
  and (t.ts_day_anw_std - t.ts_day_pause_std > 10
   or (t2.ts_day_wert_start - t.ts_day_wert_ende)  * 24 < 11)
  and pb.pb_id(+) = t.ts_day_pb_id
  and t.ts_day_abt_id = a.abt_id(+)
  and a.abt_pb_id = bu.pb_id(+)
  and bu.bu_id = b.bu_id(+)
order by t.ts_day_pb_id,
         t.ts_pers_nr,
         t.ts_datum
;


-- sqlcl_snapshot {"hash":"599b57af3ebd8d99017ac922c73b62a4326fe927","type":"VIEW","name":"PZM_V_ARB_ZEIT_VERSTOESSE","schemaName":"DIRKSPZM32","sxml":""}