
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_LVS_CHECK_LOG_BI" 
  before insert on lvs_check_log
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
ALTER TRIGGER "TR_LVS_CHECK_LOG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"aa743b2c5773d1471bcace334637519ab93b6884","type":"TRIGGER","name":"TR_LVS_CHECK_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}