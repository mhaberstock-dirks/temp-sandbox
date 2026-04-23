alter table dirkspzm32.sec_group_modules
    add constraint fk_sec_gm_group_id
        foreign key ( sid,
                      group_id )
            references dirkspzm32.sec_groups ( sid,
                                               group_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"076a71ef0b5d3092b589a105cce54e30dca64b00","type":"REF_CONSTRAINT","name":"FK_SEC_GM_GROUP_ID","schemaName":"DIRKSPZM32","sxml":""}