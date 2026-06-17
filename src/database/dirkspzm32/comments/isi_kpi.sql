comment on table DIRKSPZM32.ISI_KPI is 'Abbildung KPIs in Tabelle für Dashboards oder reports';
comment on column DIRKSPZM32.ISI_KPI."CREATED_DATE" is 'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';
comment on column DIRKSPZM32.ISI_KPI."CREATED_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz erstellt hat';
comment on column DIRKSPZM32.ISI_KPI."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_KPI."ISI_KPI_ID" is 'Unique Identifier R4-DAL';
comment on column DIRKSPZM32.ISI_KPI."KPI_NAME" is 'Name als Refenz zur Anzeigeposition im Dashboard ';
comment on column DIRKSPZM32.ISI_KPI."KPI_SEL_PARAM" is 'Selektionsparameter um eine KPI für bestimmte Filggf. Kundenspezifisch einzutragen';
comment on column DIRKSPZM32.ISI_KPI."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.ISI_KPI."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.ISI_KPI."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_KPI."WERT_DATUM" is 'Wert Datum nicht verwechseln mit Erfasst_am';
comment on column DIRKSPZM32.ISI_KPI."WERT_INTERVALL_DATUM" is 'Wenn gesetzt, dann wird dieses datum immer als Grundlage für die Berechnung der nächsten aktualisierung genutzt. Sonst wied immr das Wertdatum + WERT_INTERVALL_SEK zur Berechnung genutzt.';
comment on column DIRKSPZM32.ISI_KPI."WERT_INTERVALL_NEXT" is 'Hier steht der nächste Aktualisierungszeitpunkt. Wenn leer, dann sofort';
comment on column DIRKSPZM32.ISI_KPI."WERT_INTERVALL_SEK" is 'Intervall für die aktualisierung in Sekunden';
comment on column DIRKSPZM32.ISI_KPI."WERT_KPI_AKTUELL" is 'Wert der Kennzahl aktuell';
comment on column DIRKSPZM32.ISI_KPI."WERT_KPI_LETZTER" is 'Wert der aktuellen Kennzahl letzter nach Update';



-- sqlcl_snapshot {"hash":"5ee3a8c8f6e0e119956ee47bcc72a46e557f1253","type":"COMMENT","name":"isi_kpi","schemaName":"dirkspzm32","sxml":""}