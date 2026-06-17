comment on table DIRKSPZM32.LVS_CHECK_LOG is 'Loggen der Transport und Lagerprüfungen, z.B. mit Terminal (Ist das Teil auf dem richtigen Platz?)';
comment on column DIRKSPZM32.LVS_CHECK_LOG."ARBEITSPLATZ_ID" is 'An/Mit welchem Arbeitsplatz (Terminal) wurde die Prüfung ausgeführt';
comment on column DIRKSPZM32.LVS_CHECK_LOG."CHECK_PASSED" is 'T = Prüfung konnte bestätigt werden, F = Prüfung konnte nicht bestätigt werden, U = unbekannt / keine gültige Prüfung erfolgt';
comment on column DIRKSPZM32.LVS_CHECK_LOG."CHECK_Q_ETI_TYP" is 'VDA, CCG, NOBC = kein Barcode (manuelle Eingabe), CUST (kundenspezifischer Barcode), LGR =Lagerplatzbarcode';
comment on column DIRKSPZM32.LVS_CHECK_LOG."CHECK_TS" is 'Zeitpunkt des Checks';
comment on column DIRKSPZM32.LVS_CHECK_LOG."CHECK_TYP" is 'ware_lgr_platz = Prüfung des Standorts der Ware, lgr_platz = Prüfung des Lagerplatzes und dessen Inhalt';
comment on column DIRKSPZM32.LVS_CHECK_LOG."CHECK_Z_ETI_TYP" is 'VDA, CCG, NOBC = kein Barcode (manuelle Eingabe), CUST (kundenspezifischer Barcode), LGR =Lagerplatzbarcode';
comment on column DIRKSPZM32.LVS_CHECK_LOG."LGR_PLATZ" is 'Optional: um welchen Lagerplatz handelte es sich beim Check';
comment on column DIRKSPZM32.LVS_CHECK_LOG."LHM_ID" is 'Optional: um welche LHM ID handelte es sich beim Check';
comment on column DIRKSPZM32.LVS_CHECK_LOG."LOGIN_ID" is 'Falls vorhanden, Login ID des Benutzers, der die Aktion durchgeführt hat';
comment on column DIRKSPZM32.LVS_CHECK_LOG."LTE_ID" is 'Optional: um welche LTE ID handelte es sich beim Check';
comment on column DIRKSPZM32.LVS_CHECK_LOG."LVS_CHECK_LOG_ID" is 'Laufende Nummer des Logeintrags (seq_lvs_check_log_id)';
comment on column DIRKSPZM32.LVS_CHECK_LOG."SCAN_DATA_1" is 'Welche Daten wurden zum Prüfen gescannt';
comment on column DIRKSPZM32.LVS_CHECK_LOG."SCAN_DATA_2" is 'Welche Daten wurden zur Kontrolle (Vergleich) gescannt';
comment on column DIRKSPZM32.LVS_CHECK_LOG."SOLL_DATA_2" is 'Welche Daten wurden in SCAN_DATA_2 erwartet';



-- sqlcl_snapshot {"hash":"fe92cf16296a31ac4c23482a4fd0c19b6259fd1b","type":"COMMENT","name":"lvs_check_log","schemaName":"dirkspzm32","sxml":""}