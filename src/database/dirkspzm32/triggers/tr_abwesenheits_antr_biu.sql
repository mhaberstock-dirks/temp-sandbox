
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ABWESENHEITS_ANTR_BIU" 
  before insert or update on "PZM_ABWESENHEITS_ANTR"
  for each row
declare
  -- local variables here
begin
  :new.au_datum := SYSDATE;
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
end TR_ANTR_URLAUB_BIU;


/
ALTER TRIGGER "TR_ABWESENHEITS_ANTR_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"4ca5fe60596ba3600c2b8651a6a389564bdb9634","type":"TRIGGER","name":"TR_ABWESENHEITS_ANTR_BIU","schemaName":"DIRKSPZM32","sxml":""}