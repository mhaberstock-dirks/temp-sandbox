
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_LZ_TARIFMODELLE_BUI" 
  before insert or update on DIRKSPZM32.PZM_LZ_TARIFMODELLE
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
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_LZ_TARIFMODELLE_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"38e1063991b51b017b181aa2b07eaca6a031e347","type":"TRIGGER","name":"TR_PZM_LZ_TARIFMODELLE_BUI","schemaName":"DIRKSPZM32","sxml":""}