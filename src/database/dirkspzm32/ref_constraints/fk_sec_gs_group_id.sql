alter table dirkspzm32.sec_group_sections
    add constraint fk_sec_gs_group_id
        foreign key ( sid,
                      group_id )
            references dirkspzm32.sec_groups ( sid,
                                               group_id )
        enable;


-- sqlcl_snapshot {"hash":"e4bbabb567d3c7a4a735d6d961a1229f89f0c0d9","type":"REF_CONSTRAINT","name":"FK_SEC_GS_GROUP_ID","schemaName":"DIRKSPZM32","sxml":""}