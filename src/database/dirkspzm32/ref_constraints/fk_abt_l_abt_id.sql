alter table dirkspzm32.pzm_abt_leitung
    add constraint fk_abt_l_abt_id
        foreign key ( abt_l_abt_id )
            references dirkspzm32.pzm_abteilungen ( abt_id )
                on delete cascade
        disable;


-- sqlcl_snapshot {"hash":"b7457ea8ba00253e0a363fb944563e00cfbfc942","type":"REF_CONSTRAINT","name":"FK_ABT_L_ABT_ID","schemaName":"DIRKSPZM32","sxml":""}