comment on table dirkspzm32.isi_kpi_cfg is
    'Abbildung KPIs in Tabelle zur verwaltung der Quelle (z.B. SQL)';

comment on column dirkspzm32.isi_kpi_cfg.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';

comment on column dirkspzm32.isi_kpi_cfg.created_login_id is
    'Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.isi_kpi_cfg.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_kpi_cfg.kpi_beschreibung is
    'Beschreibung der Kennzahl. Was sagt die Kennzahl aus (DOKU)';

comment on column dirkspzm32.isi_kpi_cfg.kpi_name is
    'Name als Refenz zur Anzeigeposition im Dashboard ';

comment on column dirkspzm32.isi_kpi_cfg.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.isi_kpi_cfg.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.isi_kpi_cfg.schwell_wert_gelb is
    'Wert, ab wann der Wert nur noch OK ist (Gelb). Wenn schlechter dann Rot
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

comment on column dirkspzm32.isi_kpi_cfg.schwell_wert_gruen is
    'Wert, ab wann der Wert gut ist (Gruen).
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

comment on column dirkspzm32.isi_kpi_cfg.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_kpi_cfg.text_kpi is
    'Text Überschrift für die Kennzahl.  Kann auch eine NLS_KEY sein.';

comment on column dirkspzm32.isi_kpi_cfg.wert_params is
    'Parameter die zus. gefüllt werden sollen';

comment on column dirkspzm32.isi_kpi_cfg.wert_quelle is
    'DAL oder SQL für die gewinnung der Daten. Wenn leer, dann müssen die Datengewinnung in der Service-Logik programmiert werden. Wenn etwas in der Logik programmiert ist, dann hat das immer Vorang'
    ;

comment on column dirkspzm32.isi_kpi_cfg.wert_quelle_typ is
    'Typ der Quelle SQL = SQL-Abfrage, MSG = Nachrichten, ...';


-- sqlcl_snapshot {"hash":"5f1f5d2033114e9cca513ed9c7e4afa0a05af02f","type":"COMMENT","name":"isi_kpi_cfg","schemaName":"dirkspzm32","sxml":""}