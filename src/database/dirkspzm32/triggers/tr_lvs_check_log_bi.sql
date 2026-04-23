create or replace editionable trigger dirkspzm32.tr_lvs_check_log_bi before
    insert on dirkspzm32.lvs_check_log
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if :new.lvs_check_log_id is null then
            select
                seq_lvs_check_log_id.nextval
            into :new.lvs_check_log_id
            from
                dual;

        end if;

    end if;
end tr_lvs_check_log_bi;
/

alter trigger dirkspzm32.tr_lvs_check_log_bi enable;


-- sqlcl_snapshot {"hash":"d139597cc2c3dd54ad0bc1a3db0be6b3d9f467bd","type":"TRIGGER","name":"TR_LVS_CHECK_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}