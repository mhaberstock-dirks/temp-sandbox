alter table dirkspzm32.pzm_zeiterfassung
    add constraint fk_ze_sa_kurzname
        foreign key ( ze_sa_kurzname )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
        disable;


-- sqlcl_snapshot {"hash":"c3c0228d9184b0d59060cc3a9cf60149adaae82b","type":"REF_CONSTRAINT","name":"FK_ZE_SA_KURZNAME","schemaName":"DIRKSPZM32","sxml":""}