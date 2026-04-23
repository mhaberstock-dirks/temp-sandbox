alter table dirkspzm32.lvs_packschema_pos
    add constraint fk_lvs_packschema_pos
        foreign key ( packschema_kopf_id,
                      firma_nr,
                      sid )
            references dirkspzm32.lvs_packschema_kopf ( packschema_kopf_id,
                                                        firma_nr,
                                                        sid )
        enable;


-- sqlcl_snapshot {"hash":"fe2f5660b162085fa1e60119caa331338d269788","type":"REF_CONSTRAINT","name":"FK_LVS_PACKSCHEMA_POS","schemaName":"DIRKSPZM32","sxml":""}