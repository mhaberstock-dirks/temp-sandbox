alter table dirkspzm32.isi_purch_lief_plan_abr_kal
    add constraint fk_lief_plan_abr_kal
        foreign key ( lief_plan_abruf_id )
            references dirkspzm32.isi_purch_lief_plan_abruf ( lief_plan_abruf_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"0edb9434ec21915bb2f93f9a6c94eade82d8aee0","type":"REF_CONSTRAINT","name":"FK_LIEF_PLAN_ABR_KAL","schemaName":"DIRKSPZM32","sxml":""}