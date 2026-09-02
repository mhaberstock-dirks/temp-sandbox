
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BUI" 
  before insert or update on PZM_ZE_LOA_STATISTIK_EXP_HOST
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
  else
    if :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
  end if;
end;



/
ALTER TRIGGER "TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"cc5246984a8e2b26a109fc686bca19f38c1c6dd8","type":"TRIGGER","name":"TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BUI","schemaName":"DIRKSPZM32","sxml":""}