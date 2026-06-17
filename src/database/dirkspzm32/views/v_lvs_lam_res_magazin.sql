
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."V_LVS_LAM_RES_MAGAZIN" ("MAIN_RES_ID", "SID", "FIRMA_NR", "LAM_ID", "RES_NAME", "ARTIKEL_ID", "ARTIKEL", "BEZEICHNUNG1", "LTE_ID", "LHM_ID", "CHARGE_ID", "MAG_PARAMS", "MAG_NAME", "SERIE_ID", "LEITZAHL", "FA_AG", "FA_UPOS", "AB_NR", "BEST_NR", "BEST_POS", "RES_ID", "PROD_DATUM", "ZUG_DATUM", "LS_LOGIN_ID", "MENGE", "LAM_KG", "LAM_TEXT", "LABOR_STATUS", "LABOR_TEXT", "LAM_MHD", "KUNDEN_NR", "KD_ART_NR", "LIEFERANT_NR", "LAM_MHD_AUSGABE", "MENGE_BASIS", "MENGENEINHEIT_BASIS", "ORDER_POS_AUF_ID", "ZEICHNUNG", "ZEICHNUNG_INDEX", "LI_NR_LIEF", "LTE_ID_LIEFERANT", "SONST_ID_LIEFERANT", "AKT_INVENTUR_ID", "LETZTE_INVENTUR_ID", "LETZTE_INVENTUR_DATUM", "LETZTE_INVENTUR_LOGIN_ID", "LAM_P1", "LAM_P2", "LAM_P3", "LAM_P4", "LAM_P5", "LAM_P6", "LAM_P7", "LAM_P8", "LAM_P9", "LAM_P10", "RES_MENGE", "RES_ZIEL_LTE_ID", "RES_LOGIN_ID", "CHECK_WARE_TRANSP_ID", "FAE_ID", "FAE_ID_POSITION", "QS_STATUS", "WAREN_TYP", "LHM_LFD_NR", "PACKSCHEMA_KOPF_ID", "PACKSCHEMA_LFDN", "LHM_C_LFD_NR", "OWNER_ADDRESS_ID", "LAM_SEL1", "LAM_SEL2", "LAM_SEL3", "LAM_SEL4", "LAM_SEL5", "LAM_SEL6", "LAM_SEL7", "LAM_SEL8", "LAM_SEL9", "LAM_SEL10", "HERSTELLER_KUERZEL_LISTE") AS 
  select xx.res_id as main_res_id, lam."SID", lam."FIRMA_NR", lam."LAM_ID", xx.res_name, lam."ARTIKEL_ID", ia.artikel, ia.bezeichnung1,
       lam."LTE_ID", lam."LHM_ID", lam."CHARGE_ID", xx.mag_params, xx.mag_name, /*lam."LGR_PLATZ",*/lam."SERIE_ID", lam."LEITZAHL",
       lam."FA_AG", lam."FA_UPOS", lam."ABNR" ab_nr, lam."BEST_NR", lam."BEST_POS", lam."RES_ID", lam."PROD_DATUM", lam."ZUG_DATUM",
       lam."LS_LOGIN_ID", lam."MENGE", lam."LAM_KG", lam."LAM_TEXT", lam."LABOR_STATUS", lam."LABOR_TEXT", lam."LAM_MHD", lam."KUNDEN_NR",
       lam."KD_ART_NR", lam."LIEFERANT_NR", lam."LAM_MHD_AUSGABE", lam."MENGE_BASIS", lam."MENGENEINHEIT_BASIS", lam."ORDER_POS_AUF_ID",
       lam."ZEICHNUNG", lam."ZEICHNUNG_INDEX", lam."LI_NR_LIEF", lam."LTE_ID_LIEFERANT", lam."SONST_ID_LIEFERANT", lam."AKT_INVENTUR_ID",
       lam."LETZTE_INVENTUR_ID",lam."LETZTE_INVENTUR_DATUM",lam."LETZTE_INVENTUR_LOGIN_ID", lam."LAM_P1", lam."LAM_P2", lam."LAM_P3",
       lam."LAM_P4", lam."LAM_P5", lam."LAM_P6", lam."LAM_P7", lam."LAM_P8", lam."LAM_P9", lam."LAM_P10", lam."RES_MENGE",
       lam."RES_ZIEL_LTE_ID", lam."RES_LOGIN_ID", lam."CHECK_WARE_TRANSP_ID", lam."FAE_ID", lam."FAE_ID_POSITION", lam."QS_STATUS",
       lam."WAREN_TYP", lam."LHM_LFD_NR", lam."PACKSCHEMA_KOPF_ID", lam."PACKSCHEMA_LFDN", lam."LHM_C_LFD_NR", lam."OWNER_ADDRESS_ID",
       lam."LAM_SEL1", lam."LAM_SEL2", lam."LAM_SEL3", lam."LAM_SEL4", lam."LAM_SEL5", lam."LAM_SEL6", lam."LAM_SEL7", lam."LAM_SEL8",
       lam."LAM_SEL9", lam."LAM_SEL10", lam."HERSTELLER_KUERZEL_LISTE"
       from lvs_lam lam
inner join
   (select r.res_id, rm.lager_roh, r.res_name, res_mc.mag_params, rm.res_name mag_name
                            from isi_resource r,
                                 isi_resource rmg,
                                 isi_resource rm,
                                 isi_res_magazin res_m,
                                 isi_res_mag_cfg res_mc
                           where 1=1
                             --and r.res_name = 'AP07'
                             and r.res_id = rmg.parent_res_id
                             and r.res_id = res_m.res_id
                             and res_mc.res_id = res_m.ma_res_id
                             and rm.res_id = res_mc.res_id
                         ) xx on lam.lgr_platz = xx.lager_roh
inner join isi_artikel ia on ia.artikel_id = lam.artikel_id
;


-- sqlcl_snapshot {"hash":"ef941ba0a0f5e0ec0b6a5261e6a32f7907ae4822","type":"VIEW","name":"V_LVS_LAM_RES_MAGAZIN","schemaName":"DIRKSPZM32","sxml":""}