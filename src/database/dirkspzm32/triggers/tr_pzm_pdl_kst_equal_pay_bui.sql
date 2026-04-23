create or replace editionable trigger dirkspzm32.tr_pzm_pdl_kst_equal_pay_bui before
    insert or update on dirkspzm32.pzm_pdl_kst_equal_pay
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

alter trigger dirkspzm32.tr_pzm_pdl_kst_equal_pay_bui enable;


-- sqlcl_snapshot {"hash":"ac4a8a19ca4d9f7e6de317776c04d261c264f2b1","type":"TRIGGER","name":"TR_PZM_PDL_KST_EQUAL_PAY_BUI","schemaName":"DIRKSPZM32","sxml":""}