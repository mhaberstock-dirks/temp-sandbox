alter table dirkspzm32.pzm_abwesenheitsmeldungen
    add constraint fk_km_sa_kurzname
        foreign key ( sa_kurzname )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"7aa149520b93d231f63e77e075f6151ef051714a","type":"REF_CONSTRAINT","name":"FK_KM_SA_KURZNAME","schemaName":"DIRKSPZM32","sxml":""}