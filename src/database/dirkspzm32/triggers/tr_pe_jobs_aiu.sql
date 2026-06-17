
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PE_JOBS_AIU" 
  after insert or update on DIRKSPZM32.pe_jobs
  for each row
declare
  -- local variables here
begin
  return;
  if INSERTING then
    isi_message_board.c_send_raw_message('NEW_PRINT_JOB', to_char(:new.job_nr));
    --dbms_alert.SIGNAL('NEW_PRINT_JOB', to_char(:new.job_nr));
  elsif UPDATING then
    isi_message_board.c_send_raw_message('PRINT_JOB_UPDATED', to_char(:new.job_nr));
    --dbms_alert.SIGNAL('PRINT_JOB_UPDATED', to_char(:new.job_nr));
  end if;
end TR_PE_JOBS_AIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PE_JOBS_AIU" ENABLE;


-- sqlcl_snapshot {"hash":"e9445844a5031cdec3fe443f6886d29001f476a4","type":"TRIGGER","name":"TR_PE_JOBS_AIU","schemaName":"DIRKSPZM32","sxml":""}