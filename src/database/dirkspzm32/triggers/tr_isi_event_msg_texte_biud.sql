
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_EVENT_MSG_TEXTE_BIUD" 
  before insert or update or delete on isi_event_message_texte
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
ALTER TRIGGER "TR_ISI_EVENT_MSG_TEXTE_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"6e5aed74f9a19f63b77dbc185c4dda57cb94ce04","type":"TRIGGER","name":"TR_ISI_EVENT_MSG_TEXTE_BIUD","schemaName":"DIRKSPZM32","sxml":""}