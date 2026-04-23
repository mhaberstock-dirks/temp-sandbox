alter table dirkspzm32.isi_purch_lief_plan_abruf
    add constraint fk_lief_plan_abruf_rv
        foreign key ( lief_plan_rv_id )
            references dirkspzm32.isi_purch_lief_plan_rv ( lief_plan_rv_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"0ddcf1dfd47510ecc3c29eaa6aff982e6e3cdc3e","type":"REF_CONSTRAINT","name":"FK_LIEF_PLAN_ABRUF_RV","schemaName":"DIRKSPZM32","sxml":""}