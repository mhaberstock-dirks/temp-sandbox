
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_BDE_PD_SCHICHT_LOG_BI" 
  before insert on DIRKSPZM32.bde_pd_schicht_log
  for each row
declare
  -- local variables here
begin
  if :new.schicht_log_id is null
  then
    select SEQ_BDE_PD_SCHICHT_LOG_ID.nextval into :new.schicht_log_id from dual;
  end if;
end tr_bde_pd_schicht_log_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_BDE_PD_SCHICHT_LOG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"1e9b00e1bed3fd33144c6620f0d83847a3049017","type":"TRIGGER","name":"TR_BDE_PD_SCHICHT_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}