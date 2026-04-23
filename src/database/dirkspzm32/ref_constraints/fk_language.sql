alter table dirkspzm32.isi_land_sprache
    add constraint fk_language
        foreign key ( lang_id )
            references dirkspzm32.isi_language ( lang_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"67aa09c6942cb36c0f65b10b6c626dc69e3bf535","type":"REF_CONSTRAINT","name":"FK_LANGUAGE","schemaName":"DIRKSPZM32","sxml":""}