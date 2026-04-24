create or replace editionable trigger dirkspzm32.tr_pzm_ze_bde_zeiten_biud before
    insert or update or delete on dirkspzm32.pzm_ze_bde_zeiten
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

        if
            :old.ze_bde_verbucht_status = 'UE'
            and :new.ze_bde_verbucht_status != :old.ze_bde_verbucht_status
        then
            :new.ze_bde_dwh_status := 'N';
        end if;

    end if;

end;
/

alter trigger dirkspzm32.tr_pzm_ze_bde_zeiten_biud enable;


-- sqlcl_snapshot {"hash":"83af8bed05b8cfff339c16e4fe871e99e8956e65","type":"TRIGGER","name":"TR_PZM_ZE_BDE_ZEITEN_BIUD","schemaName":"DIRKSPZM32","sxml":""}