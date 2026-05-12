alter table dirkspzm32.pzm_produktionsbereiche_bu
    add constraint fk_pb_bu_pb_id
        foreign key ( pb_id )
            references dirkspzm32.pzm_produktionsbereiche ( pb_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"2a31a86c1f81309c9f304715dec3d65623f26936","type":"REF_CONSTRAINT","name":"FK_PB_BU_PB_ID","schemaName":"DIRKSPZM32","sxml":""}