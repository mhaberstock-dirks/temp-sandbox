alter table dirkspzm32.rep_security_cfg
    add constraint fk3_rep_security_cfg
        foreign key ( rep_id )
            references dirkspzm32.rep_abfragen ( rep_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"c8776f22218bc69b0ea3aa5158e2c90f891ff44a","type":"REF_CONSTRAINT","name":"FK3_REP_SECURITY_CFG","schemaName":"DIRKSPZM32","sxml":""}