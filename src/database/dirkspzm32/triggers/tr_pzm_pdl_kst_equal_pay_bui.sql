
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_PDL_KST_EQUAL_PAY_BUI" 
  before insert or update on PZM_PDL_KST_EQUAL_PAY
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
    if :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
    :new.last_change_user := current_isi_user();
  end if;

end;




/
ALTER TRIGGER "TR_PZM_PDL_KST_EQUAL_PAY_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"4302a621ca6c94f6dc5c1ac7f98b18672430cba4","type":"TRIGGER","name":"TR_PZM_PDL_KST_EQUAL_PAY_BUI","schemaName":"DIRKSPZM32","sxml":""}