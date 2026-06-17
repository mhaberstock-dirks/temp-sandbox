
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_BEREITSCHAFT_PLAN_BUI" 
  before insert or update on DIRKSPZM32.pzm_bereitschaft_plan
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
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_BEREITSCHAFT_PLAN_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"0397714329b81c371159dfc3901961d6ba5593e1","type":"TRIGGER","name":"TR_PZM_BEREITSCHAFT_PLAN_BUI","schemaName":"DIRKSPZM32","sxml":""}