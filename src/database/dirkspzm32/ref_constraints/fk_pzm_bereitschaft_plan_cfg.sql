alter table dirkspzm32.pzm_bereitschaft_plan
    add constraint fk_pzm_bereitschaft_plan_cfg
        foreign key ( bereitschaft_cfg )
            references dirkspzm32.pzm_bereitschaft_cfg ( bereitschaft_cfg )
        enable;


-- sqlcl_snapshot {"hash":"f9fcaa55a9556ca3a8fa4116edcde19feb78c83e","type":"REF_CONSTRAINT","name":"FK_PZM_BEREITSCHAFT_PLAN_CFG","schemaName":"DIRKSPZM32","sxml":""}