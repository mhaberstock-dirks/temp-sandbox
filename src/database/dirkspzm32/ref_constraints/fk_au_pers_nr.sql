alter table dirkspzm32.pzm_abwesenheits_antr
    add constraint fk_au_pers_nr
        foreign key ( au_pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
        disable;


-- sqlcl_snapshot {"hash":"d4bf2eee0fdfe071bc1af28d7e6fd3350c53b05f","type":"REF_CONSTRAINT","name":"FK_AU_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}