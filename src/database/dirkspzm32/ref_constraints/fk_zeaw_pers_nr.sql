alter table dirkspzm32.pzm_ze_loa_ausw
    add constraint fk_zeaw_pers_nr
        foreign key ( zeaw_pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
        disable;


-- sqlcl_snapshot {"hash":"8faa2616119c2cd6559279d5bd5c6dae8f361fd5","type":"REF_CONSTRAINT","name":"FK_ZEAW_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}