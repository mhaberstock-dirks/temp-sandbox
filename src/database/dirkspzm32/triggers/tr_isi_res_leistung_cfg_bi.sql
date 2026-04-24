create or replace editionable trigger dirkspzm32.tr_isi_res_leistung_cfg_bi before
    insert on dirkspzm32.isi_res_leistung_cfg
    for each row
declare
  -- local variables here
 begin
    if :new.res_l_cfg_id is null then
        select
            seq_isi_res_leistung_cfg.nextval
        into :new.res_l_cfg_id
        from
            dual;

    end if;
end tr_isi_res_leistung_cfg_bi;
/

alter trigger dirkspzm32.tr_isi_res_leistung_cfg_bi enable;


-- sqlcl_snapshot {"hash":"043059d0c7889becb57387a9d2a4db5681f4434e","type":"TRIGGER","name":"TR_ISI_RES_LEISTUNG_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}