
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_TRANSPORT_LOG_BI" 
  before insert on DIRKSPZM32.isi_transport_log
  for each row
declare
  -- local variables here
begin
  if :new.transp_log_id is null
  then
    select seq_transp_log_id.nextval into :new.transp_log_id from dual;
  end if;
end tr_isi_transport_log_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_TRANSPORT_LOG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"8505fce08fbd395b0342ec7cac6e4cf4f2a93212","type":"TRIGGER","name":"TR_ISI_TRANSPORT_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}