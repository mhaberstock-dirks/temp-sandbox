
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_TMS_LOADING_CARRIER" 
  before insert or update or delete on DIRKSPZM32.tms_loading_carrier
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
ALTER TRIGGER "DIRKSPZM32"."TR_TMS_LOADING_CARRIER" ENABLE;


-- sqlcl_snapshot {"hash":"b87b44992c97a8b0cbd5473e980296a88d8260c0","type":"TRIGGER","name":"TR_TMS_LOADING_CARRIER","schemaName":"DIRKSPZM32","sxml":""}