comment on table DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES is 'Vorgänger Nachfolger Relation für diesen FA';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."AG_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."AG_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."ARB_PLAN_ID" is 'Arbeitsplan, dem dieser AG zugeordnet werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."ARB_PLAN_POS_ID" is 'Eindeutige ID der Position für die Verbindung zur STL';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."DELTA" is 'Prozentualer Ressourcenkostenaufschlag, sofern diese Alternative verwendet wird.
Es kann ein beliebiger Wert eingestellt werden, auch negativ. Für die endgültige Entscheidung werden dann weiterhin Verspätungskosten, Stillstandskosten,
FHM-Prioritäten usw. hinzugezogen. Darauf hat das Delta keinen Einfluss mehr. Auf die finale Bewertung der Kosten für das Ergebnis, Reports usw. hat das Delta
auch keinen Einfluss.
0% = alle alternativen Arbeitsplätze sind gleichwertig';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."FIRMA_NR" is 'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."LOT_SIZE_MAX" is 'maximale vorgangsspezifische Losgröße, die Angabe erfolgt in der Losgrößen-Einheit laut Arbeitsplatz-Stamm (lot_size_unit_id)
-1 = Vorgabe aus Arbeitsplatz-Stamm gilt';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."LOT_SIZE_MIN" is 'minimale vorgangsspezifische Losgröße, die Angabe erfolgt in der Losgrößen-Einheit laut Arbeitsplatz-Stamm (lot_size_unit_id)
-1 = Vorgabe aus Arbeitsplatz-Stamm gilt';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."RES_ID" is 'ID der Maschine / Arbeitsplatz';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."SID" is 'Datenbank dieser Firma';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_RES."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';



-- sqlcl_snapshot {"hash":"e4708ecd2c575198f1b7bf2d7267d843124c6b1f","type":"COMMENT","name":"pps_arb_plan_ag_op_res","schemaName":"dirkspzm32","sxml":""}