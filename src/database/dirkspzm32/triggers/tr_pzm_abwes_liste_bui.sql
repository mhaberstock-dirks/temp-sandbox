
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ABWES_LISTE_BUI" 
  before insert or update on PZM_ABWES_LISTE
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
ALTER TRIGGER "TR_PZM_ABWES_LISTE_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"226a482ae905f17e00433d36aad645b7f550fb4f","type":"TRIGGER","name":"TR_PZM_ABWES_LISTE_BUI","schemaName":"DIRKSPZM32","sxml":""}