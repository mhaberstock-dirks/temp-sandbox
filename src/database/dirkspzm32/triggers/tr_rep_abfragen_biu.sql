
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_REP_ABFRAGEN_BIU" 
  before insert or update on DIRKSPZM32.rep_abfragen
  for each row
declare
  -- local variables here
begin
  if INSERTING then
    SELECT seq_rep_id.nextval INTO :new.rep_id FROM dual;
  end if;
end TR_REP_ABFRAGEN_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_REP_ABFRAGEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"2a074d4ce3b7d435506b91244fdf8f609a6bbb2a","type":"TRIGGER","name":"TR_REP_ABFRAGEN_BIU","schemaName":"DIRKSPZM32","sxml":""}