alter table dirkspzm32.pzm_pers_lohn_zulagen
    add constraint fk_pzm_pers_lohn_zulagen_pers_nr
        foreign key ( pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
                on delete cascade
        disable;


-- sqlcl_snapshot {"hash":"4062b849992ee00826d6225d55eefb97de7202aa","type":"REF_CONSTRAINT","name":"FK_PZM_PERS_LOHN_ZULAGEN_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}