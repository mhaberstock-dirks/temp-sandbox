comment on table DIRKSPZM32.PPS_ARB_PLAN_AG_FHM is 'Benötigtes Fertigungshilfsmittel zu diesem Arbeitsgang';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."AG_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."AG_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."ANZ_BENOETIGT" is 'wieviele FHMs belegt dieser Vorgang auf einem Fertigungshilfsmittel [Gantt rechnet hier in %] - Die tatsächliche Belegung wird auf ganze Zahlen abgerundet';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."ARB_PLAN_ID" is 'Arbeitsplan, dem dieser AG zugeordnet werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."ARB_PLAN_POS_ID" is 'Eindeutige ID der Position für die Verbindung zur STL';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."FHM" is 'ID Fertigungshilsmittel';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."FHM_GRP" is 'ID Fertigungshilsmittel Gruppe';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."FIRMA_NR" is 'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."SID" is 'Datenbank dieser Firma';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_FHM."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';



-- sqlcl_snapshot {"hash":"ceba6082c576db132e277e7f5bea3774164c4c26","type":"COMMENT","name":"pps_arb_plan_ag_fhm","schemaName":"dirkspzm32","sxml":""}