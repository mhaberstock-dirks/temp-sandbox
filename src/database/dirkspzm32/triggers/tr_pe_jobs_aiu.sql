create or replace editionable trigger dirkspzm32.tr_pe_jobs_aiu after
    insert or update on dirkspzm32.pe_jobs
    for each row
declare
  -- local variables here
 begin
    return;
    if inserting then
        isi_message_board.c_send_raw_message('NEW_PRINT_JOB',
                                             to_char(:new.job_nr));
    --dbms_alert.SIGNAL('NEW_PRINT_JOB', to_char(:new.job_nr));
    elsif updating then
        isi_message_board.c_send_raw_message('PRINT_JOB_UPDATED',
                                             to_char(:new.job_nr));
    --dbms_alert.SIGNAL('PRINT_JOB_UPDATED', to_char(:new.job_nr));
    end if;

end tr_pe_jobs_aiu;
/

alter trigger dirkspzm32.tr_pe_jobs_aiu enable;


-- sqlcl_snapshot {"hash":"f7879e78af62415fec9d48acda32ffece61c5e56","type":"TRIGGER","name":"TR_PE_JOBS_AIU","schemaName":"DIRKSPZM32","sxml":""}