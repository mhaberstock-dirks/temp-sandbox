alter table dirkspzm32.isi_arbeitsplatz
    add constraint fk_arbeitsplatz_adresse
        foreign key ( adress_id )
            references dirkspzm32.isi_adressen ( adress_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"3e9b066763cfc152fb2740582b5b5724787257d8","type":"REF_CONSTRAINT","name":"FK_ARBEITSPLATZ_ADRESSE","schemaName":"DIRKSPZM32","sxml":""}