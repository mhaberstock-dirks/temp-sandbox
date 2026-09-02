
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_EMS_KONTEN_BIU" 
  before insert on ems_konten
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
ALTER TRIGGER "TR_EMS_KONTEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"9920c6cd554a102a3651f0edc89a4d2d792e829e","type":"TRIGGER","name":"TR_EMS_KONTEN_BIU","schemaName":"DIRKSPZM32","sxml":""}