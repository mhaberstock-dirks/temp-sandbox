
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_TS_JOB_ITEMS_LOG" 
  before insert on DIRKSPZM32.ts_job_items_log
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    if nvl(:new.job_item_log_id, -1) = -1
    then
      select seq_ts_job_item_log_id.nextval into :new.job_item_log_id from dual;
    end if;
  end if;

end TR_TS_JOB_ITEMS_LOG;

/
ALTER TRIGGER "DIRKSPZM32"."TR_TS_JOB_ITEMS_LOG" ENABLE;


-- sqlcl_snapshot {"hash":"6d3d349f484fb824b6bd2537d7baeb4fd7e470db","type":"TRIGGER","name":"TR_TS_JOB_ITEMS_LOG","schemaName":"DIRKSPZM32","sxml":""}