comment on column DIRKSPZM32.ISI_ALERT_CFG."ALERT_AKTIV" is '''T'' = Alert Ein;   ''F'' = Alert Aus ''M'' = Manuell';
comment on column DIRKSPZM32.ISI_ALERT_CFG."ALERT_CFG_NAME" is 'Unique Name';
comment on column DIRKSPZM32.ISI_ALERT_CFG."ALERT_DATUM" is 'Datum des Alert';
comment on column DIRKSPZM32.ISI_ALERT_CFG."ALERT_FILTER" is 'Filter z.B. "QUALITÄT;" es werden nur die Meldungen herangezogen die diesem Filter entsprechen siehe auch MELDUNG_TEXT.FILTER_MASK';
comment on column DIRKSPZM32.ISI_ALERT_CFG."ALERT_INTERVALL" is 'Intervall in Sekunden ';
comment on column DIRKSPZM32.ISI_ALERT_CFG."ALERT_STATUS" is '''T'' = Alert Aktiv;   ''F'' = Alert Aus ''-'' = unbekannt';
comment on column DIRKSPZM32.ISI_ALERT_CFG."ALERT_TYP" is '''R'' Resourcen Alert, ''M'' Meldungen Alert .... ''S'' ServiceLogik Alert';
comment on column DIRKSPZM32.ISI_ALERT_CFG."MAIL_ADDRESS" is 'Mail Adresse';
comment on column DIRKSPZM32.ISI_ALERT_CFG."RES_ID" is '--> ISI_RESOURCE Resourcen_id der parent_id, Linien_res_id';
comment on column DIRKSPZM32.ISI_ALERT_CFG."TEMPLATE_KOPF" is 'Vorlage Meldung Allgemein';
comment on column DIRKSPZM32.ISI_ALERT_CFG."TEMPLATE_MELD_GEHT" is 'Vorlage Meldung gegangen';
comment on column DIRKSPZM32.ISI_ALERT_CFG."TEMPLATE_MELD_KOMMT" is 'Vorlage Meldung Aktiv';



-- sqlcl_snapshot {"hash":"4218b70640622fc3bf6c5187e2c31b5f66b67b98","type":"COMMENT","name":"isi_alert_cfg","schemaName":"dirkspzm32","sxml":""}