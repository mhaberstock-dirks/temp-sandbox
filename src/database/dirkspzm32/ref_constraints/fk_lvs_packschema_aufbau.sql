alter table dirkspzm32.lvs_packschema_aufbau
    add constraint fk_lvs_packschema_aufbau
        foreign key ( packschema_kopf_id,
                      firma_nr,
                      sid )
            references dirkspzm32.lvs_packschema_kopf ( packschema_kopf_id,
                                                        firma_nr,
                                                        sid )
        enable;


-- sqlcl_snapshot {"hash":"91611085c1cd1bc605d014a21f547052c8b0ba42","type":"REF_CONSTRAINT","name":"FK_LVS_PACKSCHEMA_AUFBAU","schemaName":"DIRKSPZM32","sxml":""}