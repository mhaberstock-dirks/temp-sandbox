
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PZM_V_PERS_SCHICHT_MODELL" ("PERS_NR", "SM_NAME") AS 
  select p.pers_nr,
       nvl(nvl(p.pers_sm_name, k.kst_standard_sm_name), a.abt_standard_sm_name) as sm_name
  from pzm_personal p
  join pzm_abteilungen a on a.abt_id = p.pers_abt_id
  left join isi_kostenstellen k on k.kst_nr = nvl(p.pers_kst_id, a.abt_kst_id);


-- sqlcl_snapshot {"hash":"6a505c7bcd5efb548604ccf61174e2052dc39f0d","type":"VIEW","name":"PZM_V_PERS_SCHICHT_MODELL","schemaName":"DIRKSPZM32","sxml":""}