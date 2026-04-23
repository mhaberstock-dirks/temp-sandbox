create or replace editionable trigger dirkspzm32.tr_pe_jobs_wk_temp_bi before
    insert on dirkspzm32.pe_jobs
    for each row
declare
  -- local variables here
 begin
    if :new.drucker_name = 'Zebra L7+8' then
        :new.anzahl := 1;
    end if;
end;
/

alter trigger dirkspzm32.tr_pe_jobs_wk_temp_bi enable;


-- sqlcl_snapshot {"hash":"bbd5938c1eedb93928fc7f8cd13a7d7a55d4bf0f","type":"TRIGGER","name":"TR_PE_JOBS_WK_TEMP_BI","schemaName":"DIRKSPZM32","sxml":""}