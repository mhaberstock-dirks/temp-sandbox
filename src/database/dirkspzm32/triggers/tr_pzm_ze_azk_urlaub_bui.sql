
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ZE_AZK_URLAUB_BUI" 
  before insert or update on PZM_ZE_AZK_URLAUB
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
    :new.created_user := current_isi_user();
  else
    if :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
    :new.last_change_user := current_isi_user();
  end if;
end;



/
ALTER TRIGGER "TR_PZM_ZE_AZK_URLAUB_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"4333d36b19a0bd71a9dbd78c84d47b5e50331ab0","type":"TRIGGER","name":"TR_PZM_ZE_AZK_URLAUB_BUI","schemaName":"DIRKSPZM32","sxml":""}