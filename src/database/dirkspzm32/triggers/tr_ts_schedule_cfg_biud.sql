
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_TS_SCHEDULE_CFG_BIUD" 
  before insert or update or delete on DIRKSPZM32.ts_schedule_cfg
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    if nvl(:new.schedule_cfg_id, - 1) = -1
    then
      select seq_schedule_cfg_id.nextval into :new.schedule_cfg_id from dual;
    end if;
  end if;
end tr_ts_schedule_cfg_biud;

/
ALTER TRIGGER "DIRKSPZM32"."TR_TS_SCHEDULE_CFG_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"396448f0e0115a88691b7d687f2f40b6fdb3bd53","type":"TRIGGER","name":"TR_TS_SCHEDULE_CFG_BIUD","schemaName":"DIRKSPZM32","sxml":""}