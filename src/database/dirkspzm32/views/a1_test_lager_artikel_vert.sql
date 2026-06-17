
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."A1_TEST_LAGER_ARTIKEL_VERT" ("LGR_ORT", "LTE_NAME", "ARTIKEL_ID", "ARTIKEL", "BEZEICHNUNG1", "CHARGE_BEZ", "LHM_NAME", "ANZAHL_LAM", "ANZAHL_RESERVIERT") AS 
  select lgr.lgr_ort,
       lte.lte_name,
       lam.artikel_id,
       a.artikel,
       a.bezeichnung1,
       ch.charge_bez,
       lhm.lhm_name,
       count(lam.lam_id) anzahl_lam,
       count(lam.order_pos_auf_id) anzahl_reserviert
  from lvs_lam lam
       join isi_artikel a on (a.artikel_id = lam.artikel_id)
       join lvs_charge ch on (ch.charge_id = lam.charge_id)
       join lvs_lgr lgr on (lgr.lgr_platz = lam.lgr_platz)
       join lvs_lhm lhm on (lhm.lhm_id = lam.lhm_id)
       join lvs_lte lte on (lte.lte_id = lam.lte_id)
 where lte.lte_status = 'LF'
 group by
       lam.artikel_id,
       a.artikel,
       a.bezeichnung1,
       ch.charge_bez,
       lgr.lgr_ort,
       lte.lte_name,
       lhm.lhm_name
 order by
       lgr.lgr_ort,
       lte.lte_name,
       a.artikel,
       lhm.lhm_name
;


-- sqlcl_snapshot {"hash":"bee6038a6f8a06b4ba297138461fc7c36793f8e4","type":"VIEW","name":"A1_TEST_LAGER_ARTIKEL_VERT","schemaName":"DIRKSPZM32","sxml":""}