create or replace editionable trigger dirkspzm32.tr_pzm_ze_azk_urlaub_bui before
    insert or update on dirkspzm32.pzm_ze_azk_urlaub
    for each row
declare begin
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

alter trigger dirkspzm32.tr_pzm_ze_azk_urlaub_bui enable;


-- sqlcl_snapshot {"hash":"8e3e461d34df21f91a9c52c5bd2a9e7f2c2069b8","type":"TRIGGER","name":"TR_PZM_ZE_AZK_URLAUB_BUI","schemaName":"DIRKSPZM32","sxml":""}