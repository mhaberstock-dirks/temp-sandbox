alter table dirkspzm32.pzm_abwesenheits_antr
    add constraint fk_au_pruef_pers_nr
        foreign key ( au_pruef_pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
        disable;


-- sqlcl_snapshot {"hash":"0f46083629f49f4b9ee0aeb2e36e0ae5950873e5","type":"REF_CONSTRAINT","name":"FK_AU_PRUEF_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}