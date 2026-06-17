
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_CHECK_LOG_BI" 
  before insert on DIRKSPZM32.lvs_check_log
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    if :new.lvs_check_log_id is null
    then
      select seq_lvs_check_log_id.nextval into :new.lvs_check_log_id from dual;
    end if;
  end if;
end tr_lvs_check_log_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_CHECK_LOG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"03e841d714bc34b25682a87cee0caac413fac5d0","type":"TRIGGER","name":"TR_LVS_CHECK_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}