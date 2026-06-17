
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_EXP_EXT_GUTSCH_BUI" 
  before insert or update on DIRKSPZM32.PZM_ZE_LOA_EXP_EXT_GUTSCH
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
    :new.last_change_date := sysdate;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
    :new.last_change_user := current_isi_user();
  end if;

end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_EXP_EXT_GUTSCH_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"318d23d2e31fca5ded2aae5339452aef15126b2f","type":"TRIGGER","name":"TR_PZM_ZE_LOA_EXP_EXT_GUTSCH_BUI","schemaName":"DIRKSPZM32","sxml":""}