alter table dirkspzm32.pzm_produktionsbereiche
    add constraint fk_pb_personal_abt_id
        foreign key ( pb_personal_abt_id )
            references dirkspzm32.pzm_abteilungen ( abt_id )
        disable;


-- sqlcl_snapshot {"hash":"e60ffd59756d2deb84f798b954ea298cbce099f4","type":"REF_CONSTRAINT","name":"FK_PB_PERSONAL_ABT_ID","schemaName":"DIRKSPZM32","sxml":""}