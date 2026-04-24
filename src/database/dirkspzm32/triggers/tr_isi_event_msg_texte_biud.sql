create or replace editionable trigger dirkspzm32.tr_isi_event_msg_texte_biud before
    insert or update or delete on dirkspzm32.isi_event_message_texte
    for each row
declare
  -- Lokale Variablen
 begin
    if inserting then
        if :new.event_msg_text_id is null then
            select
                seq_event_msg_text_id.nextval
            into :new.event_msg_text_id
            from
                dual;

        end if;

    end if;
end tr_isi_event_msg_texte_biud;
/

alter trigger dirkspzm32.tr_isi_event_msg_texte_biud enable;


-- sqlcl_snapshot {"hash":"1d35bcd23ffaa504243c6fd1bbe233636e0d05b9","type":"TRIGGER","name":"TR_ISI_EVENT_MSG_TEXTE_BIUD","schemaName":"DIRKSPZM32","sxml":""}