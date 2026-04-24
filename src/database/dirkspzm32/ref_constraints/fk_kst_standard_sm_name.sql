alter table dirkspzm32.isi_kostenstellen
    add constraint fk_kst_standard_sm_name
        foreign key ( kst_standard_sm_name )
            references dirkspzm32.pzm_schicht_modelle ( sm_name )
        enable;


-- sqlcl_snapshot {"hash":"156e987e913a5306d9a9ce9b8645fda629f9e27e","type":"REF_CONSTRAINT","name":"FK_KST_STANDARD_SM_NAME","schemaName":"DIRKSPZM32","sxml":""}