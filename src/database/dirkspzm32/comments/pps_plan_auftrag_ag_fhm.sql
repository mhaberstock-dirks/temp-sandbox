comment on table PPS_PLAN_AUFTRAG_AG_FHM is 'Fertigungshilfsmittel-Liste für diesen AG im Planauftrag';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."AG_UPOS" is 'Unterposition / Alternative für das FHM im Arbeitsgang';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."CREATED_DATE" is 'creation date+time of this dataset';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."FIRMA_NR" is 'Firma Nr.';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."PLAN_AUF_AG_ID" is 'Eindeutige Nummer aus SEQ';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."PLAN_AUF_ID" is 'Auftragsnummer aus PPS_PLAN_AUFTRAG';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."PROD_FHM" is 'Benötigtes FHM';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."SID" is 'SID';
comment on column PPS_PLAN_AUFTRAG_AG_FHM."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';



-- sqlcl_snapshot {"hash":"9f2eb273f4c2a5df1c665cbbdf654efc27f4388f","type":"COMMENT","name":"pps_plan_auftrag_ag_fhm","schemaName":"dirkspzm32","sxml":""}