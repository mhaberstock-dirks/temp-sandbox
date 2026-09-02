
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ZEITERFASSUNG_EINTRAEGE_BIUD" 
  before insert or update or delete on PZM_ZEITERFASSUNG_EINTRAEGE
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
ALTER TRIGGER "TR_PZM_ZEITERFASSUNG_EINTRAEGE_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"eeff899e622fa7fad87c594662dfe3b261b99262","type":"TRIGGER","name":"TR_PZM_ZEITERFASSUNG_EINTRAEGE_BIUD","schemaName":"DIRKSPZM32","sxml":""}