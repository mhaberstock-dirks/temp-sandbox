alter table dirkspzm32.pzm_bereitschaft_cfg
    add constraint pk_pzm_bereitschaft_cfg_loa_fe
        foreign key ( loa_id_fe )
            references dirkspzm32.pzm_lohnarten ( lz_id )
        enable;


-- sqlcl_snapshot {"hash":"91d39c838fbdfcfbeae55061ba461de75d5e9ccb","type":"REF_CONSTRAINT","name":"PK_PZM_BEREITSCHAFT_CFG_LOA_FE","schemaName":"DIRKSPZM32","sxml":""}