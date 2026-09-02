
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ABWESENHEITSMELD_BIU" 
  before insert or update on "PZM_ABWESENHEITSMELDUNGEN"
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
ALTER TRIGGER "TR_ABWESENHEITSMELD_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"0d5a6e81bbf2bcd3b00ff515e0aaf4785beca5d6","type":"TRIGGER","name":"TR_ABWESENHEITSMELD_BIU","schemaName":"DIRKSPZM32","sxml":""}