alter table dirkspzm32.pzm_abteilungen
    add constraint fk_abt_pb_id
        foreign key ( abt_pb_id )
            references dirkspzm32.pzm_produktionsbereiche ( pb_id )
        disable;


-- sqlcl_snapshot {"hash":"1575f83e66a80853898d0f68a1300f6070aba19a","type":"REF_CONSTRAINT","name":"FK_ABT_PB_ID","schemaName":"DIRKSPZM32","sxml":""}