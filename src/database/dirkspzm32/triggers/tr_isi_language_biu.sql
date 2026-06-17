
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_LANGUAGE_BIU" 
  before insert or update on DIRKSPZM32.ISI_LANGUAGE
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
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_LANGUAGE_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"f5d9c904e1afe067ac216b4dc06af1128c2ee7f3","type":"TRIGGER","name":"TR_ISI_LANGUAGE_BIU","schemaName":"DIRKSPZM32","sxml":""}