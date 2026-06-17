
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ABWES_LISTE_BUI" 
  before insert or update on DIRKSPZM32.PZM_ABWES_LISTE
  for each row
declare
begin

  if inserting
  then
    if :new.created_date is NULL
    then
      :new.created_date := sysdate;
    end if;
    :new.created_user := current_isi_user();
  else
    if :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    :new.last_change_user := current_isi_user();
  end if;


end;


/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ABWES_LISTE_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"ae23dd70da3f5ac09a278588ed0eec0c3ba845ca","type":"TRIGGER","name":"TR_PZM_ABWES_LISTE_BUI","schemaName":"DIRKSPZM32","sxml":""}