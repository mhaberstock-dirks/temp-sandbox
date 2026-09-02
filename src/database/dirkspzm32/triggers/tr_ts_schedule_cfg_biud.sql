
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_TS_SCHEDULE_CFG_BIUD" 
  before insert or update or delete on ts_schedule_cfg
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
ALTER TRIGGER "TR_TS_SCHEDULE_CFG_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"36e23e356ec12e5393a3902de30fb9c6e857016f","type":"TRIGGER","name":"TR_TS_SCHEDULE_CFG_BIUD","schemaName":"DIRKSPZM32","sxml":""}