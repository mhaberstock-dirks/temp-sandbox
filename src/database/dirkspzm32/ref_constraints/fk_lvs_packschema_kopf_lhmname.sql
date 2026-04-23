alter table dirkspzm32.lvs_packschema_kopf
    add constraint fk_lvs_packschema_kopf_lhmname
        foreign key ( lhm_name,
                      sid )
            references dirkspzm32.lvs_lhm_cfg ( lhm_name,
                                                sid )
        enable;


-- sqlcl_snapshot {"hash":"3297d64dcff05a35acc4bf7b9459d42b13d05721","type":"REF_CONSTRAINT","name":"FK_LVS_PACKSCHEMA_KOPF_LHMNAME","schemaName":"DIRKSPZM32","sxml":""}