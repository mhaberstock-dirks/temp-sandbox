create or replace editionable trigger dirkspzm32.tr_isi_language_biu before
    insert or update on dirkspzm32.isi_language
    for each row
declare

  -- local variables here
 begin
    if :new.lang_id is null then
        select
            seq_isi_language_lang_id.nextval
        into :new.lang_id
        from
            dual;

    end if;
end;
/

alter trigger dirkspzm32.tr_isi_language_biu enable;


-- sqlcl_snapshot {"hash":"f207f3c4f188be8467883236cc471479daa4aa81","type":"TRIGGER","name":"TR_ISI_LANGUAGE_BIU","schemaName":"DIRKSPZM32","sxml":""}