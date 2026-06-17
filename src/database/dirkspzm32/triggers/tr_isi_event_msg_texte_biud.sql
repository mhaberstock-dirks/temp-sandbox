
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_EVENT_MSG_TEXTE_BIUD" 
  before insert or update or delete on DIRKSPZM32.isi_event_message_texte
  for each row
declare
  -- Lokale Variablen
begin
  if inserting
  then
    if :new.event_msg_text_id is null
    then
      select seq_event_msg_text_id.nextval into :new.event_msg_text_id from dual;
    end if;
  end if;
end tr_isi_event_msg_texte_biud;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_EVENT_MSG_TEXTE_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"0eccf557b04d02fdc3894e9d742751a2305583f2","type":"TRIGGER","name":"TR_ISI_EVENT_MSG_TEXTE_BIUD","schemaName":"DIRKSPZM32","sxml":""}