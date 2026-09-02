
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RES_LTE_GEN_LIST_BUI" 
  before  Insert  or  Update  on ISI_RES_LTE_GEN_LIST
  for each row
declare

begin
  if :new.job_nr is NULL
  then
    :new.job_nr := 0;
  end if;
end;


/
ALTER TRIGGER "TR_ISI_RES_LTE_GEN_LIST_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"608968c1e73374de322cc9ba0646564cf86e715b","type":"TRIGGER","name":"TR_ISI_RES_LTE_GEN_LIST_BUI","schemaName":"DIRKSPZM32","sxml":""}