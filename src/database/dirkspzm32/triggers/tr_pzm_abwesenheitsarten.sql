
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ABWESENHEITSARTEN" 
  before insert on DIRKSPZM32.PZM_ABWESENHEITSARTEN
for each row
declare
  -- local variables here
begin
  if :new.AA_ID is NULL then
     select seq_aa_id.nextval into :new.AA_ID from dual;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ABWESENHEITSARTEN" ENABLE;


-- sqlcl_snapshot {"hash":"c26ae203150413e1a5c449ae6414de7f571a72ec","type":"TRIGGER","name":"TR_PZM_ABWESENHEITSARTEN","schemaName":"DIRKSPZM32","sxml":""}