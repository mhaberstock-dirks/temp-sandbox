create or replace editionable trigger dirkspzm32.tr_pzm_tarifmodelle_bui before
    insert or update on dirkspzm32.pzm_tarifmodelle
    for each row
declare begin
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        :new.created_login_id := nvl(
            current_isi_user_login_id(), -1
        );
    --:new.created_user := current_isi_user();
    else
        if :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;

        :new.last_change_login_id := nvl(
            current_isi_user_login_id(), -1
        );
    --:new.last_change_user := current_isi_user();
    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_tarifmodelle_bui enable;


-- sqlcl_snapshot {"hash":"293783ad97d346ae73d1b59ccf77940255c2f74d","type":"TRIGGER","name":"TR_PZM_TARIFMODELLE_BUI","schemaName":"DIRKSPZM32","sxml":""}