
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."BDE_V_FA_AUFTRAG_WARE" ("SID", "FIRMA_NR", "LEITZAHL", "FA_AG", "AG_IST_MG", "AG_IST_MG_B", "AG_IST_MG_SCHROTT", "AG_IST_MG_RUESTEN", "GUTWARE") AS 
  select t."SID",
       t."FIRMA_NR",
       t."LEITZAHL",
       t."FA_AG",
       t."AG_IST_MG",
       t."AG_IST_MG_B",
       t."AG_IST_MG_SCHROTT",
       t."AG_IST_MG_RUESTEN",
       t.ag_ist_mg - (t.ag_ist_mg_b + t.ag_ist_mg_schrott + t.ag_ist_mg_ruesten) as gutware
from bde_fa_auftrag t
;


-- sqlcl_snapshot {"hash":"8010a87ea5d5595f977065646f205fe5d4bf4413","type":"VIEW","name":"BDE_V_FA_AUFTRAG_WARE","schemaName":"DIRKSPZM32","sxml":""}