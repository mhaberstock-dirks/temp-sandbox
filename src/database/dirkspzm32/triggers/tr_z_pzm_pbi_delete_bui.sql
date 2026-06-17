
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_Z_PZM_PBI_DELETE_BUI" 
  before insert or update on DIRKSPZM32.Z_PZM_PBI_DELETE
  for each row
declare
begin

  if inserting
  then
    if :new.pers_nr >= 80000
    and :new.pers_nr <= 89999
    then
      :new.status := 'I';      
    end if;
  end if;


end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_Z_PZM_PBI_DELETE_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"ddf5e71ecc6bcc2140e1ec36abb5c680dc288b6f","type":"TRIGGER","name":"TR_Z_PZM_PBI_DELETE_BUI","schemaName":"DIRKSPZM32","sxml":""}