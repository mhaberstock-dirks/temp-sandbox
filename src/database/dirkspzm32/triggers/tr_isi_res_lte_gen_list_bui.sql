
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RES_LTE_GEN_LIST_BUI" 
  before  Insert  or  Update  on DIRKSPZM32.ISI_RES_LTE_GEN_LIST
  for each row
declare

begin
  if :new.job_nr is NULL
  then
    :new.job_nr := 0;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RES_LTE_GEN_LIST_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"b8f24d141f03467076e7d4c6aa7b712d2cf17747","type":"TRIGGER","name":"TR_ISI_RES_LTE_GEN_LIST_BUI","schemaName":"DIRKSPZM32","sxml":""}