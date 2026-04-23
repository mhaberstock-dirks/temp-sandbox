create or replace editionable trigger dirkspzm32.tr_pzm_ze_loa_13w_schnitt_bui before
    insert or update on dirkspzm32.pzm_ze_loa_13w_schnitt
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

alter trigger dirkspzm32.tr_pzm_ze_loa_13w_schnitt_bui enable;


-- sqlcl_snapshot {"hash":"5e933cfb8bf6a084990757472ca81208812e0e81","type":"TRIGGER","name":"TR_PZM_ZE_LOA_13W_SCHNITT_BUI","schemaName":"DIRKSPZM32","sxml":""}