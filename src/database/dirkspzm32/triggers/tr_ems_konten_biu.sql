
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_EMS_KONTEN_BIU" 
  before insert on DIRKSPZM32.ems_konten
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    if :new.ems_konto_nr is null
    then
      select seq_ems_konto_nr.nextval into :new.ems_konto_nr from dual;
    end if;
  end if;
end TR_EMS_KONTEN_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_EMS_KONTEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"7648b5e1ddb6e9d07c8dfc2310830318b7a60219","type":"TRIGGER","name":"TR_EMS_KONTEN_BIU","schemaName":"DIRKSPZM32","sxml":""}