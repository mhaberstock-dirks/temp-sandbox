
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PE_JOBS_WK_TEMP_BI" 
  before insert on DIRKSPZM32.pe_jobs
  for each row
declare
  -- local variables here
begin
  if :new.drucker_name = 'Zebra L7+8'
  then
    :new.anzahl := 1;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PE_JOBS_WK_TEMP_BI" ENABLE;


-- sqlcl_snapshot {"hash":"62f587c8eee9353340fa71720eaad730f1c1edc0","type":"TRIGGER","name":"TR_PE_JOBS_WK_TEMP_BI","schemaName":"DIRKSPZM32","sxml":""}