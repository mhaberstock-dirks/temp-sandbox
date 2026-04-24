alter table dirkspzm32.isi_artikel_hersteller
    add constraint fk_isi_artikel_hersteller_adr
        foreign key ( adress_id )
            references dirkspzm32.isi_adressen ( adress_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"1a539d34d0f071a6320c2e412f92379ab0716800","type":"REF_CONSTRAINT","name":"FK_ISI_ARTIKEL_HERSTELLER_ADR","schemaName":"DIRKSPZM32","sxml":""}