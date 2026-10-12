
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "Z_PZM_BU_DIS" ("BU_ID", "DATUM", "PERS_NR", "PD_MANDANT", "MANDANT", "ABTEILUNG", "START_ZEIT", "ENDE_ZEIT") AS 
  select t.bu_id,
       t.datum,
       substr(t.persnr, 1, 3) pers_nr,
       t.pd_mandant,
       t.mandant,
       t.abteilung,
       t.start_zeit,
       t.ende_zeit
  from Z_PZM_PBI_BUCHUNGSDATEN t
where t.persnr >= 10000 and t.lnr not like 'ABW%' and t.art = '0' and t.bu_id = 2
  --and t.datum >= to_date('01.08.2026', 'dd.mm.yyyy') and t.datum <= to_date('31.08.2026', 'dd.mm.yyyy')
order by t.datum, t.bu_id, t.abteilung, t.persnr;


-- sqlcl_snapshot {"hash":"b64407fd8022be16cd9cd902d24c40c4f11a9a03","type":"VIEW","name":"Z_PZM_BU_DIS","schemaName":"DIRKSPZM32","sxml":""}