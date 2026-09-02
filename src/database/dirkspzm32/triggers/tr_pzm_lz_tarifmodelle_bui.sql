
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_LZ_TARIFMODELLE_BUI" 
  before insert or update on PZM_LZ_TARIFMODELLE
  for each row
declare
begin

  if inserting
  then
    if :new.created_date is NULL
    then
      :new.created_date := sysdate;
    end if;
    :new.created_login_id := nvl(current_isi_user_login_id(), -1);
    --:new.created_user := current_isi_user();
  else
    if :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
    --:new.last_change_user := current_isi_user();
  end if;


end;


/
ALTER TRIGGER "TR_PZM_LZ_TARIFMODELLE_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"b185e5905c2b7c2196620e4fa10659e6cbb8adf9","type":"TRIGGER","name":"TR_PZM_LZ_TARIFMODELLE_BUI","schemaName":"DIRKSPZM32","sxml":""}