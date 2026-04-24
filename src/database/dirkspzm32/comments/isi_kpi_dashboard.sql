comment on table dirkspzm32.isi_kpi_dashboard is
    'Abbildung Dashboard in Tabelle zum Entkoppeln';

comment on column dirkspzm32.isi_kpi_dashboard.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';

comment on column dirkspzm32.isi_kpi_dashboard.created_login_id is
    'Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.isi_kpi_dashboard.dashboard_name is
    'Name des Dashboard MAX 28 Zeichen wegen Oracle Namenskonvention';

comment on column dirkspzm32.isi_kpi_dashboard.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_kpi_dashboard.isi_kpi_id is
    'Identifier Referenz zu ISI_KPI R4-DAL';

comment on column dirkspzm32.isi_kpi_dashboard.kpi_name is
    'Name als Refenz zur Anzeigeposition im Dashboard ';

comment on column dirkspzm32.isi_kpi_dashboard.kpi_sel_param is
    'Selektionsparameter um eine KPI für bestimmte Filggf. Kundenspezifisch einzutragen';

comment on column dirkspzm32.isi_kpi_dashboard.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.isi_kpi_dashboard.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.isi_kpi_dashboard.schwell_wert_gelb is
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
 Ausschuss %5,1 dann Rot da Ausschuss zu hoch';

comment on column dirkspzm32.isi_kpi_dashboard.schwell_wert_gruen is
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

comment on column dirkspzm32.isi_kpi_dashboard.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_kpi_dashboard.text_dashboard is
    'Überschrift Dashboard zur Ausgabe Kann auch eine NLS_KEY sein. (Aktuell mit R4 für Tabellen nicht nutzbar)';

comment on column dirkspzm32.isi_kpi_dashboard.text_kpi is
    'Text Überschrift für die Kennzahl.  Kann auch eine NLS_KEY sein.';

comment on column dirkspzm32.isi_kpi_dashboard.text_kpi_spalte is
    'Nur für Tabellen  und Grafiken (Verlauf) etc.ist hier die Spaltenüberschrift (Muss dann nur bei Y=1 gesetzt werden).  Kann auch eine NLS_KEY sein. (Aktuell mit R4 für Tabellen  nicht nutzbar)'
    ;

comment on column dirkspzm32.isi_kpi_dashboard.text_kpi_zeile is
    'Nur für Tabellen und Grafiken (Verlauf) etc. zu Ausgabe Text in der  Zeile (Muss nur in X=1 gesetzt werden). Kann auch eine NLS_KEY sein. (Aktuell mit R4 für Tabellen nicht nutzbar)'
    ;

comment on column dirkspzm32.isi_kpi_dashboard.wert_datum is
    'Wert Datum nicht verwechseln mit Erfasst_am';

comment on column dirkspzm32.isi_kpi_dashboard.wert_intervall_next is
    'Hier steht der nächste Aktualisierungszeitpunkt. Wenn leer, dann sofort';

comment on column dirkspzm32.isi_kpi_dashboard.wert_intervall_sek is
    'Intervall für die aktualisierung in Sekunden';

comment on column dirkspzm32.isi_kpi_dashboard.wert_kpi_aktuell is
    'Wert der Kennzahl aktuell';

comment on column dirkspzm32.isi_kpi_dashboard.wert_kpi_letzter is
    'Wert der Kennzahl letzter';

comment on column dirkspzm32.isi_kpi_dashboard.wert_kpi_max_x is
    'X Wert der Kennzahl Maximal für Tacho oder Verlaufsgrafik  oder Balkendiagramm';

comment on column dirkspzm32.isi_kpi_dashboard.wert_kpi_max_y is
    'Y Wert der Kennzahl Maximal für Tacho oder Verlaufsgrafik oder Balkendiagramm';

comment on column dirkspzm32.isi_kpi_dashboard.wert_kpi_schrittweite_x is
    'X Schritweite für Verlauf';

comment on column dirkspzm32.isi_kpi_dashboard.wert_kpi_schrittweite_y is
    'Y Schritweite für Verlauf';


-- sqlcl_snapshot {"hash":"50db93d7c4e0d3bd6814d79e2f2666518d75940f","type":"COMMENT","name":"isi_kpi_dashboard","schemaName":"dirkspzm32","sxml":""}