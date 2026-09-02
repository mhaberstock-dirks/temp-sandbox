
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RES_PRUEF_PLAN_DATA_BI" 
  before insert on ISI_RES_PRUEF_PLAN_DATA
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
ALTER TRIGGER "TR_ISI_RES_PRUEF_PLAN_DATA_BI" ENABLE;


-- sqlcl_snapshot {"hash":"2013e897c426c814fc58f1d3c61176d2786a56a6","type":"TRIGGER","name":"TR_ISI_RES_PRUEF_PLAN_DATA_BI","schemaName":"DIRKSPZM32","sxml":""}