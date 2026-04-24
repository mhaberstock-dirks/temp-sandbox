create or replace editionable trigger dirkspzm32.tr_isi_artikel_gruppe_bi before
    insert on dirkspzm32.isi_artikel_gruppe
    for each row
begin
    if inserting then
        if :new.art_gruppe_id is null
           or :new.art_gruppe_id = 0 then
            select
                seq_artikel_gruppe_id.nextval
            into :new.art_gruppe_id
            from
                dual;

        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_isi_artikel_gruppe_bi enable;


-- sqlcl_snapshot {"hash":"0f9a4287c3fafb6f6bc357751a2ef255a2de9ebb","type":"TRIGGER","name":"TR_ISI_ARTIKEL_GRUPPE_BI","schemaName":"DIRKSPZM32","sxml":""}