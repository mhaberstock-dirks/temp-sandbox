comment on table LVS_PACKSCHEMA_Q_Z is 'Zum finden des Zielpackschemas um KOMM_ORDER zu füllen bei Paletteeinlagerung und Ziel ist AKL';
comment on column LVS_PACKSCHEMA_Q_Z."QUELL_PACKSCHEMA_KOPF_ID" is 'Wird von LO in der Tabelle Z_BEL_RCV_LTE_LHM übergeben';
comment on column LVS_PACKSCHEMA_Q_Z."QUELL_TRANSPORT_EINHEIT" is 'LTE_NAME aus Z_BEL_RCV_LTE_LHM gemapt zu ISI-> LTE_NAME nachschlagen in LVS_LTE_CFG.TRANSPORT_EINHEIT';
comment on column LVS_PACKSCHEMA_Q_Z."ZIEL_PACKSCHEMA_KOPF_ID" is 'Neues Packschema für Roboter oder Hand-Kommissionierung';



-- sqlcl_snapshot {"hash":"c39f194d6088a0e07c70ab62b995ce31e2bf6184","type":"COMMENT","name":"lvs_packschema_q_z","schemaName":"dirkspzm32","sxml":""}