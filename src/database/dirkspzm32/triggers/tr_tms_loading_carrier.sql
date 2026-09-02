
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_TMS_LOADING_CARRIER" 
  before insert or update or delete on tms_loading_carrier
  for each row
begin

  if inserting
  then
    if :new.arrival_time is NULL
    then
      :new.arrival_time := sysdate;
    end if;
  end if;
end TR_S_SQD_SAP_SEND_BEW_BIUD;


/
ALTER TRIGGER "TR_TMS_LOADING_CARRIER" ENABLE;


-- sqlcl_snapshot {"hash":"9e261fce5b8b94d37c468b5f3f6e22567ba9b4f7","type":"TRIGGER","name":"TR_TMS_LOADING_CARRIER","schemaName":"DIRKSPZM32","sxml":""}