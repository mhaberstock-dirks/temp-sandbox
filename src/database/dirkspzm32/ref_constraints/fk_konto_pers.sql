alter table dirkspzm32.pzm_konten
    add constraint fk_konto_pers
        foreign key ( pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"7b608ab7058333594117bcdb18306a2183823080","type":"REF_CONSTRAINT","name":"FK_KONTO_PERS","schemaName":"DIRKSPZM32","sxml":""}