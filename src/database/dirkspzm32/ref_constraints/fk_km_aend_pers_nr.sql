alter table dirkspzm32.pzm_abwesenheitsmeldungen
    add constraint fk_km_aend_pers_nr
        foreign key ( aend_pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"fa4e6ea678b7abcfdc2c34bd836da04d4129c6ac","type":"REF_CONSTRAINT","name":"FK_KM_AEND_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}