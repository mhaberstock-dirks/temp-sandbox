
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RES_PRUEF_PLAN_DATA_BI" 
  before insert on DIRKSPZM32.ISI_RES_PRUEF_PLAN_DATA
  for each row
declare
  -- local variables here
begin
  if :new.id is NULL
  then
    select SEQ_ISI_RES_PRUEF_PLAN_DATA.Nextval into :new.id from dual;
  end if;
  if :new.created_date is NULL
  then
    :new.created_date := sysdate;
  end if;
  if :new.created_login_id is NULL
  then
    :new.created_login_id := -1;
  end if;
end tr_ISI_RES_PRUEF_PLAN_DATA_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RES_PRUEF_PLAN_DATA_BI" ENABLE;


-- sqlcl_snapshot {"hash":"ba2da39fd0dccba2b8bdc4acde703bb666ef5ea0","type":"TRIGGER","name":"TR_ISI_RES_PRUEF_PLAN_DATA_BI","schemaName":"DIRKSPZM32","sxml":""}