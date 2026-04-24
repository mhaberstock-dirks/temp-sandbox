comment on column dirkspzm32.bde_pd_nio_daten.aend_datum is
    'Letztes Änderungsdatum des Datensatzes';

comment on column dirkspzm32.bde_pd_nio_daten.aend_login_id is
    'LoginId der Users, der die letzte Änderung gespeichert hat';

comment on column dirkspzm32.bde_pd_nio_daten.fert_lam_id is
    'Fertigungseinheit, auf die sich der NIO-Datensatz bezieht';

comment on column dirkspzm32.bde_pd_nio_daten.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.bde_pd_nio_daten.nachbearb is
    'T= NIO nachbearbeitet, F= NIO wurde nicht nachbearbeitet';

comment on column dirkspzm32.bde_pd_nio_daten.na_datum is
    'Zeitpunkt der Nachbearbeitung';

comment on column dirkspzm32.bde_pd_nio_daten.na_dauer_min is
    'Dauer der Nacharbeit in Minuten';

comment on column dirkspzm32.bde_pd_nio_daten.na_io is
    'T = nach der Nachbearbeitung wieder IO, F = nach der NA nich mehr IO (Schrott)';

comment on column dirkspzm32.bde_pd_nio_daten.na_login_id is
    'Login ID des Nachbearbeiters';

comment on column dirkspzm32.bde_pd_nio_daten.nio_daten_id is
    'Eindeutige Nummer der NIO-Meldung';

comment on column dirkspzm32.bde_pd_nio_daten.nio_datum is
    'Zeitpunkt der NIO-Meldung';

comment on column dirkspzm32.bde_pd_nio_daten.nio_nr is
    'NIO-Fehlernummer';

comment on column dirkspzm32.bde_pd_nio_daten.nio_params is
    'flexible Anzahl von Parametern (ggf. Fehlerdaten von Maschinen, Robotern, etc.)';

comment on column dirkspzm32.bde_pd_nio_daten.nio_status is
    '-1 = Fehler vorhanden aber noch nicht klassifiziert; 0 = IO; 1 = kleiner Fehler; 2 = Nacharbeit erforderlich; 3 = autom. Ausschleusen (Schrott); 99 = nicht handelbar (manuelle Entnahme)'
    ;

comment on column dirkspzm32.bde_pd_nio_daten.pd_lam_stl_daten_id is
    'Enthält die LAM_ID der Fertigungseinheit und die Stücklistenposition, auf die sich der NIO Datensatz bezieht';

comment on column dirkspzm32.bde_pd_nio_daten.res_id is
    'ggf. Resource, die den NIO gemeldet hat';

comment on column dirkspzm32.bde_pd_nio_daten.res_status_id is
    'Fehlernummer, falls es an der Resource eine Störung gibt, die sich auf dieses NIO bezieht';

comment on column dirkspzm32.bde_pd_nio_daten.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"798af671c546e5957a13ce7a3b1e933681542370","type":"COMMENT","name":"bde_pd_nio_daten","schemaName":"dirkspzm32","sxml":""}