alter table dirkspzm32.isi_land_sprache
    add constraint fk_region
        foreign key ( region_id )
            references dirkspzm32.isi_land_region ( region_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"486998399915ff52de2ca6229d98167be2b85ffe","type":"REF_CONSTRAINT","name":"FK_REGION","schemaName":"DIRKSPZM32","sxml":""}