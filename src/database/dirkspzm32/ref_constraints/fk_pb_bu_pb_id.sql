alter table dirkspzm32.pzm_produktionsbereiche_bu
    add constraint fk_pb_bu_pb_id
        foreign key ( pb_id )
            references dirkspzm32.pzm_produktionsbereiche ( pb_id )
        enable;


-- sqlcl_snapshot {"hash":"efd7ab01214e00fd58b14bb576767175d6bf9552","type":"REF_CONSTRAINT","name":"FK_PB_BU_PB_ID","schemaName":"DIRKSPZM32","sxml":""}