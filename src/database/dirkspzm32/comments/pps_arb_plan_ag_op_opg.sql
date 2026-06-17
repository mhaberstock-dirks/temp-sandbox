comment on table DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG is 'Optimierungen - Gruppe Realation';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."AG_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."AG_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."ARB_PLAN_ID" is 'Arbeitsplan, dem dieser AG zugeordnet werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."ARB_PLAN_POS_ID" is 'Eindeutige ID der Position für die Verbindung zur STL';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."FIRMA_NR" is 'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."OPTIMIERUNGSGRUPPEN_ID" is 'ID der Optimierungsgruppe
Wenn ID leer ist, dann gilt keine Optimierungsgruppe (auch nicht die aus dem Materialstamm)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."OPTIMIERUNGSGRUPPEN_TYP" is 'gibt an, welche Optimierungen von dieser Gruppe abhängen
Optimierungsgruppentyp
Wert Bezeichnung Beschreibung
1 statisch rüsten Statische Rüstpositionen werden bei gleicher Optimierungsgruppe reduziert.
2 dynamisch rüsten Dynamische Rüstpositionen werden entsprechend der Umrüstmatrix reduziert.
4 parallele Belegung Aufträge werden parallel auf eine Ressource geplant.
jeder Typ darf nur einmal pro Vorgang verwendet werden';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."OPTIMIERUNGSGRUPPEN_VALUE" is 'wertmäßige Ausprägung der Optimierungsgruppe
Das Merkmal darf nur entsprechend der Angabe in der Optimierungsgruppe maximal abweichen (Toleranz), damit gleiche Optimierungsgruppen zueinander
als kompatibel gelten. (Bei Kompatibilität würde z.B. die eingestellte Dauer aus der Diagonalen der Rüstmatrix nicht verwendet werden)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."SID" is 'Datenbank dieser Firma';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_OP_OPG."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';



-- sqlcl_snapshot {"hash":"011cc5dc2b5842581b16ed2a467deace5a023e77","type":"COMMENT","name":"pps_arb_plan_ag_op_opg","schemaName":"dirkspzm32","sxml":""}