create or replace editionable trigger dirkspzm32.tr_ts_job_items_log before
    insert on dirkspzm32.ts_job_items_log
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if nvl(:new.job_item_log_id,
               -1) = -1 then
            select
                seq_ts_job_item_log_id.nextval
            into :new.job_item_log_id
            from
                dual;

        end if;

    end if;
end tr_ts_job_items_log;
/

alter trigger dirkspzm32.tr_ts_job_items_log enable;


-- sqlcl_snapshot {"hash":"1b88b5f74312678849bf6495123f7afac3934a04","type":"TRIGGER","name":"TR_TS_JOB_ITEMS_LOG","schemaName":"DIRKSPZM32","sxml":""}