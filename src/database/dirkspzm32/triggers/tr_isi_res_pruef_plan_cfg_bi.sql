
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RES_PRUEF_PLAN_CFG_BI" 
  before insert on DIRKSPZM32.ISI_RES_PRUEF_PLAN_DATA_CFG
  for each row
declare
  -- local variables here
begin
  if :new.id is NULL
  or :new.id = 0
  then
    select SEQ_ISI_RES_PRUEF_P_DATA_CFG.Nextval into :new.id from dual;
  end if;
  if :new.created_date is NULL
  then
    :new.created_date := sysdate;
  end if;
  if :new.created_login_id is NULL
  then
    :new.created_login_id := -1;
  end if;
end tr_ISI_RES_PRUEF_PLAN_CFG_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RES_PRUEF_PLAN_CFG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"408a29a650f4ecd6b04491ac40e2ffb3b9b6009d","type":"TRIGGER","name":"TR_ISI_RES_PRUEF_PLAN_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}