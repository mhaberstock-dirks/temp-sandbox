
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."BDE_V_PD_LAM_STL_DATEN" ("SID", "FIRMA_NR", "PD_LAM_STL_DATEN_ID", "FERT_LAM_ID", "FA_NR", "FA_AG", "FA_UPOS", "FA_AG_STL_ID", "STL_LAM_ID", "STL_LAM_AB_MENGE", "STL_LAM_IST_MENGE", "STATUS", "AEND_DATUM", "AEND_LOGIN_ID", "RES_ID", "RES_STATUS_ID", "RESULT_PARAMS", "RES_NAME", "FE_ARTIKEL_ID", "FE_ARTIKEL", "FE_ZEICHNUNG", "FE_ZINDEX", "MA_ARTIKEL_ID", "MA_ART_GRUPPE_ID", "MA_ARTIKEL", "MA_ZEICHNUNG", "MA_ZINDEX", "MA_ART_GRUPPE", "MA_PROD_PARAMS", "PROD_MENGE_IX", "FA_SATZART", "FA_AG_BEZ1", "FA_AG_BEZ2") AS 
  select t."SID",t."FIRMA_NR",t."PD_LAM_STL_DATEN_ID",t."FERT_LAM_ID",t."FA_NR",t."FA_AG",t."FA_UPOS",t."FA_AG_STL_ID",t."STL_LAM_ID",t."STL_LAM_AB_MENGE",t."STL_LAM_IST_MENGE",t."STATUS",t."AEND_DATUM",t."AEND_LOGIN_ID",t."RES_ID",t."RES_STATUS_ID",t."RESULT_PARAMS",
       r.res_name,
       lam.artikel_id fe_artikel_id,
       fea.artikel fe_artikel,
       lam.zeichnung fe_zeichnung,
       lam.zeichnung_index fe_zindex,
       maa.artikel_id ma_artikel_id,
       maa.art_gruppe_id ma_art_gruppe_id,
       maa.artikel  ma_artikel,
       ma.zeichnung ma_zeichnung,
       ma.zeichnung_index ma_zindex,
       maag.art_gruppe ma_art_gruppe,
       ma.prod_params ma_prod_params,
       stl.prod_menge_ix,
       fa.satzart fa_satzart,
       fa.ag_bez1 fa_ag_bez1,
       fa.ag_bez2 fa_ag_bez2
  from bde_pd_lam_stl_daten t,
       bde_fa_auftrag fa,
       bde_fa_auftrag_stl stl,
       bde_fa_auftrag ma,
       isi_artikel maa,
       isi_artikel_gruppe maag,
       lvs_lam lam,
       isi_artikel fea,
       isi_resource r
 where stl.fa_ag_stl_id(+) = t.fa_ag_stl_id
   and fa.sid = t.sid
   and fa.firma_nr = t.firma_nr
   and fa.leitzahl = t.fa_nr
   and fa.fa_ag = t.fa_ag
   and fa.fa_upos = t.fa_upos
   and ma.sid(+) = stl.sid
   and ma.firma_nr(+) = stl.firma_nr
   and ma.leitzahl(+) = stl.leitzahl
   and ma.fa_ag(+) = stl.ma_fa_ag
   and ma.fa_upos(+) = stl.ma_fa_upos
   and maa.sid(+) = ma.sid
   and maa.artikel_id(+) = ma.ag_artikel_id
   and maag.sid(+) = maa.sid
   and maag.art_gruppe_id(+) = maa.art_gruppe_id
   and lam.sid = t.sid
   and lam.firma_nr = t.firma_nr
   and lam.lam_id = t.fert_lam_id
   and fea.sid = lam.sid
   and fea.artikel_id = lam.artikel_id
   and r.sid(+) = t.sid
   and r.firma_nr(+) = t.firma_nr
   and r.res_id(+) = t.res_id
;


-- sqlcl_snapshot {"hash":"b6aaba3f234fee7baa0262a0c2f6729f702e90bf","type":"VIEW","name":"BDE_V_PD_LAM_STL_DATEN","schemaName":"DIRKSPZM32","sxml":""}