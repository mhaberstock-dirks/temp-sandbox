
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."Z_V_PD_CHANGES" ("RES_PRUEF_PLAN_DATA_BEZ", "RES_TEILGEWERK", "RES_NAME", "TEXT", "RES_PRUEF_PLAN_DATA_VALUE", "DATEN_FAKTOR", "EINHEIT", "USER_FULL_NAME", "LAST_CHANGE_DATE") AS 
  select ppdc.res_pruef_plan_data_bez, ppdc.res_teilgewerk, res.res_name, res.text,/* art.artikel,*/
/*art.bezeichnung1, */ppd.res_pruef_plan_data_value, ppdc.daten_faktor, ppdc.einheit,
case
  when ppd.last_change_login_id is not null then usr.nachname || ', ' || usr.vorname
  else ''
end as user_full_name,
ppd.last_change_date
from ISI_RES_PRUEF_PLAN_DATA ppd
inner join ISI_RES_PRUEF_PLAN_DATA_CFG ppdc on
ppd.sid = ppdc.sid and ppd.firma_nr = ppdc.firma_nr and ppd.res_id = ppdc.res_id
and ppd.res_teilgewerk = ppdc.res_teilgewerk and ppd.res_pruef_plan_data_nr = ppdc.res_pruef_plan_data_nr
--left join isi_artikel art on ppd.artikel_id = art.artikel_id
inner join isi_resource res on ppd.res_id = res.res_id
left join isi_user usr on ppd.last_change_login_id =usr.login_id
;


-- sqlcl_snapshot {"hash":"e471ca8e2706e25b9580ca4239db7714484192ba","type":"VIEW","name":"Z_V_PD_CHANGES","schemaName":"DIRKSPZM32","sxml":""}