alter table dirkspzm32.pzm_bereitschaft_cfg
    add constraint pk_pzm_bereitschaft_cfg_loa
        foreign key ( loa_id )
            references dirkspzm32.pzm_lohnarten ( lz_id )
        enable;


-- sqlcl_snapshot {"hash":"256ff470d85cd3a80d76ef42ac49200954c135eb","type":"REF_CONSTRAINT","name":"PK_PZM_BEREITSCHAFT_CFG_LOA","schemaName":"DIRKSPZM32","sxml":""}