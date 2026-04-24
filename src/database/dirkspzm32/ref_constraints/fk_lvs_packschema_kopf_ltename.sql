alter table dirkspzm32.lvs_packschema_kopf
    add constraint fk_lvs_packschema_kopf_ltename
        foreign key ( lte_name,
                      sid )
            references dirkspzm32.lvs_lte_cfg ( lte_name,
                                                sid )
        enable;


-- sqlcl_snapshot {"hash":"d9c160b8a93b8c93c59e2c8274e8b6ed2a0d1ed8","type":"REF_CONSTRAINT","name":"FK_LVS_PACKSCHEMA_KOPF_LTENAME","schemaName":"DIRKSPZM32","sxml":""}