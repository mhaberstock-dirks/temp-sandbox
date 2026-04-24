create or replace editionable trigger dirkspzm32.tr_isi_res_pruef_plan_data_bi before
    insert on dirkspzm32.isi_res_pruef_plan_data
    for each row
declare
  -- local variables here
 begin
    if :new.id is null then
        select
            seq_isi_res_pruef_plan_data.nextval
        into :new.id
        from
            dual;

    end if;

    if :new.created_date is null then
        :new.created_date := sysdate;
    end if;

    if :new.created_login_id is null then
        :new.created_login_id := -1;
    end if;

end tr_isi_res_pruef_plan_data_bi;
/

alter trigger dirkspzm32.tr_isi_res_pruef_plan_data_bi enable;


-- sqlcl_snapshot {"hash":"74d2c187e5f81805c4713152da2c0d02063d86fb","type":"TRIGGER","name":"TR_ISI_RES_PRUEF_PLAN_DATA_BI","schemaName":"DIRKSPZM32","sxml":""}