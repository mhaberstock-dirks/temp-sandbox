
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."LVS_V_LAM_BH_LAM" ("SID", "FIRMA_NR", "VORG_ID", "VORG_TYP", "LAM_BH_ID", "LAM_ID", "ARTIKEL_ID", "BUS", "BUCH_DATUM", "LS_LOGIN_ID", "LGR_PLATZ", "LTE_ID", "LHM_ID", "CHARGE_ID", "SERIE_ID", "ABNR", "MENGE", "LAM_BH_KG", "LAM_BH_KG_EINHEIT", "RES_ID", "LEITZAHL", "FA_AG", "FA_UPOS", "ABNR_EXTERN", "VORGANG_ID", "LAM_CHARGE_ID", "LAM_SERIE_ID", "LAM_LEITZAHL", "LAM_FA_AG", "LAM_FA_UPOS", "LAM_ABNR", "LAM_BEST_NR", "LAM_BEST_POS", "LAM_RES_ID", "LAM_PROD_DATUM", "LAM_ZUG_DATUM", "LAM_LS_LOGIN_ID", "LAM_MENGE", "LAM_LAM_KG", "LAM_LAM_TEXT", "LAM_LABOR_STATUS", "LAM_LABOR_TEXT", "LAM_LAM_MHD", "LAM_KUNDEN_NR", "LAM_KD_ART_NR", "LAM_LIEFERANT_NR", "LAM_LAM_MHD_AUSGABE", "LAM_MENGE_BASIS", "LAM_MENGENEINHEIT_BASIS", "LAM_ORDER_POS_AUF_ID", "LAM_ZEICHNUNG", "LAM_ZEICHNUNG_INDEX", "LAM_LI_NR_LIEF", "LAM_LTE_ID_LIEFERANT", "LAM_SONST_ID_LIEFERANT") AS 
  select lam_bh."SID",lam_bh."FIRMA_NR",lam_bh."VORG_ID",lam_bh."VORG_TYP",lam_bh."LAM_BH_ID",lam_bh."LAM_ID",lam_bh."ARTIKEL_ID",lam_bh."BUS",lam_bh."BUCH_DATUM",lam_bh."LS_LOGIN_ID",lam_bh."LGR_PLATZ",lam_bh."LTE_ID",lam_bh."LHM_ID",lam_bh."CHARGE_ID",lam_bh."SERIE_ID",lam_bh."ABNR",lam_bh."MENGE",lam_bh."LAM_BH_KG",lam_bh."LAM_BH_KG_EINHEIT",lam_bh."RES_ID",lam_bh."LEITZAHL",lam_bh."FA_AG",lam_bh."FA_UPOS",lam_bh."ABNR_EXTERN",lam_bh."VORGANG_ID",
       lam.charge_id           lam_charge_id,
       lam.serie_id            lam_serie_id,
       lam.leitzahl            lam_leitzahl,
       lam.fa_ag               lam_fa_ag,
       lam.fa_upos             lam_fa_upos,
       lam.abnr                lam_abnr,
       lam.best_nr             lam_best_nr ,
       lam.best_pos            lam_best_pos,
       lam.res_id              lam_res_id,
       lam.prod_datum          lam_prod_datum,
       lam.zug_datum           lam_zug_datum,
       lam.ls_login_id         lam_ls_login_id,
       lam.menge               lam_menge,
       lam.lam_kg              lam_lam_kg,
       lam.lam_text            lam_lam_text,
       lam.labor_status        lam_labor_status,
       lam.labor_text          lam_labor_text,
       lam.lam_mhd             lam_lam_mhd,
       lam.kunden_nr           lam_kunden_nr,
       lam.kd_art_nr           lam_kd_art_nr,
       lam.lieferant_nr        lam_lieferant_nr,
       lam.lam_mhd_ausgabe     lam_lam_mhd_ausgabe,
       lam.menge_basis         lam_menge_basis,
       lam.mengeneinheit_basis lam_mengeneinheit_basis,
       lam.order_pos_auf_id    lam_order_pos_auf_id,
       lam.zeichnung           lam_zeichnung,
       lam.zeichnung_index     lam_zeichnung_index,
       lam.li_nr_lief          lam_li_nr_lief,
       lam.lte_id_lieferant    lam_lte_id_lieferant,
       lam.sonst_id_lieferant  lam_sonst_id_lieferant
  from lvs_lam_bh lam_bh,
       lvs_lam lam
 where lam_bh.sid = lam.sid
   and lam_bh.firma_nr = lam.firma_nr
   and lam_bh.lam_id = lam.lam_id
