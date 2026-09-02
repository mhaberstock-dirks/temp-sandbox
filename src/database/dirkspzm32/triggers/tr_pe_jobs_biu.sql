
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PE_JOBS_BIU" 
  before insert or update on pe_jobs
  for each row
declare
  -- local variables here
begin
  if INSERTING
  then
    if :new.sid is NULL
    then
      :new.sid := '01';
    end if;

    if :new.firma_nr is NULL
    then
      :new.firma_nr := 1;
    end if;

    if :new.job_nr is NULL
    then
      select pe_seq_pe_jobs.nextval into :new.job_nr from dual;
    end if;

    if :new.job_timestamp is null
    then
      :new.job_timestamp := SYSDATE;
    end if;

    if :new.status is null
    then
      :new.status := 'N';
    end if;

    :new.status_time := SYSDATE;
  elsif UPDATING
  then
    -- -WK- allways update the status time when the status changes
    if (:new.status != :old.status) or (:new.status_text != :old.status_text) then
      :new.status_time := SYSDATE;
    end if;
  end if;
end tr_pe_jobs_biu;


/
ALTER TRIGGER "TR_PE_JOBS_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"2e63838d12c3ae728f08f369a664177d83c2bf54","type":"TRIGGER","name":"TR_PE_JOBS_BIU","schemaName":"DIRKSPZM32","sxml":""}