create or replace editionable trigger dirkspzm32.tr_isi_event_biud before
    insert or update or delete on dirkspzm32.isi_event
    for each row
declare
  -- Lokale Variablen
 begin
    if inserting then
        if :new.event_id is null then
            select
                seq_event_id.nextval
            into :new.event_id
            from
                dual;

        end if;

    end if;
end tr_isi_event_biud;
/

alter trigger dirkspzm32.tr_isi_event_biud enable;


-- sqlcl_snapshot {"hash":"5b7d69127dfadb45970b20ff2ec760371a5485f0","type":"TRIGGER","name":"TR_ISI_EVENT_BIUD","schemaName":"DIRKSPZM32","sxml":""}