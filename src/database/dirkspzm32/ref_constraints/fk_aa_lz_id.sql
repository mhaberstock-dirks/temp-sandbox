alter table dirkspzm32.pzm_abwesenheitsarten
    add constraint fk_aa_lz_id
        foreign key ( lz_id )
            references dirkspzm32.pzm_lohnarten ( lz_id )
                on delete set null
        disable;


-- sqlcl_snapshot {"hash":"018e014cc84ca314250d0d679cc48467ce976505","type":"REF_CONSTRAINT","name":"FK_AA_LZ_ID","schemaName":"DIRKSPZM32","sxml":""}