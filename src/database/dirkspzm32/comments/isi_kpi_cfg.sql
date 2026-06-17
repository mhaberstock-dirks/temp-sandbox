comment on table DIRKSPZM32.ISI_KPI_CFG is 'Abbildung KPIs in Tabelle zur verwaltung der Quelle (z.B. SQL)';
comment on column DIRKSPZM32.ISI_KPI_CFG."CREATED_DATE" is 'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';
comment on column DIRKSPZM32.ISI_KPI_CFG."CREATED_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz erstellt hat';
comment on column DIRKSPZM32.ISI_KPI_CFG."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_KPI_CFG."KPI_BESCHREIBUNG" is 'Beschreibung der Kennzahl. Was sagt die Kennzahl aus (DOKU)';
comment on column DIRKSPZM32.ISI_KPI_CFG."KPI_NAME" is 'Name als Refenz zur Anzeigeposition im Dashboard ';
comment on column DIRKSPZM32.ISI_KPI_CFG."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.ISI_KPI_CFG."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.ISI_KPI_CFG."SCHWELL_WERT_GELB" is 'Wert, ab wann der Wert nur noch OK ist (Gelb). Wenn schlechter dann Rot
Wenn Schwellwertgün > Schwllwertgelb,
dann ist alles ab dem Schwellwert und größer gruen,
sonst ist alles ab dem Schwellwert und kleiner gruen

Beispiel:
OEE in % SCHWELL_WERT_GRUEN > SCHWELL_WERT_GELB
 SCHWELL_WERT_GRUEN = 95
 SCHWELL_WERT_GELB = 85
 Gut Gruen >= 95
 OK Gelb >= 85
 Schlecht Rot < 85
 OEE >= 95% dann Gruen da GUT
bei Ausschus in % SCHWELL_WERT_GRUEN < SCHWELL_WERT_GELB
 SCHWELL_WERT_GRUEN = 3
 SCHWELL_WERT_GELB = 5
 Gut Gruen <= 3
 OK Gelb <= 5
 Schlecht Rot > 5
 Ausschuss %3 dann Gruen da GUT
 Ausschuss %3,1 dann Gelb da noch OK
 Ausschuss %5,1 dann Rot da Ausschuss zu hoch
';
comment on column DIRKSPZM32.ISI_KPI_CFG."SCHWELL_WERT_GRUEN" is 'Wert, ab wann der Wert gut ist (Gruen).
Wenn Schwellwertgün > Schwllwertgelb,
dann ist alles ab dem Schwellwert und größer gruen,
sonst ist alles ab dem Schwellwert und kleiner gruen

Beispiel:
OEE in % SCHWELL_WERT_GRUEN > SCHWELL_WERT_GELB
 SCHWELL_WERT_GRUEN = 95
 SCHWELL_WERT_GELB = 85
 Gut Gruen >= 95
 OK Gelb >= 85
 Schlecht Rot < 85
 OEE >= 95% dann Gruen da GUT
bei Ausschus in % SCHWELL_WERT_GRUEN < SCHWELL_WERT_GELB
 SCHWELL_WERT_GRUEN = 3
 SCHWELL_WERT_GELB = 5
 Gut Gruen <= 3
 OK Gelb <= 5
 Schlecht Rot > 5
 Ausschuss %3 dann Gruen da GUT
 Ausschuss %3,1 dann Gelb da noch OK
 Ausschuss %5,1 dann Rot da Ausschuss zu hoch
';
comment on column DIRKSPZM32.ISI_KPI_CFG."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_KPI_CFG."TEXT_KPI" is 'Text Überschrift für die Kennzahl.  Kann auch eine NLS_KEY sein.';
comment on column DIRKSPZM32.ISI_KPI_CFG."WERT_PARAMS" is 'Parameter die zus. gefüllt werden sollen';
comment on column DIRKSPZM32.ISI_KPI_CFG."WERT_QUELLE" is 'DAL oder SQL für die gewinnung der Daten. Wenn leer, dann müssen die Datengewinnung in der Service-Logik programmiert werden. Wenn etwas in der Logik programmiert ist, dann hat das immer Vorang';
comment on column DIRKSPZM32.ISI_KPI_CFG."WERT_QUELLE_TYP" is 'Typ der Quelle SQL = SQL-Abfrage, MSG = Nachrichten, ...';



-- sqlcl_snapshot {"hash":"d35c3df276e53119c5c3056b0735ddd8542ef0fd","type":"COMMENT","name":"isi_kpi_cfg","schemaName":"dirkspzm32","sxml":""}