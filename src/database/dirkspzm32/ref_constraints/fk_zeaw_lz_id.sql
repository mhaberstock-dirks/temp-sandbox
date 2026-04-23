alter table dirkspzm32.pzm_ze_loa_ausw
    add constraint fk_zeaw_lz_id
        foreign key ( zeaw_lz_id )
            references dirkspzm32.pzm_lohnarten ( lz_id )
        enable;


-- sqlcl_snapshot {"hash":"2588cfe5a3378475d399f1c17839d11e01d70ccc","type":"REF_CONSTRAINT","name":"FK_ZEAW_LZ_ID","schemaName":"DIRKSPZM32","sxml":""}