
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."LVS_V_LHM" ("SID", "FIRMA_NR", "LHM_ID", "LTE_ID", "LHM_NAME", "LGR_PLATZ", "LHM_VOL_HOEHE", "LHM_VOL_BREITE", "LHM_VOL_TIEFE", "LHM_VOL", "LHM_AKT_KG", "LHM_LETZTE_BUCHUNG", "LHM_ETI_DRUCK_STATUS", "KOMM_QUELL_LTE_ID", "KOMM_QUELL_LGR_PLATZ", "KOMM_NEU_LHM_NAME") AS 
  select lhm."SID",lhm."FIRMA_NR",lhm."LHM_ID",lhm."LTE_ID",lhm."LHM_NAME",lhm."LGR_PLATZ",lhm."LHM_VOL_HOEHE",lhm."LHM_VOL_BREITE",lhm."LHM_VOL_TIEFE",lhm."LHM_VOL",lhm."LHM_AKT_KG",lhm."LHM_LETZTE_BUCHUNG",lhm."LHM_ETI_DRUCK_STATUS",lhm."KOMM_QUELL_LTE_ID",lhm."KOMM_QUELL_LGR_PLATZ",lhm."KOMM_NEU_LHM_NAME"
  from lvs_lhm lhm
union
select lhm_hist."SID",lhm_hist."FIRMA_NR",lhm_hist."LHM_ID",lhm_hist."LTE_ID",lhm_hist."LHM_NAME",lhm_hist."LGR_PLATZ",lhm_hist."LHM_VOL_HOEHE",lhm_hist."LHM_VOL_BREITE",lhm_hist."LHM_VOL_TIEFE",lhm_hist."LHM_VOL",lhm_hist."LHM_AKT_KG",lhm_hist."LHM_LETZTE_BUCHUNG",lhm_hist."LHM_ETI_DRUCK_STATUS",lhm_hist."KOMM_QUELL_LTE_ID",lhm_hist."KOMM_QUELL_LGR_PLATZ",lhm_hist."KOMM_NEU_LHM_NAME"
  from lvs_lhm_hist lhm_hist
;


-- sqlcl_snapshot {"hash":"b5866dfae9f670f0f3c577416361a2bd1fbf77b4","type":"VIEW","name":"LVS_V_LHM","schemaName":"DIRKSPZM32","sxml":""}