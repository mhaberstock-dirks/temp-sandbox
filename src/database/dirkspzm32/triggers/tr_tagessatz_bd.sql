
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_TAGESSATZ_BD" 
  before delete on DIRKSPZM32.pzm_ze_tagessatz
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
ALTER TRIGGER "DIRKSPZM32"."TR_TAGESSATZ_BD" ENABLE;


-- sqlcl_snapshot {"hash":"107d044590335f56b231d0d4467b8e98157bed04","type":"TRIGGER","name":"TR_TAGESSATZ_BD","schemaName":"DIRKSPZM32","sxml":""}