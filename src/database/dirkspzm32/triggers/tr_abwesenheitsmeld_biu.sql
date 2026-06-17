
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ABWESENHEITSMELD_BIU" 
  before insert or update on DIRKSPZM32."PZM_ABWESENHEITSMELDUNGEN"
  for each row
declare
  -- local variables here
begin
  if INSERTING then
    SELECT seq_km_id.nextval INTO :new.km_id FROM dual;
    :new.erz_datum := SYSDATE;
  end if;

  if UPDATING then
    :new.aend_datum := SYSDATE;
  end if;

  :new.anz_tage := (TRUNC(:new.ende) - TRUNC(:new.beginn)) + 1;
end TR_KRANKMELD_BI;


/
ALTER TRIGGER "DIRKSPZM32"."TR_ABWESENHEITSMELD_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"1c96f3baa4162a5683d8e889d092274ed0e24b3b","type":"TRIGGER","name":"TR_ABWESENHEITSMELD_BIU","schemaName":"DIRKSPZM32","sxml":""}