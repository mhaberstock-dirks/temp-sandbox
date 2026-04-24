alter table dirkspzm32.isi_res_plan_data
    add constraint fk_isi_res_plan_data_sm
        foreign key ( sm_name )
            references dirkspzm32.pzm_schicht_modelle ( sm_name )
        enable;


-- sqlcl_snapshot {"hash":"a77518a16cdcebd6a29130068207f8f4c90d70b2","type":"REF_CONSTRAINT","name":"FK_ISI_RES_PLAN_DATA_SM","schemaName":"DIRKSPZM32","sxml":""}