
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "Z_PZM_POLEN" ("KOMMT", "BU_ID", "BU_NAME", "LNR", "DATUM", "FIRMA", "PD_MANDANT", "MANDANT", "PERSNR", "NAME", "VORNAME", "ABTEILUNG", "ART", "WERT", "KOSTENSTELLE", "STATUS", "STATUS_TEXT", "STATUS_TEXT2", "SAP_ZUORDNUNG", "START_ZEIT", "ENDE_ZEIT", "LAST_CHANGE_DATE") AS 
  select to_date(to_char (t.datum, 'dd.mm.yyyy') || ' ' || t.start_zeit, 'dd.mm.yyyy hh24:mi') kommt,
t."BU_ID",t."BU_NAME",t."LNR",t."DATUM",t."FIRMA",t."PD_MANDANT",t."MANDANT",t."PERSNR",t."NAME",t."VORNAME",t."ABTEILUNG",t."ART",t."WERT",t."KOSTENSTELLE",t."STATUS",t."STATUS_TEXT",t."STATUS_TEXT2",t."SAP_ZUORDNUNG",t."START_ZEIT",t."ENDE_ZEIT",t."LAST_CHANGE_DATE"
from Z_PZM_PBI_BUCHUNGSDATEN t
where t.mandant in (651, 652)
  and t.status = '503'
order by t.mandant, t.datum desc, t.persnr;


-- sqlcl_snapshot {"hash":"3f73aa5033e3c21b4639713c930d925a5afd05a9","type":"VIEW","name":"Z_PZM_POLEN","schemaName":"DIRKSPZM32","sxml":""}