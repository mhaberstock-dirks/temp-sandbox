create or replace editionable trigger dirkspzm32.tr_ts_schedule_cfg_biud before
    insert or update or delete on dirkspzm32.ts_schedule_cfg
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if nvl(:new.schedule_cfg_id,
               -1) = -1 then
            select
                seq_schedule_cfg_id.nextval
            into :new.schedule_cfg_id
            from
                dual;

        end if;

    end if;
end tr_ts_schedule_cfg_biud;
/

alter trigger dirkspzm32.tr_ts_schedule_cfg_biud enable;


-- sqlcl_snapshot {"hash":"df164ac3fafaaf84ff0cb5cf5bcd736f5473b65e","type":"TRIGGER","name":"TR_TS_SCHEDULE_CFG_BIUD","schemaName":"DIRKSPZM32","sxml":""}