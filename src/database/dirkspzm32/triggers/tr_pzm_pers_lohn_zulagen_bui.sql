create or replace editionable trigger dirkspzm32.tr_pzm_pers_lohn_zulagen_bui before
    insert or update on dirkspzm32.pzm_pers_lohn_zulagen
    for each row
declare begin
    if :new.pers_lz_seq is null then
        :new.pers_lz_seq := seq_pzm_pers_lz.nextval;
    end if;

    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        :new.created_login_id := nvl(
            current_isi_user_login_id(), -1
        );
        :new.created_user := current_isi_user();
    else
        if :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;

        :new.last_change_login_id := nvl(
            current_isi_user_login_id(), -1
        );
        :new.last_change_user := current_isi_user();
    end if;

end;
/

alter trigger dirkspzm32.tr_pzm_pers_lohn_zulagen_bui enable;


-- sqlcl_snapshot {"hash":"2f25cf873bea99accea0eda21ea4fafb96e00e75","type":"TRIGGER","name":"TR_PZM_PERS_LOHN_ZULAGEN_BUI","schemaName":"DIRKSPZM32","sxml":""}