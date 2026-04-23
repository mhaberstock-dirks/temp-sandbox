alter table dirkspzm32.pzm_schicht_perioden
    add constraint fk_sp_sm_name
        foreign key ( sp_sm_name )
            references dirkspzm32.pzm_schicht_modelle ( sm_name )
        disable;


-- sqlcl_snapshot {"hash":"dee8124ffd4e999b1a869b4097f4a00d85b02f57","type":"REF_CONSTRAINT","name":"FK_SP_SM_NAME","schemaName":"DIRKSPZM32","sxml":""}