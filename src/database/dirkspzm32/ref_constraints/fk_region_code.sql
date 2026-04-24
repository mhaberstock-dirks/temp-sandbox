alter table dirkspzm32.isi_adressen
    add constraint fk_region_code
        foreign key ( region_code )
            references dirkspzm32.isi_land_region ( code )
        enable;


-- sqlcl_snapshot {"hash":"51dfc1fe4f287d3c108ed2fb759169435981f3fa","type":"REF_CONSTRAINT","name":"FK_REGION_CODE","schemaName":"DIRKSPZM32","sxml":""}