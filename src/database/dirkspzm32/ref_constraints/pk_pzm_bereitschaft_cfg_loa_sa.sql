alter table dirkspzm32.pzm_bereitschaft_cfg
    add constraint pk_pzm_bereitschaft_cfg_loa_sa
        foreign key ( loa_id_sa )
            references dirkspzm32.pzm_lohnarten ( lz_id )
        enable;


-- sqlcl_snapshot {"hash":"d2f73c6a33ea41ba0c3dab30b8cf83188afdf4d2","type":"REF_CONSTRAINT","name":"PK_PZM_BEREITSCHAFT_CFG_LOA_SA","schemaName":"DIRKSPZM32","sxml":""}