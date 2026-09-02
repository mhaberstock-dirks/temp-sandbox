
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PE_JOBS_WK_TEMP_BI" 
  before insert on pe_jobs
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
ALTER TRIGGER "TR_PE_JOBS_WK_TEMP_BI" ENABLE;


-- sqlcl_snapshot {"hash":"81cbe324e8a35a6fb89d3b6dc965534af79c9afa","type":"TRIGGER","name":"TR_PE_JOBS_WK_TEMP_BI","schemaName":"DIRKSPZM32","sxml":""}