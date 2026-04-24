alter table dirkspzm32.pzm_zeiterfassung
    add constraint fk_ze_pb_id
        foreign key ( ze_pb_id )
            references dirkspzm32.pzm_produktionsbereiche ( pb_id )
        disable;


-- sqlcl_snapshot {"hash":"162fc8d9a0993abdddde0ef785d0b0c82f068694","type":"REF_CONSTRAINT","name":"FK_ZE_PB_ID","schemaName":"DIRKSPZM32","sxml":""}