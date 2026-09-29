
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PZM_V_VORGANGSQUAL_W_PLAN" ("VQ_ABT_ID", "ABT_KURZ_NAME", "ABT_NAME", "W_PLAN_ID", "W_PLAN_START", "W_PLAN_VQ_ID", "W_PLAN_DATUM", "W_PLAN_SCHICHT", "W_PLAN_VON_ZEIT", "W_PLAN_BIS_ZEIT", "W_PLAN_EINSATZ_NR", "W_PLAN_PERS_NR", "W_PLAN_EINSATZ_WERT", "CREATED_DATE", "CREATED_LOGIN_ID", "LAST_CHANGE_DATE", "LAST_CHANGE_LOGIN_ID", "VQ_BEZEICHNUNG", "W_PLAN_V_CHECK_NR", "W_PLAN_V_EINTRAG_VALIDE", "W_PLAN_V_VALALID_BESCHREIBUNG_KURZ", "W_PLAN_V_VALALID_BESCHREIBUNG") AS 
  select vq.vq_abt_id, abt.abt_kurz_name, abt.abt_name, t."W_PLAN_ID",t."W_PLAN_START",t."W_PLAN_VQ_ID",t."W_PLAN_DATUM",t."W_PLAN_SCHICHT",t."W_PLAN_VON_ZEIT",t."W_PLAN_BIS_ZEIT",t."W_PLAN_EINSATZ_NR",t."W_PLAN_PERS_NR",t."W_PLAN_EINSATZ_WERT",t."CREATED_DATE",t."CREATED_LOGIN_ID",t."LAST_CHANGE_DATE",t."LAST_CHANGE_LOGIN_ID",
       vq.vq_bezeichnung,
       vqv.w_plan_v_check_nr,
       vqv.w_plan_v_eintrag_valide,
       vqv.w_plan_v_valalid_beschreibung_kurz,
       vqv.w_plan_v_valalid_beschreibung
  from PZM_VORGANGSQUAL_W_PLAN t,
       pzm_vorgangsqualifikation vq,
       PZM_VORGANGSQUAL_W_PLAN_valide vqv,
       pzm_abteilungen abt
 where t.w_plan_vq_id = vq.vq_id
   and t.w_plan_id = vqv.w_plan_id
   and t.w_plan_einsatz_nr = 1
   and vq.vq_abt_id = abt.abt_id
 order by t.w_plan_datum, t.w_plan_vq_id, t.w_plan_von_zeit;


-- sqlcl_snapshot {"hash":"1c928b4cc24175f3889897f5b6572fa429df90f2","type":"VIEW","name":"PZM_V_VORGANGSQUAL_W_PLAN","schemaName":"DIRKSPZM32","sxml":""}