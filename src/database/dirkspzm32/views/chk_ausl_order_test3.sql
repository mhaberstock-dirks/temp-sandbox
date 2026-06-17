
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."CHK_AUSL_ORDER_TEST3" ("OK_STATUS", "VORGANG_ID", "AUF_ID", "ARTIKEL", "LTE_ID", "LGR_PLATZ", "RESERVIERT", "LGR_VERWENDUNG_LTE_STATUS", "CHECK_FA", "Q_LGR_ORT_SEMIKOLON", "LAM_MENGE_ULHM", "Q_LGR_ORT_ORDER_LTE", "ORDER_POS_AUTO_DEPAL", "ORDER_POS_WARE_DISPONIERT", "M_INV", "LABOR_ST", "LAM_SEL1_10", "CHARGE", "SERIE", "MHD", "MIN_MHD", "ANBRUCH", "CHK_RESERV", "KONSI", "P_DATUM", "LGR_GESPERRT", "L_INV", "L_ORTE", "FARZEUG_OK", "Z_IDX", "Z_MENGE", "LEITZAHL", "FA_AG", "MENGE", "RESERVIERTE_MENGE", "ReifeZeit", "LAM_TEXT", "ZUG_DATUM", "LABOR_STATUS", "LAM_RES_FUER_AUF_ID", "LTE_RES_FUER_VORGANG_ID", "PLATZ_GESP", "LGR_VERWENDUNG", "LAM_MHD", "RES_MHD", "CHARGE_BEZ", "MIN_MHD_R", "AUSL_SORT", "AUSL_SORT2", "KUNDEN_NR", "NAME_1") AS 
  select case when t.reserviert = 'Frei' and
                 t.check_fa like '%OK%' and
                 t.order_pos_auto_depal like '%OK%' and
                 t.q_lgr_ort_semikolon like '%OK%' and
                 t.LAM_Menge_ULHM like '%OK%' and
                 t.q_lgr_ort_order_lte like '%OK%' and
                 t.order_pos_ware_disponiert like '%OK%' and
                 t.lgr_verwendung_lte_status like '%OK%' and
                 t.m_inv like '%OK%' and
                 t.labor_st like '%OK%' and
                 t.lam_sel1_10 like '%OK%' and
                 t.charge like '%OK%' and
                 t.serie like '%OK%' and
                 t.mhd like '%OK%' and
                 t.min_mhd like '%OK%' and
                 t.anbruch like '%OK%' and
                 t.chk_reserv like '%OK%' and
                 t.konsi like '%OK%' and
                 t.p_datum like '%OK%' and
                 t.lgr_gesperrt like '%OK%' and
                 t.l_inv like '%OK%' and
                 t.l_orte like '%OK%' and
                 t.z_idx like '%OK%' and
                 t.z_menge like '%OK%' and
                 (t.farzeug_ok like '%OK%' or t.farzeug_ok like '%T%')
            then
              'OK'
            else
              'ERR'
            end OK_STATUS,
       t."VORGANG_ID",t."AUF_ID",t."ARTIKEL",t."LTE_ID",t."LGR_PLATZ",t."RESERVIERT",t."LGR_VERWENDUNG_LTE_STATUS",t."CHECK_FA",t."Q_LGR_ORT_SEMIKOLON",t."LAM_MENGE_ULHM",t."Q_LGR_ORT_ORDER_LTE",t."ORDER_POS_AUTO_DEPAL",t."ORDER_POS_WARE_DISPONIERT",t."M_INV",t."LABOR_ST",t."LAM_SEL1_10",t."CHARGE",t."SERIE",t."MHD",t."MIN_MHD",t."ANBRUCH",t."CHK_RESERV",t."KONSI",t."P_DATUM",t."LGR_GESPERRT",t."L_INV",t."L_ORTE",t."FARZEUG_OK",t."Z_IDX",t."Z_MENGE",t."LEITZAHL",t."FA_AG",t."MENGE",t."RESERVIERTE_MENGE",t."ReifeZeit",t."LAM_TEXT",t."ZUG_DATUM",t."LABOR_STATUS",t."LAM_RES_FUER_AUF_ID",t."LTE_RES_FUER_VORGANG_ID",t."PLATZ_GESP",t."LGR_VERWENDUNG",t."LAM_MHD",t."RES_MHD",t."CHARGE_BEZ",t."MIN_MHD_R",t."AUSL_SORT",t."AUSL_SORT2",t."KUNDEN_NR",t."NAME_1"
  from chk_ausl_order_test t
;


-- sqlcl_snapshot {"hash":"444c47e6fd6f3ff8fd11e144b855906a035110ff","type":"VIEW","name":"CHK_AUSL_ORDER_TEST3","schemaName":"DIRKSPZM32","sxml":""}