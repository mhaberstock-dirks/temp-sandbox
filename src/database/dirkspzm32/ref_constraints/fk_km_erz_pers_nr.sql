alter table dirkspzm32.pzm_abwesenheitsmeldungen
    add constraint fk_km_erz_pers_nr
        foreign key ( erz_pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"aaa0f08a6838791bc78f7088bc43562ad8d541eb","type":"REF_CONSTRAINT","name":"FK_KM_ERZ_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}