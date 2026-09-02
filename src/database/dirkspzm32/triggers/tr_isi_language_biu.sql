
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_LANGUAGE_BIU" 
  before insert or update on ISI_LANGUAGE
  for each row
declare

  -- local variables here
begin
  if :new.lang_id is NULL
  then
    select SEQ_ISI_LANGUAGE_LANG_ID.NEXTVAL into :new.lang_id from dual;
  end if;
end;


/
ALTER TRIGGER "TR_ISI_LANGUAGE_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"09040b560c16a2e8631cbf0ffaf136df9019dbc6","type":"TRIGGER","name":"TR_ISI_LANGUAGE_BIU","schemaName":"DIRKSPZM32","sxml":""}