comment on table dirkspzm32.isi_kpi_ring_buffer is
    'KPI Persistierung für Reportind oder historische Betrachtung ';

comment on column dirkspzm32.isi_kpi_ring_buffer.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';

comment on column dirkspzm32.isi_kpi_ring_buffer.created_login_id is
    'Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.isi_kpi_ring_buffer.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_kpi_ring_buffer.isi_kpi_id is
    'Identifier Referenz zu ISI_KPI R4-DAL';

comment on column dirkspzm32.isi_kpi_ring_buffer.kpi_name is
    'Name als Refenz zur Anzeigeposition im Dashboard ';

comment on column dirkspzm32.isi_kpi_ring_buffer.kpi_sel_param is
    'Selektionsparameter um eine KPI für bestimmte Filggf. Kundenspezifisch einzutragen';

comment on column dirkspzm32.isi_kpi_ring_buffer.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.isi_kpi_ring_buffer.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.isi_kpi_ring_buffer.schwell_wert_gelb is
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
 Ausschuss %5,1 dann Rot da Ausschuss zu hochWert, ab wann der Wert nur noch OK ist (Gelb). Wenn schlechter dann Rot
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

comment on column dirkspzm32.isi_kpi_ring_buffer.schwell_wert_gruen is
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
 Ausschuss %5,1 dann Rot da Ausschuss zu hoch';

comment on column dirkspzm32.isi_kpi_ring_buffer.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_kpi_ring_buffer.wert_datum is
    'Wert Datum nicht verwechseln mit Erfasst_am';

comment on column dirkspzm32.isi_kpi_ring_buffer.wert_intervall_sek is
    'Intervall für die aktualisierung in Sekunden';

comment on column dirkspzm32.isi_kpi_ring_buffer.wert_kpi is
    'Wert der Kennzahl aktuell';


-- sqlcl_snapshot {"hash":"45f339df5f5588f5c1aac5f510bd17e7e24ac4a0","type":"COMMENT","name":"isi_kpi_ring_buffer","schemaName":"dirkspzm32","sxml":""}