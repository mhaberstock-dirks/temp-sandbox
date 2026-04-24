create or replace editionable trigger dirkspzm32.tr_isi_res_pruef_plan_cfg_bi before
    insert on dirkspzm32.isi_res_pruef_plan_data_cfg
    for each row
declare
  -- local variables here
 begin
    if :new.id is null
       or :new.id = 0 then
        select
            seq_isi_res_pruef_p_data_cfg.nextval
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

end tr_isi_res_pruef_plan_cfg_bi;
/

alter trigger dirkspzm32.tr_isi_res_pruef_plan_cfg_bi enable;


-- sqlcl_snapshot {"hash":"3da0a50d96eddbc86fe20bef34244db4a02ec573","type":"TRIGGER","name":"TR_ISI_RES_PRUEF_PLAN_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}