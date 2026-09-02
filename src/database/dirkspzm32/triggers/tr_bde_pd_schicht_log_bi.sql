
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_BDE_PD_SCHICHT_LOG_BI" 
  before insert on bde_pd_schicht_log
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
ALTER TRIGGER "TR_BDE_PD_SCHICHT_LOG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"20d6d20414b2a6341419ac7b9bad638fdc57fd24","type":"TRIGGER","name":"TR_BDE_PD_SCHICHT_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}