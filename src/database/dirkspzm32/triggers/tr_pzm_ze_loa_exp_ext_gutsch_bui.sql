create or replace editionable trigger dirkspzm32.tr_pzm_ze_loa_exp_ext_gutsch_bui before
    insert or update on dirkspzm32.pzm_ze_loa_exp_ext_gutsch
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
        :new.last_change_date := sysdate;
        :new.last_change_login_id := nvl(
            current_isi_user_login_id(), -1
        );
        :new.last_change_user := current_isi_user();
    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_ze_loa_exp_ext_gutsch_bui enable;


-- sqlcl_snapshot {"hash":"2e62ca26d7ab957733feb87ff0b52eea5f18927e","type":"TRIGGER","name":"TR_PZM_ZE_LOA_EXP_EXT_GUTSCH_BUI","schemaName":"DIRKSPZM32","sxml":""}