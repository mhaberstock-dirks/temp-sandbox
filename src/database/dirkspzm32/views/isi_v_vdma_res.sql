
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."ISI_V_VDMA_RES" ("RES_EXT_NAME", "RES_NAME", "TEXT", "RES_ID", "PROD_STD", "HNZ", "BLZ", "BAZ", "PBZ", "TRZ", "PM", "GM", "AM", "PEZ", "XX") AS 
  select r.res_ext_name,
         r.res_name,
         r.text,
         r.res_id,
         bde_funktionen.get_res_prod_std(r.res_id, bde_funktionen.get_ausw_begin, bde_funktionen.get_ausw_ende)  prod_std,
         bde_funktionen.get_res_hnz_std hnz,
         bde_funktionen.get_res_hnz_std + bde_funktionen.get_res_ruest_std + bde_funktionen.get_res_su_std blz,
         bde_funktionen.get_res_hnz_std + bde_funktionen.get_res_ruest_std baz,
         bde_funktionen.get_anmelde_std(r.sid, r.firma_nr, (bde_funktionen.get_ausw_begin), (bde_funktionen.get_ausw_ende), r.res_id) pbz,
         bde_funktionen.get_res_ruest_std trz,
         sum(pd.menge_a) + sum(pd.menge_b) + sum(pd.schrott) pm,
         sum(pd.menge_a) gm,
         sum(pd.menge_b) + sum(pd.schrott) am,
         max(rl_pez_sek.param_menge) / 3600 pez,
         bde_funktionen.get_res_ruest_std xx
    from isi_resource r,
         isi_res_leistung_cfg rl_pez_sek,
         bde_pd_prod pd
   where r.typ = 'MS'
     and r.res_id = pd.res_id
     and r.res_id = rl_pez_sek.res_id(+)
     and rl_pez_sek.param_name(+) = 'PEZ_SEK'
     and pd.vorg_typ  = 'PA'
     and pd.prod_ende >= bde_funktionen.get_ausw_begin()
     and pd.prod_ende <= bde_funktionen.get_ausw_ende()
   group by
         r.res_ext_name,
         r.res_name,
         r.sid,
         r.firma_nr,
         r.text,
         r.res_id
;


-- sqlcl_snapshot {"hash":"bc5c724e07de871b73d45c5746fa75557530baf7","type":"VIEW","name":"ISI_V_VDMA_RES","schemaName":"DIRKSPZM32","sxml":""}