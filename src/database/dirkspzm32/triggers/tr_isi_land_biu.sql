
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_LAND_BIU" 
  before insert or update on DIRKSPZM32.ISI_LAND
  for each row
declare

  -- local variables here
begin
  if inserting
  then
    if :new.created_date is NULL
    then
      :new.created_date := sysdate;
    end if;
    if :new.created_login_id is NULL
    then
      :new.created_login_id := current_isi_user_login_id();
    end if;
  end if;
  if updating
  then
    if :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    if :new.last_change_login_id is NULL
    then
      :new.last_change_login_id := current_isi_user_login_id();
    end if;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_LAND_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"2be37c6e219a15b5bd43e9e02ca044a52b0fa6aa","type":"TRIGGER","name":"TR_ISI_LAND_BIU","schemaName":"DIRKSPZM32","sxml":""}