
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_EVENT_BIUD" 
  before insert or update or delete on isi_event
  for each row
declare
  -- Lokale Variablen
begin
  if inserting
  then
    if :new.event_id is null
    then
      select seq_event_id.nextval into :new.event_id from dual;
    end if;
  end if;
end tr_isi_event_biud;


/
ALTER TRIGGER "TR_ISI_EVENT_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"2fc75e3c5aa8f5a785ead2b9c275cc8cb78ceceb","type":"TRIGGER","name":"TR_ISI_EVENT_BIUD","schemaName":"DIRKSPZM32","sxml":""}