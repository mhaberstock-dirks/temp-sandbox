create or replace editionable trigger dirkspzm32.tr_isi_res_lte_gen_list_bui before
    insert or update on dirkspzm32.isi_res_lte_gen_list
    for each row
declare begin
    if :new.job_nr is null then
        :new.job_nr := 0;
    end if;
end;
/

alter trigger dirkspzm32.tr_isi_res_lte_gen_list_bui enable;


-- sqlcl_snapshot {"hash":"c9923277925f7981259511b8d1963fb405ff44cb","type":"TRIGGER","name":"TR_ISI_RES_LTE_GEN_LIST_BUI","schemaName":"DIRKSPZM32","sxml":""}