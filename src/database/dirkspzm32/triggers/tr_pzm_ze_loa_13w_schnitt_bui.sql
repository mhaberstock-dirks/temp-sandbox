
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ZE_LOA_13W_SCHNITT_BUI" 
  before insert or update on PZM_ZE_LOA_13W_SCHNITT
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
ALTER TRIGGER "TR_PZM_ZE_LOA_13W_SCHNITT_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"538d779a7d2364e225a30172c9a1770cca8618dc","type":"TRIGGER","name":"TR_PZM_ZE_LOA_13W_SCHNITT_BUI","schemaName":"DIRKSPZM32","sxml":""}