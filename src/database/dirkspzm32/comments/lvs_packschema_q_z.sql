comment on table DIRKSPZM32.LVS_PACKSCHEMA_Q_Z is 'Zum finden des Zielpackschemas um KOMM_ORDER zu füllen bei Paletteeinlagerung und Ziel ist AKL';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_Q_Z."QUELL_PACKSCHEMA_KOPF_ID" is 'Wird von LO in der Tabelle Z_BEL_RCV_LTE_LHM übergeben';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_Q_Z."QUELL_TRANSPORT_EINHEIT" is 'LTE_NAME aus Z_BEL_RCV_LTE_LHM gemapt zu ISI-> LTE_NAME nachschlagen in LVS_LTE_CFG.TRANSPORT_EINHEIT';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_Q_Z."ZIEL_PACKSCHEMA_KOPF_ID" is 'Neues Packschema für Roboter oder Hand-Kommissionierung';



-- sqlcl_snapshot {"hash":"31fc1217b3408096eed6d1ba8fe1515b84f41794","type":"COMMENT","name":"lvs_packschema_q_z","schemaName":"dirkspzm32","sxml":""}