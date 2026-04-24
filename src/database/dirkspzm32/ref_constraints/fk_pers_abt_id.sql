alter table dirkspzm32.pzm_personal
    add constraint fk_pers_abt_id
        foreign key ( pers_abt_id )
            references dirkspzm32.pzm_abteilungen ( abt_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"43efa0fbf30adf5ad167cb00fd4a74131504f56c","type":"REF_CONSTRAINT","name":"FK_PERS_ABT_ID","schemaName":"DIRKSPZM32","sxml":""}