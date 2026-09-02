
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_REP_ABFRAGEN_BIU" 
  before insert or update on rep_abfragen
  for each row
declare
  -- local variables here
begin
  if INSERTING then
    SELECT seq_rep_id.nextval INTO :new.rep_id FROM dual;
  end if;
end TR_REP_ABFRAGEN_BIU;


/
ALTER TRIGGER "TR_REP_ABFRAGEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"41602206a2f3967807fe6a888cc4174d6a42cefa","type":"TRIGGER","name":"TR_REP_ABFRAGEN_BIU","schemaName":"DIRKSPZM32","sxml":""}