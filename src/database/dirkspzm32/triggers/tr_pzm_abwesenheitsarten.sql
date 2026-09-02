
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ABWESENHEITSARTEN" 
  before insert on PZM_ABWESENHEITSARTEN
for each row
declare
  -- local variables here
begin
  if :new.AA_ID is NULL then
     select seq_aa_id.nextval into :new.AA_ID from dual;
  end if;
end;


/
ALTER TRIGGER "TR_PZM_ABWESENHEITSARTEN" ENABLE;


-- sqlcl_snapshot {"hash":"fd5a4071bc8e18121837e83b505e1b2f7c5808d7","type":"TRIGGER","name":"TR_PZM_ABWESENHEITSARTEN","schemaName":"DIRKSPZM32","sxml":""}