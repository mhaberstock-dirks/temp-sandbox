alter table dirkspzm32.pzm_bereitschaft_cfg
    add constraint pk_pzm_bereitschaft_cfg_loa_so
        foreign key ( loa_id_so )
            references dirkspzm32.pzm_lohnarten ( lz_id )
        enable;


-- sqlcl_snapshot {"hash":"067ea0399826d7fb86da82e66d17e4fa2be04fdd","type":"REF_CONSTRAINT","name":"PK_PZM_BEREITSCHAFT_CFG_LOA_SO","schemaName":"DIRKSPZM32","sxml":""}