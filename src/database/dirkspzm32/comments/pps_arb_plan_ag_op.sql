comment on table DIRKSPZM32.PPS_ARB_PLAN_AG_OP is 'Vorgänger Nachfolger Relation für diesen FA';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."AG_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."AG_O_NAME1" is 'Bezeichnung (Klartext)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."AG_O_NAME2" is 'Bezeichnung (Klartext) discription';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."AG_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."ARB_PLAN_ID" is 'Arbeitsplan, dem dieser AG zugeordnet werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."ARB_PLAN_POS_ID" is 'Eindeutige ID der Position für die Verbindung zur STL';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."INFO1" is 'Zusatztext für die Beschreibung';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."INFO2" is 'Zusatztext für die Beschreibung';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."INFO3" is 'Zusatztext für die Beschreibung';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."SID" is 'SID';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."SPLIT_MAX" is 'Anzal der maximalen Sprints 0 = Keiner erlaubt';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."SPLIT_MIN" is 'Anzal minimal Sprints 0 = Keiner erlaubt';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."VORGANGSQUALIFIKATION" is 'optionale Vorgangsqualifikation (Sonder- oder auch Tätigkeitsqualifikation), die das Personal zur Bedienung des Vorgangs benötigt';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP."VORGANGSTYP" is '1 Standard Standard Arbeitsplan-Vorgang
3 Alternativ Alternativer Arbeitsplan-Vorgang kann anstelle des zugehörigen Standard Arbeitsplan-Vorgangs geplant werden. Alternative
Vorgänge können nicht gleichzeitig mit Splits verwendet werden.';



-- sqlcl_snapshot {"hash":"b351415b0a7fc89881141fa4fa418b99ed2fd46e","type":"COMMENT","name":"pps_arb_plan_ag_op","schemaName":"dirkspzm32","sxml":""}