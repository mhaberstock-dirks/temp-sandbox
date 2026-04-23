comment on table dirkspzm32.isi_kpi is
    'Abbildung KPIs in Tabelle für Dashboards oder reports';

comment on column dirkspzm32.isi_kpi.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';

comment on column dirkspzm32.isi_kpi.created_login_id is
    'Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.isi_kpi.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_kpi.isi_kpi_id is
    'Unique Identifier R4-DAL';

comment on column dirkspzm32.isi_kpi.kpi_name is
    'Name als Refenz zur Anzeigeposition im Dashboard ';

comment on column dirkspzm32.isi_kpi.kpi_sel_param is
    'Selektionsparameter um eine KPI für bestimmte Filggf. Kundenspezifisch einzutragen';

comment on column dirkspzm32.isi_kpi.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.isi_kpi.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.isi_kpi.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_kpi.wert_datum is
    'Wert Datum nicht verwechseln mit Erfasst_am';

comment on column dirkspzm32.isi_kpi.wert_intervall_datum is
    'Wenn gesetzt, dann wird dieses datum immer als Grundlage für die Berechnung der nächsten aktualisierung genutzt. Sonst wied immr das Wertdatum + WERT_INTERVALL_SEK zur Berechnung genutzt.'
    ;

comment on column dirkspzm32.isi_kpi.wert_intervall_next is
    'Hier steht der nächste Aktualisierungszeitpunkt. Wenn leer, dann sofort';

comment on column dirkspzm32.isi_kpi.wert_intervall_sek is
    'Intervall für die aktualisierung in Sekunden';

comment on column dirkspzm32.isi_kpi.wert_kpi_aktuell is
    'Wert der Kennzahl aktuell';

comment on column dirkspzm32.isi_kpi.wert_kpi_letzter is
    'Wert der aktuellen Kennzahl letzter nach Update';


-- sqlcl_snapshot {"hash":"7638e15cd82cdd8d46e18ddf392f15ba9dd4e9db","type":"COMMENT","name":"isi_kpi","schemaName":"dirkspzm32","sxml":""}