
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_HERSTELLER_BIU" 
  before insert or update on ISI_HERSTELLER
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
ALTER TRIGGER "TR_ISI_HERSTELLER_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"893aa9210884499c372214969e6c127fdd350b65","type":"TRIGGER","name":"TR_ISI_HERSTELLER_BIU","schemaName":"DIRKSPZM32","sxml":""}