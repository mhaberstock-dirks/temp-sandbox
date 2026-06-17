
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_MELDUNG_DATEN_BIU" 
  before insert or update on DIRKSPZM32.meldung_daten
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    select seq_md_id.nextval into :new.md_id from dual;
  end if;
end tr_meldung_daten_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_MELDUNG_DATEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"408b4a1e3dbec4414e8f0dc0f9bc141ca33182ef","type":"TRIGGER","name":"TR_MELDUNG_DATEN_BIU","schemaName":"DIRKSPZM32","sxml":""}