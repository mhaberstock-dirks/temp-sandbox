comment on table MELDUNG_STATISTIK is 'Statistik Fehlermeldungen aus meldungen_daten und Meldungs_cfg';
comment on column MELDUNG_STATISTIK."BEREICH" is '--> Meldung_CFG.Name';
comment on column MELDUNG_STATISTIK."CREATED_DATE" is 'Erstellungsdatum';
comment on column MELDUNG_STATISTIK."CREATED_LOGIN_ID" is 'Ersteller ID';
comment on column MELDUNG_STATISTIK."ENGINE_ID" is 'Welcher Server benutzt diese Daten';
comment on column MELDUNG_STATISTIK."FIRMA_NR" is 'FIRMA_NR';
comment on column MELDUNG_STATISTIK."GRUPPE" is 'Verweis auf --> MELDUNG_CFG.FEHLER_TEXT_GRUPPE';
comment on column MELDUNG_STATISTIK."LAST_CHANGE_DATE" is 'Änderungsdatum';
comment on column MELDUNG_STATISTIK."LAST_CHANGE_LOGIN_ID" is 'ID der den Datensatz geändert hat';
comment on column MELDUNG_STATISTIK."MS_BEGIN" is 'Begin des Störung';
comment on column MELDUNG_STATISTIK."MS_COUNT" is 'Anzahl der Einzelmeldungen';
comment on column MELDUNG_STATISTIK."MS_ENDE" is 'Ende des Störung';
comment on column MELDUNG_STATISTIK."MS_MINUTEN" is 'Störzeit in Minuten';
comment on column MELDUNG_STATISTIK."MS_TEXTE" is 'Text / Beschreibung aus Meldungen_Daten und Text';
comment on column MELDUNG_STATISTIK."SID" is 'SID';



-- sqlcl_snapshot {"hash":"134cdb4dac12c5a6fe6dcf2fb8e615f5a62f790f","type":"COMMENT","name":"meldung_statistik","schemaName":"dirkspzm32","sxml":""}