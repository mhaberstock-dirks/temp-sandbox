
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_FA_AUFTRAG_STL_BI" 
  before insert on DIRKSPZM32.bde_fa_auftrag_stl
  for each row
declare
  -- local variables here
begin
  if :new.fa_ag_stl_id is null
  then
    select seq_fa_ag_stl_id.nextval into :new.fa_ag_stl_id from dual;
  end if;
end TR_BDE_FA_AUFTRAG_STL_BI;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_FA_AUFTRAG_STL_BI" ENABLE;


-- sqlcl_snapshot {"hash":"54765ba0b7bfc6a6654a77009dd8a36beee5a6f8","type":"TRIGGER","name":"TR_BDE_FA_AUFTRAG_STL_BI","schemaName":"DIRKSPZM32","sxml":""}