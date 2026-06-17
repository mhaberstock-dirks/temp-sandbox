
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PPS_V_STL" ("ARTIKEL", "STL_ARTIKEL", "STUECKLISTE_POS_ID", "PROD_MENGE_P_EINHEIT", "PROD_MENGE_P_EINHEIT_OP") AS 
  select art.artikel,
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
   and p_art_stl.stueckliste_pos_id = p_ag_stl.stueckliste_pos_id
   and p_art_stl.artikel_id = art_stl.artikel_id(+)
;


-- sqlcl_snapshot {"hash":"d143d6081b63797f34411e1f10c0df33d6162e70","type":"VIEW","name":"PPS_V_STL","schemaName":"DIRKSPZM32","sxml":""}