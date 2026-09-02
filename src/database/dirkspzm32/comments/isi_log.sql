comment on table ISI_LOG is 'Logtabelle für ISIPlus systemmeldungen';
comment on column ISI_LOG."FIRMA_NR" is 'Firmennummer';
comment on column ISI_LOG."LOG_CATEGORY" is 'Kategorie';
comment on column ISI_LOG."LOG_COMPUTER" is 'TCP/IP Adresse des Computers der die Meldung ausgelöst hat';
comment on column ISI_LOG."LOG_DETAILS" is 'Fehlermeldung (Exception)';
comment on column ISI_LOG."LOG_ERROR_CODE" is 'Fehlernummer';
comment on column ISI_LOG."LOG_ID" is 'ID des Eintrags';
comment on column ISI_LOG."LOG_LEVEL" is 'Loglevel';
comment on column ISI_LOG."LOG_MODUL" is 'ISIPlus Modulname';
comment on column ISI_LOG."LOG_MSG_COUNT" is 'Anzahl LOG''s diese Meldungen in der letzten Minute ';
comment on column ISI_LOG."LOG_PROGRAMM" is 'Programmname des Programms';
comment on column ISI_LOG."LOG_STATUS" is 'WQ = Warte auf Quittierung, Q = Quittiert';
comment on column ISI_LOG."LOG_TIME" is 'Log Zeitpunkt';
comment on column ISI_LOG."LOG_TYP" is 'I = Info, W = Warning, E = Error/Exception';
comment on column ISI_LOG."SID" is 'SID';



-- sqlcl_snapshot {"hash":"eb15dc1c43a3acc834ec3fdc57766b2f60a5338c","type":"COMMENT","name":"isi_log","schemaName":"dirkspzm32","sxml":""}