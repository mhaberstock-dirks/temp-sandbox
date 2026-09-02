
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_LAND_BIU" 
  before insert or update on ISI_LAND
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
ALTER TRIGGER "TR_ISI_LAND_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"36cb871d29cb209bf78590decd10e2389d411b7e","type":"TRIGGER","name":"TR_ISI_LAND_BIU","schemaName":"DIRKSPZM32","sxml":""}