comment on table dirkspzm32.lvs_packschema_q_z is
    'Zum finden des Zielpackschemas um KOMM_ORDER zu füllen bei Paletteeinlagerung und Ziel ist AKL';

comment on column dirkspzm32.lvs_packschema_q_z.quell_packschema_kopf_id is
    'Wird von LO in der Tabelle Z_BEL_RCV_LTE_LHM übergeben';

comment on column dirkspzm32.lvs_packschema_q_z.quell_transport_einheit is
    'LTE_NAME aus Z_BEL_RCV_LTE_LHM gemapt zu ISI-> LTE_NAME nachschlagen in LVS_LTE_CFG.TRANSPORT_EINHEIT';

comment on column dirkspzm32.lvs_packschema_q_z.ziel_packschema_kopf_id is
    'Neues Packschema für Roboter oder Hand-Kommissionierung';


-- sqlcl_snapshot {"hash":"16526158e55bd2ddb84c883333fc5699f2659dbb","type":"COMMENT","name":"lvs_packschema_q_z","schemaName":"dirkspzm32","sxml":""}