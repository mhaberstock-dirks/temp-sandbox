
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_VORGANGSQUAL_PERS_BEDARF_LISTE" ("ABT_L_PERS_NR", "VORGANGSQUALIFIKATION", "VORGANGSQUALIFIKATION_ABT_ID", "ABT_NAME", "SCHICHT_NR", "ZEITEN", "PERS_BEDARF_MO", "PERS_BEDARF_DI", "PERS_BEDARF_MI", "PERS_BEDARF_DO", "PERS_BEDARF_FR", "PERS_BEDARF_SA", "PERS_BEDARF_SO", "PERS_NR_VORSCHL") AS 
  select abt_l.abt_l_pers_nr,
       vq.vorgangsqualifikation,
       vq.vorgangsqualifikation_abt_id,
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
       (select stradd_distinct(vqp.pers_nr) from pzm_vorgangsqualifikation_pers vqp where vqp.pers_vorgangsqualifikation = vq.vorgangsqualifikation) pers_nr_vorschl
  from pzm_vorgangsqualifikation vq,
       pzm_vorgangsqualifikation_pers_bedarf vqb,
       pzm_abteilungen abt,
       pzm_abt_leitung abt_l
 where vq.vorgangsqualifikation = vqb.vorgangsqualifikation(+)
   and vq.vorgangsqualifikation_abt_id = abt.abt_id(+)
   and vq.vorgangsqualifikation_abt_id = abt_l.abt_l_abt_id(+)
 group by vq.vorgangsqualifikation,
          vq.vorgangsqualifikation_abt_id,
          vqb.schicht_nr,
          vqb.schicht_von,
          vqb.schicht_bis,
          abt.abt_name,
          abt_l.abt_l_pers_nr
 order by nvl(vq.vorgangsqualifikation_abt_id, 0),
          vq.vorgangsqualifikation,
          nvl(vqb.schicht_nr, 0),
          vqb.schicht_von
;


-- sqlcl_snapshot {"hash":"73038b1804a89fa4a1586fd8015976b57fdfee60","type":"VIEW","name":"PZM_V_VORGANGSQUAL_PERS_BEDARF_LISTE","schemaName":"DIRKSPZM32","sxml":""}