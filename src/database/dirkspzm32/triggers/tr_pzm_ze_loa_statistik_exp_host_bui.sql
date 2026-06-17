
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BUI" 
  before insert or update on DIRKSPZM32.PZM_ZE_LOA_STATISTIK_EXP_HOST
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
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"453347a16cbe2de8b2ed460360de37f903e3b4aa","type":"TRIGGER","name":"TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BUI","schemaName":"DIRKSPZM32","sxml":""}