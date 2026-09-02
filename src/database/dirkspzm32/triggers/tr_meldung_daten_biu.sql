
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_MELDUNG_DATEN_BIU" 
  before insert or update on meldung_daten
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
ALTER TRIGGER "TR_MELDUNG_DATEN_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"fb3dd34c543aac353af69c1604657f55ca93a429","type":"TRIGGER","name":"TR_MELDUNG_DATEN_BIU","schemaName":"DIRKSPZM32","sxml":""}