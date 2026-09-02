comment on table ISI_RES_LEISTUNG_CFG is 'Leistungsparameter und Daten von Resourcen';
comment on column ISI_RES_LEISTUNG_CFG."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column ISI_RES_LEISTUNG_CFG."PARAM_ERHEBUNG" is '''A'' Automatisch, ''B'' Berechnet, ''E'' Erfasst';
comment on column ISI_RES_LEISTUNG_CFG."PARAM_MENGE" is 'Menge ';
comment on column ISI_RES_LEISTUNG_CFG."PARAM_MENGE_EINH" is 'Mengeneinheit';
comment on column ISI_RES_LEISTUNG_CFG."PARAM_NAME" is 'z.B. STK_MIN, DURCH_STK_TAG, STD_TAG';
comment on column ISI_RES_LEISTUNG_CFG."PARAM_ZEIT" is 'Zeitraum für die Menge';
comment on column ISI_RES_LEISTUNG_CFG."PARAM_ZEIT_EINH" is 'z.B. MI Minute, D Tag, M Monat, Y Jahr (Like Oracle Date)';
comment on column ISI_RES_LEISTUNG_CFG."RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk';
comment on column ISI_RES_LEISTUNG_CFG."RES_L_CFG_ID" is 'Eindeutige ID als PK aus Seq.';
comment on column ISI_RES_LEISTUNG_CFG."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"6354fdd5fc1fc37da10ac52006780c1f2cf9dd34","type":"COMMENT","name":"isi_res_leistung_cfg","schemaName":"dirkspzm32","sxml":""}