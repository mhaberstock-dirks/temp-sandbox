alter table dirkspzm32.isi_land_region
    add constraint fk_country
        foreign key ( country )
            references dirkspzm32.isi_land ( isocode )
        enable;


-- sqlcl_snapshot {"hash":"b7d29ac5cdb08f5eb1d45ef3d4ac2fa78e8525c3","type":"REF_CONSTRAINT","name":"FK_COUNTRY","schemaName":"DIRKSPZM32","sxml":""}