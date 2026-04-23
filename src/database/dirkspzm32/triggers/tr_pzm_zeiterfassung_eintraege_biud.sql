create or replace editionable trigger dirkspzm32.tr_pzm_zeiterfassung_eintraege_biud before
    insert or update or delete on dirkspzm32.pzm_zeiterfassung_eintraege
    for each row
declare begin
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        if :new.created_login_id is null then
            :new.created_login_id := current_isi_user_login_id();
        end if;

    end if;

    if updating then
        if :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;

        if :new.last_change_login_id is null then
            :new.last_change_login_id := current_isi_user_login_id();
        end if;

    end if;

end;
/

alter trigger dirkspzm32.tr_pzm_zeiterfassung_eintraege_biud enable;


-- sqlcl_snapshot {"hash":"a1593a3638cbbc70154f02d1504dc7ef130ae515","type":"TRIGGER","name":"TR_PZM_ZEITERFASSUNG_EINTRAEGE_BIUD","schemaName":"DIRKSPZM32","sxml":""}