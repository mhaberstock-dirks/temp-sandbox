
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZEITERFASSUNG_EINTRAEGE_BIUD" 
  before insert or update or delete on DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE
  for each row
declare

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
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZEITERFASSUNG_EINTRAEGE_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"c25ade958f8cd50563fd23e02dc61b36285654e2","type":"TRIGGER","name":"TR_PZM_ZEITERFASSUNG_EINTRAEGE_BIUD","schemaName":"DIRKSPZM32","sxml":""}