
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_TRANSPORT_LOG_BI" 
  before insert on isi_transport_log
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
ALTER TRIGGER "TR_ISI_TRANSPORT_LOG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"62b1c7aa2a260c68925a7eb5fd9dff8ae5f36c63","type":"TRIGGER","name":"TR_ISI_TRANSPORT_LOG_BI","schemaName":"DIRKSPZM32","sxml":""}