alter table dirkspzm32.isi_hersteller
    add constraint fk_isi_hersteller_adr
        foreign key ( adress_id )
            references dirkspzm32.isi_adressen ( adress_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"3d970ecb34d2a44c81481f46d95e7b372c14aad1","type":"REF_CONSTRAINT","name":"FK_ISI_HERSTELLER_ADR","schemaName":"DIRKSPZM32","sxml":""}