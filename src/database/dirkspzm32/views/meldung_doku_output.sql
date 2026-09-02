
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "MELDUNG_DOKU_OUTPUT" ("NR", "LIEFERANT", "NAME", "DETAILS", "POS_NR") AS 
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


-- sqlcl_snapshot {"hash":"8cc60f2847b0724277a68d8d5a0de7c4fa96331e","type":"VIEW","name":"MELDUNG_DOKU_OUTPUT","schemaName":"DIRKSPZM32","sxml":""}