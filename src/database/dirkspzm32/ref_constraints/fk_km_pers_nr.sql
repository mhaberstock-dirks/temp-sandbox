alter table dirkspzm32.pzm_abwesenheitsmeldungen
    add constraint fk_km_pers_nr
        foreign key ( pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"4817f387876e1ccde0fec324b37e37e2ab48dd9c","type":"REF_CONSTRAINT","name":"FK_KM_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}