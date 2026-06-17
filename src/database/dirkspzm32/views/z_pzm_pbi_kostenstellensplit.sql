
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."Z_PZM_PBI_KOSTENSTELLENSPLIT" ("BU_ID", "BU_NAME", "LNR", "FIRMA", "PERSONALNUMMER", "VORNAME", "NACHNAME", "DATUM", "KOSTENSTELLE", "WERTART", "WERT", "ABTEILUNG", "LAST_CHANGE_DATE") AS 
  select   b.bu_id,
         b.bu_name,
         substr(p.pers_nr ||
         ts.ts_day_kst_id ||
         to_char(ts.ts_datum, 'ddmmyyyy') ||
         'Anwesende_Zeit', 1, 150) lnr,
         get_pers_pb_id(p.pers_nr) firma,
         p.pers_nr personalnummer,
         substr(p.pers_vname, 1, 50) vorname,
         substr(p.pers_nname, 1, 59) nachname,
         ts.ts_datum datum,
         ts.ts_day_kst_id kostenstelle,
         'Anwesende Zeit' wertart,
         round(ts.ts_day_arb_std + ts.ts_day_ueb_std + ts.ts_day_flex_std, 2) wert,
         substr(a.abt_name, 1, 50) abteilung,
         nvl(ts.last_change_date, ts.created_date) last_change_date
    from pzm_personal p,
         pzm_ze_tagessatz ts,
         pzm_abteilungen a,
         pzm_produktionsbereiche_bu bu,
         pzm_prod_business_units_bereiche b
   where p.pers_nr = ts.ts_pers_nr
     and p.pers_abt_id = a.abt_id
     and a.abt_pb_id = bu.pb_id(+)
     and bu.bu_id = b.bu_id(+)
     and ts.ts_day_arb_std + ts.ts_day_ueb_std + ts.ts_day_flex_std > 0
     and ts.ts_datum <= nvl(p.pers_austrittdatum, ts.ts_datum)
     --and ts.ts_datum >= trunc(sysdate) - 90
union
    select b.bu_id,
         b.bu_name,
         substr(p.pers_nr ||
         ze.ze_kst_id ||
         to_char(ze.ze_schicht_tag, 'ddmmyyyy') ||
         ze.ze_aa_status, 1, 150) lnr,
         get_pers_pb_id(p.pers_nr) firma,
         p.pers_nr personalnummer,
         substr(p.pers_vname, 1, 50) vorname,
         substr(p.pers_nname, 1, 50) nachname,
         ze.ze_schicht_tag,
         ze.ze_kst_id kostenstelle,
         substr(aa.aa_name, 1, 50) wertart,
         round(sum(ze.ze_std), 2) wert,
         substr(a.abt_name, 1, 50) abteilung,
         max(nvl(ze.last_change_date, ze.created_date)) last_change_date
    from pzm_personal p,
         pzm_zeiterfassung ze,
         pzm_abteilungen a,
         pzm_abwesenheitsarten aa,
         pzm_produktionsbereiche_bu bu,
         pzm_prod_business_units_bereiche b
   where p.pers_nr = ze.ze_pers_nr
     and p.pers_abt_id = a.abt_id
     and a.abt_pb_id = bu.pb_id(+)
     and bu.bu_id = b.bu_id(+)
     and ze.ze_aa_status = aa.aa_id
     --and ze.ze_schicht_tag >= trunc(sysdate) - 90
     and ze.ze_schicht_tag <= nvl(p.pers_austrittdatum, ze.ze_schicht_tag)
group by b.bu_id,
         b.bu_name,
         ze.ze_aa_status,
         p.pers_nr,
         p.pers_vname,
         p.pers_nname,
         ze.ze_schicht_tag,
         ze.ze_kst_id,
         aa.aa_name,
         a.abt_name
;


-- sqlcl_snapshot {"hash":"fe6b60b56ed1645e6c918acd1a4152e7d31ac729","type":"VIEW","name":"Z_PZM_PBI_KOSTENSTELLENSPLIT","schemaName":"DIRKSPZM32","sxml":""}