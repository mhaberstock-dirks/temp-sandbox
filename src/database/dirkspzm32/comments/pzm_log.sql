comment on table DIRKSPZM32.PZM_LOG is 'Log-Tabelle fuer das PZM (Personal-Zeit-Management) Modul';
comment on column DIRKSPZM32.PZM_LOG."AKTION" is 'Buchungs-Aktion: K=Kommen, G=Gehen, P=Pause, D=Dienstgang';
comment on column DIRKSPZM32.PZM_LOG."CLIENT_HOST" is 'Client Hostname';
comment on column DIRKSPZM32.PZM_LOG."CLIENT_IDENTIFIER" is 'Client Identifier (App-spezifisch)';
comment on column DIRKSPZM32.PZM_LOG."CLIENT_INFO" is 'Client Info (provided by executing application)';
comment on column DIRKSPZM32.PZM_LOG."LOG_CATEGORY" is 'Kategorie: Zeiterfassung, Terminal, Tagessatz, Lohnauswertung';
comment on column DIRKSPZM32.PZM_LOG."LOG_ERROR_CODE" is 'Oracle SQLCODE bei Exceptions';
comment on column DIRKSPZM32.PZM_LOG."LOG_ID" is 'Eindeutige Log-ID (Sequenz)';
comment on column DIRKSPZM32.PZM_LOG."LOG_LEVEL" is 'Log-Level: 0=Trace, 1=Debug, 2=Info, 3=Warning, 4=Error, 5=Fatal';
comment on column DIRKSPZM32.PZM_LOG."LOG_MESSAGE" is 'Log-Nachricht';
comment on column DIRKSPZM32.PZM_LOG."LOG_MODULE" is 'Modul/Prozedur die den Log-Eintrag erzeugt hat';
comment on column DIRKSPZM32.PZM_LOG."LOG_STACKTRACE" is 'Oracle Error Backtrace bei Exceptions';
comment on column DIRKSPZM32.PZM_LOG."LOG_TIMESTAMP" is 'Zeitstempel des Log-Eintrags (Millisekunden-Precision)';
comment on column DIRKSPZM32.PZM_LOG."OS_USER" is 'Client OS User (connected to current Oracle Session)';
comment on column DIRKSPZM32.PZM_LOG."PERS_NR" is 'Betroffene Personalnummer (PZM-Kontext)';
comment on column DIRKSPZM32.PZM_LOG."QUELLE" is 'Buchungs-Quelle: LIVE, TERMINAL, MANUELL, SYSTEM';
comment on column DIRKSPZM32.PZM_LOG."SCHICHT_TAG" is 'Betroffener Schichttag (PZM-Kontext)';
comment on column DIRKSPZM32.PZM_LOG."TERMINAL_ID" is 'Terminal-ID bei Terminal-Buchungen';
comment on column DIRKSPZM32.PZM_LOG."ZE_ID" is 'Betroffene Zeiterfassungs-ID (PZM-Kontext)';
comment on column DIRKSPZM32.PZM_LOG."ZE_RFID" is 'Verwendete RFID/Transponder (PZM-Kontext)';



-- sqlcl_snapshot {"hash":"b20e25c10316794198010b967fc5adc3abb2ba2c","type":"COMMENT","name":"pzm_log","schemaName":"dirkspzm32","sxml":""}