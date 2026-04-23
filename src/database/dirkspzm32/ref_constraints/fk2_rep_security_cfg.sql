alter table dirkspzm32.rep_security_cfg
    add constraint fk2_rep_security_cfg
        foreign key ( login_id )
            references dirkspzm32.isi_user ( login_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"e640040ab59638413e7192b4b1897cb1faecedce","type":"REF_CONSTRAINT","name":"FK2_REP_SECURITY_CFG","schemaName":"DIRKSPZM32","sxml":""}