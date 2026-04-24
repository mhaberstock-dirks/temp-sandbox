create or replace editionable trigger dirkspzm32.tr_pzm_ze_loa_statistik_exp_host_bui before
    insert or update on dirkspzm32.pzm_ze_loa_statistik_exp_host
    for each row
declare begin
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        :new.created_login_id := nvl(
            current_isi_user_login_id(), -1
        );
    else
        if :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;

        :new.last_change_login_id := nvl(
            current_isi_user_login_id(), -1
        );
    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_ze_loa_statistik_exp_host_bui enable;


-- sqlcl_snapshot {"hash":"d589d7958b7c4eb3638207e2756db992f216ea44","type":"TRIGGER","name":"TR_PZM_ZE_LOA_STATISTIK_EXP_HOST_BUI","schemaName":"DIRKSPZM32","sxml":""}