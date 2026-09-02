
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_TAGESSATZ_BD" 
  before delete on pzm_ze_tagessatz
  for each row
declare
  -- local variables here

begin
  update pzm_ze_loa_ausw t
     set t.aa_id = NULL
   where t.zeaw_pers_nr = :old.ts_pers_nr
     and t.zeaw_datum = :old.ts_datum;

  delete pzm_ze_loa_ausw t
   where t.zeaw_pers_nr = :old.ts_pers_nr
     and t.zeaw_datum = :old.ts_datum;
end;


/
ALTER TRIGGER "TR_TAGESSATZ_BD" ENABLE;


-- sqlcl_snapshot {"hash":"3b4ec79723e2a156f6fc9dc4a7ef91ab38da8183","type":"TRIGGER","name":"TR_TAGESSATZ_BD","schemaName":"DIRKSPZM32","sxml":""}