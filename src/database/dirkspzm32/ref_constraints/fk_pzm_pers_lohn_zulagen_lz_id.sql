alter table dirkspzm32.pzm_pers_lohn_zulagen
    add constraint fk_pzm_pers_lohn_zulagen_lz_id
        foreign key ( lz_id )
            references dirkspzm32.pzm_lohnarten ( lz_id )
                on delete cascade
        disable;


-- sqlcl_snapshot {"hash":"fb04c73f82ffad58df60225be3bb532bcc8e8a36","type":"REF_CONSTRAINT","name":"FK_PZM_PERS_LOHN_ZULAGEN_LZ_ID","schemaName":"DIRKSPZM32","sxml":""}