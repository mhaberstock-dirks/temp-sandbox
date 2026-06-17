comment on table DIRKSPZM32.ISI_TRANSPORT_LOG is 'Loggen der Transportaktionen (Statusänderung)';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."ARBEITSPLATZ_ID" is 'An/Mit welchem Arbeitsplatz (Terminal) wurde die Prüfung ausgeführt';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."CHECK_PASSED" is 'T = Prüfung konnte bestätigt werden, F = Prüfung konnte nicht bestätigt werden, NULL = keine gültige Prüfung erfolgt';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."CHECK_Q_ETI_TYP" is 'VDA, CCG, NOBC = kein Barcode (manuelle Eingabe), CUST (kundenspezifischer Barcode)';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."CHECK_TYP" is 'we_eti, we_lgr, wa_eti, wa_lgr_z, wa_lgr_q';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."LOGIN_ID" is 'Falls vorhanden, Login ID des Benutzers, der die Aktion durchgeführt hat';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."LOG_TYP" is 'STAT = Statusänderung, CHECK = Prüfung durch User';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."LTE_ID" is 'Lte die Transportiert wird';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."PARENT_TRANSP_ID" is 'PARENT_TRANSP_ID für diesen Auftrag';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."RES_ID" is 'res_id des Transports';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."SCAN_DATA" is 'Welche Daten wurden gescannt';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."STATUS" is 'F=Frei,
G=Gesperrt,
Z=Zugewiesen,
B=Begonnen (Resource bewegt sich zur LTE),
T=LTE wird transportiert,
D=Transport in die HIST Tabelle eingetragen
E=Fertig Ende';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."STATUS_TS" is 'Zeitpunkt des Status oder Check';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."TRANSACTION_ID" is 'transactionsid für die transprot Buchung';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."TRANSPORT_GRUPPE" is 'Tour Nr ';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."TRANSP_ID" is 'Transport ID des Transports, dessen Status sich geändert hat';
comment on column DIRKSPZM32.ISI_TRANSPORT_LOG."TRANSP_LOG_ID" is 'Laufende Nummer des Logeintrags (seq_transp_log_id)';



-- sqlcl_snapshot {"hash":"f2ecc7a2fc17584c617e5216f240e0146f2b564c","type":"COMMENT","name":"isi_transport_log","schemaName":"dirkspzm32","sxml":""}