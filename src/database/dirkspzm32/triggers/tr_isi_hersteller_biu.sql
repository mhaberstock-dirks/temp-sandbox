
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_HERSTELLER_BIU" 
  before insert or update on DIRKSPZM32.ISI_HERSTELLER
for each row
declare
  -- local variables here
begin
  if :new.erstell_datum is NULL
  then
    :new.erstell_datum := sysdate;
  end if;
  if updating
  then
    :new.bearb_datum := sysdate;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_HERSTELLER_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"4b44db0680ebbde73e8937da8b2dfe16b5f6a885","type":"TRIGGER","name":"TR_ISI_HERSTELLER_BIU","schemaName":"DIRKSPZM32","sxml":""}