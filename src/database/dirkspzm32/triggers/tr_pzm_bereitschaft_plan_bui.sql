
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_BEREITSCHAFT_PLAN_BUI" 
  before insert or update on pzm_bereitschaft_plan
  for each row
declare
begin
  if inserting
  then
    :new.created_date := sysdate;
    :new.created_user := current_isi_user();
    if :new.plan_id is NULL
    then
      select SEQ_PZM_BEREITSCHAFT_PLAN.nextval into :new.plan_id from dual;
    end if;
  else
    :new.last_change_date := sysdate;
    :new.last_change_user := current_isi_user();
  end if;
end;


/
ALTER TRIGGER "TR_PZM_BEREITSCHAFT_PLAN_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"8917c87a617a1aec0977f5f3d0c3bf3014e3822f","type":"TRIGGER","name":"TR_PZM_BEREITSCHAFT_PLAN_BUI","schemaName":"DIRKSPZM32","sxml":""}