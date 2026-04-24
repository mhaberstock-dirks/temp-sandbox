alter table dirkspzm32.pzm_personal
    add constraint fk_pers_pb_id
        foreign key ( pers_pb_id )
            references dirkspzm32.pzm_produktionsbereiche ( pb_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"4efecc40aa013189d205caadc5128fc0b7805e4e","type":"REF_CONSTRAINT","name":"FK_PERS_PB_ID","schemaName":"DIRKSPZM32","sxml":""}