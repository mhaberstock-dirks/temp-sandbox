
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZE_AZK_URLAUB_BUI" 
  before insert or update on DIRKSPZM32.PZM_ZE_AZK_URLAUB
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
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZE_AZK_URLAUB_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"77c91ef03b4e423aaa04af6ff5d36ae9a0202b2c","type":"TRIGGER","name":"TR_PZM_ZE_AZK_URLAUB_BUI","schemaName":"DIRKSPZM32","sxml":""}