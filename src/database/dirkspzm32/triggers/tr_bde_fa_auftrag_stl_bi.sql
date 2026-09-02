
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_BDE_FA_AUFTRAG_STL_BI" 
  before insert on bde_fa_auftrag_stl
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
ALTER TRIGGER "TR_BDE_FA_AUFTRAG_STL_BI" ENABLE;


-- sqlcl_snapshot {"hash":"71d84dee922abd3270e5ebcaeda5c8aff1a23a9f","type":"TRIGGER","name":"TR_BDE_FA_AUFTRAG_STL_BI","schemaName":"DIRKSPZM32","sxml":""}