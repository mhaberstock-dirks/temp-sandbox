comment on table DIRKSPZM32.ISI_KPI_DASHBOARD is 'Abbildung Dashboard in Tabelle zum Entkoppeln';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."CREATED_DATE" is 'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."CREATED_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz erstellt hat';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."DASHBOARD_NAME" is 'Name des Dashboard MAX 28 Zeichen wegen Oracle Namenskonvention';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."ISI_KPI_ID" is 'Identifier Referenz zu ISI_KPI R4-DAL';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."KPI_NAME" is 'Name als Refenz zur Anzeigeposition im Dashboard ';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."KPI_SEL_PARAM" is 'Selektionsparameter um eine KPI für bestimmte Filggf. Kundenspezifisch einzutragen';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."SCHWELL_WERT_GELB" is 'Wert, ab wann der Wert nur noch OK ist (Gelb). Wenn schlechter dann Rot
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
 Ausschuss %5,1 dann Rot da Ausschuss zu hoch';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."SCHWELL_WERT_GRUEN" is 'Wert, ab wann der Wert gut ist (Gruen).
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
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."TEXT_DASHBOARD" is 'Überschrift Dashboard zur Ausgabe Kann auch eine NLS_KEY sein. (Aktuell mit R4 für Tabellen nicht nutzbar)';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."TEXT_KPI" is 'Text Überschrift für die Kennzahl.  Kann auch eine NLS_KEY sein.';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."TEXT_KPI_SPALTE" is 'Nur für Tabellen  und Grafiken (Verlauf) etc.ist hier die Spaltenüberschrift (Muss dann nur bei Y=1 gesetzt werden).  Kann auch eine NLS_KEY sein. (Aktuell mit R4 für Tabellen  nicht nutzbar)';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."TEXT_KPI_ZEILE" is 'Nur für Tabellen und Grafiken (Verlauf) etc. zu Ausgabe Text in der  Zeile (Muss nur in X=1 gesetzt werden). Kann auch eine NLS_KEY sein. (Aktuell mit R4 für Tabellen nicht nutzbar)';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."WERT_DATUM" is 'Wert Datum nicht verwechseln mit Erfasst_am';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."WERT_INTERVALL_NEXT" is 'Hier steht der nächste Aktualisierungszeitpunkt. Wenn leer, dann sofort';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."WERT_INTERVALL_SEK" is 'Intervall für die aktualisierung in Sekunden';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."WERT_KPI_AKTUELL" is 'Wert der Kennzahl aktuell';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."WERT_KPI_LETZTER" is 'Wert der Kennzahl letzter';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."WERT_KPI_MAX_X" is 'X Wert der Kennzahl Maximal für Tacho oder Verlaufsgrafik  oder Balkendiagramm';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."WERT_KPI_MAX_Y" is 'Y Wert der Kennzahl Maximal für Tacho oder Verlaufsgrafik oder Balkendiagramm';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."WERT_KPI_SCHRITTWEITE_X" is 'X Schritweite für Verlauf';
comment on column DIRKSPZM32.ISI_KPI_DASHBOARD."WERT_KPI_SCHRITTWEITE_Y" is 'Y Schritweite für Verlauf';



-- sqlcl_snapshot {"hash":"ac7e06a2c760dc9dc07150ee12081ddde4b42419","type":"COMMENT","name":"isi_kpi_dashboard","schemaName":"dirkspzm32","sxml":""}