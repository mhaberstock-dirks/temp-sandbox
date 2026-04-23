alter table dirkspzm32.pzm_bereitschaft_plan
    add constraint fk_pzm_bereitschaft_plan_pers_nr
        foreign key ( pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"b94c8ca1017084cb37557e9ff03f145d6e82835d","type":"REF_CONSTRAINT","name":"FK_PZM_BEREITSCHAFT_PLAN_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}