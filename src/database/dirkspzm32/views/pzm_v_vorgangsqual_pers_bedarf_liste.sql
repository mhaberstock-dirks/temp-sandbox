
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_VORGANGSQUAL_PERS_BEDARF_LISTE" ("ABT_L_PERS_NR", "VQ_ID", "VQ_BEZEICHNUNG", "VQ_ABT_ID", "ABT_NAME", "SCHICHT_NR", "ZEITEN", "PERS_BEDARF_MO", "PERS_BEDARF_DI", "PERS_BEDARF_MI", "PERS_BEDARF_DO", "PERS_BEDARF_FR", "PERS_BEDARF_SA", "PERS_BEDARF_SO", "PERS_NR_VORSCHL") AS 
  select abt_l.abt_l_pers_nr,
       vq.vq_id,
       vq.vq_bezeichnung,
       vq.vq_abt_id,
       abt.abt_name,
       vqb.schicht_nr,
       to_char(vqb.schicht_von, 'hh24:mi') || ' - ' || to_char(vqb.schicht_bis, 'hh24:mi') Zeiten,
       max(vqb.pers_bedarf_mo) pers_bedarf_mo,
       max(vqb.pers_bedarf_di) pers_bedarf_di,
       max(vqb.pers_bedarf_mi) pers_bedarf_mi,
       max(vqb.pers_bedarf_do) pers_bedarf_do,
       max(vqb.pers_bedarf_fr) pers_bedarf_fr,
       max(vqb.pers_bedarf_sa) pers_bedarf_sa,
       max(vqb.pers_bedarf_so) pers_bedarf_so,
       (select stradd_distinct(vqp.pers_nr) from pzm_vorgangsqualifikation_pers vqp where vqp.pers_vq_id = vq.vq_id) pers_nr_vorschl
  from pzm_vorgangsqualifikation vq,
       pzm_vorgangsqualifikation_pers_bedarf vqb,
       pzm_abteilungen abt,
       pzm_abt_leitung abt_l
 where vq.vq_id = vqb.vq_id(+)
   and vq.vq_abt_id = abt.abt_id(+)
   and vq.vq_abt_id = abt_l.abt_l_abt_id(+)
 group by vq.vq_id,
          vq.vq_bezeichnung,
          vq.vq_abt_id,
          vqb.schicht_nr,
          vqb.schicht_von,
          vqb.schicht_bis,
          abt.abt_name,
          abt_l.abt_l_pers_nr
 order by nvl(vq.vq_abt_id, 0),
          vq.vq_id,
          nvl(vqb.schicht_nr, 0),
          vqb.schicht_von
;


-- sqlcl_snapshot {"hash":"f8984e12e2674c199a8c76f564997f56ae68f972","type":"VIEW","name":"PZM_V_VORGANGSQUAL_PERS_BEDARF_LISTE","schemaName":"DIRKSPZM32","sxml":""}