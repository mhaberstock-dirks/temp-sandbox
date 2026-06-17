
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PPS_V_ARTIKEL_STL" ("ARTIKEL_ID", "ARTIKEL", "STL_ARTIKEL_ID", "STL_ARTIKEL", "STUECKLISTE_POS_ID", "PROD_MENGE_P_EINHEIT", "PROD_MENGE_P_EINHEIT_OP") AS 
  select art.artikel_id,
       art.artikel,
       art_stl.artikel_id stl_artikel_id,
       art_stl.artikel stl_artikel,
       p_art_stl.stueckliste_pos_id,
       p_ag_stl.prod_menge_p_einheit,
       p_ag_stl.prod_menge_p_einheit_op
  from isi_artikel art,
       pps_artikel_arb_plan p_art_ap,
       pps_arb_plan_ag p_ag,
       pps_arb_plan_ag_stl p_ag_stl,
       pps_stueckliste_pos p_art_stl,
       isi_artikel art_stl
 where art.artikel_id = p_art_ap.artikel_id
   and p_art_ap.arb_plan_id = p_ag.arb_plan_id
   and p_ag.arb_plan_pos_id = p_ag_stl.arb_plan_pos_id
   and p_ag.ag_alternative = 0
   and p_art_stl.stueckliste_pos_id = p_ag_stl.stueckliste_pos_id
   and p_art_stl.artikel_id = art_stl.artikel_id(+)
;


-- sqlcl_snapshot {"hash":"825a87c4a7fd15252e2d729fda5e7be09507b779","type":"VIEW","name":"PPS_V_ARTIKEL_STL","schemaName":"DIRKSPZM32","sxml":""}