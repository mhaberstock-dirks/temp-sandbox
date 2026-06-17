
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."MELDUNG_DOKU_OUTPUT" ("NR", "LIEFERANT", "NAME", "DETAILS", "POS_NR") AS 
  select t.nr,
         t.lieferant,
         t.name,
         t.details,
         stradd_distinct (e.pos_nr) pos_nr
    from meldung_cfg t,
         mfr_element_cfg e
   where e.telegr_sps_bereich_nr(+) = t.nr
  group by t.nr,
           t.lieferant,
           t.name,
           t.details
  order by t.nr
;


-- sqlcl_snapshot {"hash":"eae38bc6331c42f649d435083ed23761977cfb7c","type":"VIEW","name":"MELDUNG_DOKU_OUTPUT","schemaName":"DIRKSPZM32","sxml":""}