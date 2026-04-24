alter table dirkspzm32.pzm_zeiterfassung
    add constraint fk_ze_abt_id
        foreign key ( ze_abt_id )
            references dirkspzm32.pzm_abteilungen ( abt_id )
        disable;


-- sqlcl_snapshot {"hash":"f904c8c1fbf3d3816ac046aef7bb5cc07a9d151f","type":"REF_CONSTRAINT","name":"FK_ZE_ABT_ID","schemaName":"DIRKSPZM32","sxml":""}