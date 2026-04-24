create or replace editionable trigger dirkspzm32.tr_pzm_bereitschaft_plan_bui before
    insert or update on dirkspzm32.pzm_bereitschaft_plan
    for each row
declare begin
    if inserting then
        :new.created_date := sysdate;
        :new.created_user := current_isi_user();
        if :new.plan_id is null then
            select
                seq_pzm_bereitschaft_plan.nextval
            into :new.plan_id
            from
                dual;

        end if;

    else
        :new.last_change_date := sysdate;
        :new.last_change_user := current_isi_user();
    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_bereitschaft_plan_bui enable;


-- sqlcl_snapshot {"hash":"5fe83b2c595754c79e7891919de20cc82b0482a8","type":"TRIGGER","name":"TR_PZM_BEREITSCHAFT_PLAN_BUI","schemaName":"DIRKSPZM32","sxml":""}