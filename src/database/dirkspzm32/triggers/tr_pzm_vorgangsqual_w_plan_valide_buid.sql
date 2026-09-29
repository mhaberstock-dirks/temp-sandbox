
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_VORGANGSQUAL_W_PLAN_VALIDE_BUID" 
  before update or insert or delete
  on PZM_VORGANGSQUAL_W_PLAN_VALIDE 
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    select SEQ_PZM_W_PLAN_VALID_ID.Nextval into :new.w_plan_valid_id from dual;
  end if;
  if updating 
  then
    :new.last_change_date := sysdate;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
  end if;

end;
/
ALTER TRIGGER "TR_PZM_VORGANGSQUAL_W_PLAN_VALIDE_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"99ed4a90d89f05561e6b753869a1fba91de53b3c","type":"TRIGGER","name":"TR_PZM_VORGANGSQUAL_W_PLAN_VALIDE_BUID","schemaName":"DIRKSPZM32","sxml":""}