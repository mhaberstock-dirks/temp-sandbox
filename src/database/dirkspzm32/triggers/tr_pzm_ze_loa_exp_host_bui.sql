create or replace editionable trigger dirkspzm32.tr_pzm_ze_loa_exp_host_bui before
    insert or update on dirkspzm32.pzm_ze_loa_exp_host
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
        if :new.status != :old.status then
            update pzm_ze_loa_statistik_exp_host x
            set
                x.status = :new.status,
                x.ret_code = :new.ret_code,
                x.err_text = :new.err_text,
                x.cycle = :new.cycle,
                x.last_change_date = :new.last_change_date,
                x.last_change_login_id = :new.last_change_login_id,
                x.last_change_user = :new.last_change_user
            where
                    x.pers_nr = :new.pers_nr
                and x.datum = :new.datum
                and x.status != :new.status;

        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_ze_loa_exp_host_bui enable;


-- sqlcl_snapshot {"hash":"3a051531896af0621d43157e532d3c72d8efb2e2","type":"TRIGGER","name":"TR_PZM_ZE_LOA_EXP_HOST_BUI","schemaName":"DIRKSPZM32","sxml":""}