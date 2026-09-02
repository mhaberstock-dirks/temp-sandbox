
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_TS_JOB_ITEMS_LOG" 
  before insert on ts_job_items_log
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
ALTER TRIGGER "TR_TS_JOB_ITEMS_LOG" ENABLE;


-- sqlcl_snapshot {"hash":"130815c6bbfc9e0543d92d62704f297b0e6ee9aa","type":"TRIGGER","name":"TR_TS_JOB_ITEMS_LOG","schemaName":"DIRKSPZM32","sxml":""}