
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."LVS_TRANS_UND_ZIEL_CHK2" ("LI_NR", "LEITZAHL", "RES_NAME_LIST", "LGR_PLATZ", "LGR_PLATZ_GRUPPE", "ANZ_TRANSPORTE_FREI", "ANZ_LAM_ORDER_RES_TRANS_FREI", "ANZ_LAM_ORDER_RES_TRANS_NEU", "ANZ_LAM_ORDER_RES_TRANS_ST_T", "LGR_AKT_TE", "MAX_TRANSPORTE") AS 
  select pos.li_nr, fa.leitzahl, t.res_name_list, t.lgr_platz, t.lgr_platz_gruppe, t.anz_transporte_frei, t.anz_lam_order_res_trans_frei, t.anz_lam_order_res_trans_neu, t.anz_lam_order_res_trans_st_t,
t.lgr_akt_te, t.max_transporte
       from lvs_trans_und_ziel_mit_res_chk t
       left join lvs_lte lte on t.lgr_platz = lte.lgr_platz or t.lgr_platz =lte.ziel_lgr_platz
       left join lvs_lam lam on lam.lte_id = lte.lte_id
       left join bde_fa_auftrag fa on fa.auf_id = lam.order_pos_auf_id
       left join isi_order_pos pos on pos.auf_id = lam.order_pos_auf_id
group by pos.li_nr,fa.leitzahl, t.res_name_list, t.lgr_platz, t.lgr_platz_gruppe, t.anz_transporte_frei, t.anz_lam_order_res_trans_frei, t.anz_lam_order_res_trans_neu, t.anz_lam_order_res_trans_st_t,
t.lgr_akt_te, t.max_transporte
order by t.lgr_platz_gruppe, t.lgr_platz
;


-- sqlcl_snapshot {"hash":"f8c513fe1f6b26351e5ec0494e4c407e2aad1e15","type":"VIEW","name":"LVS_TRANS_UND_ZIEL_CHK2","schemaName":"DIRKSPZM32","sxml":""}