
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RES_PRUEF_PLAN_CFG_BI" 
  before insert on ISI_RES_PRUEF_PLAN_DATA_CFG
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
ALTER TRIGGER "TR_ISI_RES_PRUEF_PLAN_CFG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"d1b7363cf3ab1c8ee5214fb1697b493d3debaaf8","type":"TRIGGER","name":"TR_ISI_RES_PRUEF_PLAN_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}