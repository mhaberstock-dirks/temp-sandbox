
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_LAND_REGION_BIU" 
  before insert or update on ISI_LAND_REGION
  for each row
declare

  -- local variables here
begin
  if :new.region_id is NULL
  then
    select SEQ_ISI_LAND_REGION.NEXTVAL into :new.region_id from dual;
  end if;
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
ALTER TRIGGER "TR_ISI_LAND_REGION_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"09f4c91817c34f11a80f2d0c4319add4f9ca4388","type":"TRIGGER","name":"TR_ISI_LAND_REGION_BIU","schemaName":"DIRKSPZM32","sxml":""}