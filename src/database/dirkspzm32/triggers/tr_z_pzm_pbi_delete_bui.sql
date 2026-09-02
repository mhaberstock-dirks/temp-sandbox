
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_Z_PZM_PBI_DELETE_BUI" 
  before insert or update on Z_PZM_PBI_DELETE
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
ALTER TRIGGER "TR_Z_PZM_PBI_DELETE_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"d64839f84e840c5f5a95470e416516ece7998130","type":"TRIGGER","name":"TR_Z_PZM_PBI_DELETE_BUI","schemaName":"DIRKSPZM32","sxml":""}