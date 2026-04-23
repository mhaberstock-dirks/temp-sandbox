alter table dirkspzm32.sec_group_actions
    add constraint fk_sec_ga_group_id
        foreign key ( sid,
                      group_id )
            references dirkspzm32.sec_groups ( sid,
                                               group_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"b6cf275d570c61cd524d0eb66dcc68c84d0cb721","type":"REF_CONSTRAINT","name":"FK_SEC_GA_GROUP_ID","schemaName":"DIRKSPZM32","sxml":""}