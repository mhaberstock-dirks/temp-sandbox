alter table dirkspzm32.pzm_zeiterfassung
    add constraint fk_ze_korr_pers_nr
        foreign key ( ze_korr_pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
        disable;


-- sqlcl_snapshot {"hash":"bfe4434eefb21a0249009f10b31fbd9088f42f73","type":"REF_CONSTRAINT","name":"FK_ZE_KORR_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}