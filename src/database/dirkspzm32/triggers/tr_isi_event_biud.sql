
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_EVENT_BIUD" 
  before insert or update or delete on DIRKSPZM32.isi_event
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
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_EVENT_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"a26c469094b0f9bbae0dcadcde813f1be1833995","type":"TRIGGER","name":"TR_ISI_EVENT_BIUD","schemaName":"DIRKSPZM32","sxml":""}