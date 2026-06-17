
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."LVS_V_ART_LTE_NAME_V_ORT_Z_ORT" ("SID", "ARTIKEL_ID", "ARTIKEL", "BEZEICHNUNG1", "LGR_ORT_QUELLE", "LGR_ORT_ZIEL", "LTE_NAME_QUELLE", "LTE_NAME_ZIEL", "LTE_MENGE_ZIEL") AS 
  select a_lte_cfg.sid,
       a.artikel_id,
       a.artikel,
       a.bezeichnung1,
       lu.lgr_ort_quelle,
       lu.lgr_ort_ziel,
       a.lte_name lte_name_quelle,
       a_lte_cfg.lte_name lte_name_ziel,
       a_lte_cfg.lte_menge lte_menge_ziel
  from lvs_lgr_ort_ue_platz lu,
       ISI_ARTIKEL_LTE_CFG a_lte_cfg,
       isi_artikel a
 where lu.lte_name = a.lte_name
   and lu.lte_name_ziel = a_lte_cfg.lte_name
   and a_lte_cfg.artikel_id = a.artikel_id
;


-- sqlcl_snapshot {"hash":"7a9e1bc63e8a4148159d4e2af4d66dfc91642b0f","type":"VIEW","name":"LVS_V_ART_LTE_NAME_V_ORT_Z_ORT","schemaName":"DIRKSPZM32","sxml":""}