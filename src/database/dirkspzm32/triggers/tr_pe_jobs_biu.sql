create or replace editionable trigger dirkspzm32.tr_pe_jobs_biu before
    insert or update on dirkspzm32.pe_jobs
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if :new.sid is null then
            :new.sid := '01';
        end if;

        if :new.firma_nr is null then
            :new.firma_nr := 1;
        end if;

        if :new.job_nr is null then
            select
                pe_seq_pe_jobs.nextval
            into :new.job_nr
            from
                dual;

        end if;

        if :new.job_timestamp is null then
            :new.job_timestamp := sysdate;
        end if;

        if :new.status is null then
            :new.status := 'N';
        end if;

        :new.status_time := sysdate;
    elsif updating then
    -- -WK- allways update the status time when the status changes
        if ( :new.status != :old.status )
        or ( :new.status_text != :old.status_text ) then
            :new.status_time := sysdate;
        end if;
    end if;
end tr_pe_jobs_biu;
/

alter trigger dirkspzm32.tr_pe_jobs_biu enable;


-- sqlcl_snapshot {"hash":"04a246bf67ccd26d2a08e93b64a57b5d26be3292","type":"TRIGGER","name":"TR_PE_JOBS_BIU","schemaName":"DIRKSPZM32","sxml":""}