union
select lam_bh_hist."SID",lam_bh_hist."FIRMA_NR",lam_bh_hist."VORG_ID",lam_bh_hist."VORG_TYP",lam_bh_hist."LAM_BH_ID",lam_bh_hist."LAM_ID",lam_bh_hist."ARTIKEL_ID",lam_bh_hist."BUS",lam_bh_hist."BUCH_DATUM",lam_bh_hist."LS_LOGIN_ID",lam_bh_hist."LGR_PLATZ",lam_bh_hist."LTE_ID",lam_bh_hist."LHM_ID",lam_bh_hist."CHARGE_ID",lam_bh_hist."SERIE_ID",lam_bh_hist."ABNR",lam_bh_hist."MENGE",lam_bh_hist."LAM_BH_KG",lam_bh_hist."LAM_BH_KG_EINHEIT",lam_bh_hist."RES_ID",lam_bh_hist."LEITZAHL",lam_bh_hist."FA_AG",lam_bh_hist."FA_UPOS",lam_bh_hist."ABNR_EXTERN",lam_bh_hist."VORGANG_ID",
       lam_hist.charge_id           lam_charge_id,
       lam_hist.serie_id            lam_serie_id,
       lam_hist.leitzahl            lam_leitzahl,
       lam_hist.fa_ag               lam_fa_ag,
       lam_hist.fa_upos             lam_fa_upos,
       lam_hist.abnr                lam_abnr,
       lam_hist.best_nr             lam_best_nr ,
       lam_hist.best_pos            lam_best_pos,
       lam_hist.res_id              lam_res_id,
       lam_hist.prod_datum          lam_prod_datum,
       lam_hist.zug_datum           lam_zug_datum,
       lam_hist.ls_login_id         lam_ls_login_id,
       lam_hist.menge               lam_menge,
       lam_hist.lam_kg              lam_lam_kg,
       lam_hist.lam_text            lam_lam_text,
       lam_hist.labor_status        lam_labor_status,
       lam_hist.labor_text          lam_labor_text,
       lam_hist.lam_mhd             lam_lam_mhd,
       lam_hist.kunden_nr           lam_kunden_nr,
       lam_hist.kd_art_nr           lam_kd_art_nr,
       lam_hist.lieferant_nr        lam_lieferant_nr,
       lam_hist.lam_mhd_ausgabe     lam_lam_mhd_ausgabe,
       lam_hist.menge_basis         lam_menge_basis,
       lam_hist.mengeneinheit_basis lam_mengeneinheit_basis,
       lam_hist.order_pos_auf_id    lam_order_pos_auf_id,
       lam_hist.zeichnung           lam_zeichnung,
       lam_hist.zeichnung_index     lam_zeichnung_index,
       lam_hist.li_nr_lief          lam_li_nr_lief,
       lam_hist.lte_id_lieferant    lam_lte_id_lieferant,
       lam_hist.sonst_id_lieferant  lam_sonst_id_lieferant
  from lvs_lam_bh_hist lam_bh_hist,
       lvs_lam lam_hist
 where lam_bh_hist.sid = lam_hist.sid
   and lam_bh_hist.firma_nr = lam_hist.firma_nr
   and lam_bh_hist.lam_id = lam_hist.lam_id
;


-- sqlcl_snapshot {"hash":"fa5b9fdc9a65872a37d803cc85c37744312e4b47","type":"VIEW","name":"LVS_V_LAM_BH_LAM","schemaName":"DIRKSPZM32","sxml":""}