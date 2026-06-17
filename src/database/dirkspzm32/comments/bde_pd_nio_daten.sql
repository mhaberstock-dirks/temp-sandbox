comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."AEND_DATUM" is 'Letztes Änderungsdatum des Datensatzes';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."AEND_LOGIN_ID" is 'LoginId der Users, der die letzte Änderung gespeichert hat';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."FERT_LAM_ID" is 'Fertigungseinheit, auf die sich der NIO-Datensatz bezieht';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NACHBEARB" is 'T= NIO nachbearbeitet, F= NIO wurde nicht nachbearbeitet';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NA_DATUM" is 'Zeitpunkt der Nachbearbeitung';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NA_DAUER_MIN" is 'Dauer der Nacharbeit in Minuten';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NA_IO" is 'T = nach der Nachbearbeitung wieder IO, F = nach der NA nich mehr IO (Schrott)';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NA_LOGIN_ID" is 'Login ID des Nachbearbeiters';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NIO_DATEN_ID" is 'Eindeutige Nummer der NIO-Meldung';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NIO_DATUM" is 'Zeitpunkt der NIO-Meldung';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NIO_NR" is 'NIO-Fehlernummer';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NIO_PARAMS" is 'flexible Anzahl von Parametern (ggf. Fehlerdaten von Maschinen, Robotern, etc.)';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."NIO_STATUS" is '-1 = Fehler vorhanden aber noch nicht klassifiziert; 0 = IO; 1 = kleiner Fehler; 2 = Nacharbeit erforderlich; 3 = autom. Ausschleusen (Schrott); 99 = nicht handelbar (manuelle Entnahme)';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."PD_LAM_STL_DATEN_ID" is 'Enthält die LAM_ID der Fertigungseinheit und die Stücklistenposition, auf die sich der NIO Datensatz bezieht';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."RES_ID" is 'ggf. Resource, die den NIO gemeldet hat';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."RES_STATUS_ID" is 'Fehlernummer, falls es an der Resource eine Störung gibt, die sich auf dieses NIO bezieht';
comment on column DIRKSPZM32.BDE_PD_NIO_DATEN."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"1d1fc0be0c79adb0990bcf0675a3720f26fd2eee","type":"COMMENT","name":"bde_pd_nio_daten","schemaName":"dirkspzm32","sxml":""}