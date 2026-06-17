comment on table DIRKSPZM32.ISI_SCAN_LOG is 'Logtabelle für Scannungen während der IBS';
comment on column DIRKSPZM32.ISI_SCAN_LOG."ERROR_TXT" is 'Erläuternder Text bei fehlerhafter Scannung';
comment on column DIRKSPZM32.ISI_SCAN_LOG."ISI_SCAN_LOG_ID" is 'Fortlaufende ID des Log-Eintrags';
comment on column DIRKSPZM32.ISI_SCAN_LOG."LEITZAHL" is 'Fertigungsauftragsnummer / Leitzahl';
comment on column DIRKSPZM32.ISI_SCAN_LOG."LHM_ID" is 'Lagerhilfsmittel-ID (Barcode auf dem Karton)';
comment on column DIRKSPZM32.ISI_SCAN_LOG."LOG_TIME" is 'Zeitpunkt des Logeintrags';
comment on column DIRKSPZM32.ISI_SCAN_LOG."LTE_ID" is 'ID der Transporteinheit an der Maschine';
comment on column DIRKSPZM32.ISI_SCAN_LOG."PERS_NR" is 'Personalnummer des Maschinenführers';
comment on column DIRKSPZM32.ISI_SCAN_LOG."RES_AUFGABE" is 'Aufgabe der Maschine P=Produzieren R=Rüsten NULL=Kein Auftrag angemeldet';
comment on column DIRKSPZM32.ISI_SCAN_LOG."RES_ID" is 'Maschinennummer';
comment on column DIRKSPZM32.ISI_SCAN_LOG."RES_STATUS_ID" is 'Maschinenstatus';
comment on column DIRKSPZM32.ISI_SCAN_LOG."SCANNER_CMD" is 'Kommando-Sequenz an den Scanner';
comment on column DIRKSPZM32.ISI_SCAN_LOG."SCANNER_NAME" is 'Name des Scanners';
comment on column DIRKSPZM32.ISI_SCAN_LOG."SCANNER_READ" is 'Scannerlesung: gültiger Barcode, Fehllesung oder Fehlertext';
comment on column DIRKSPZM32.ISI_SCAN_LOG."SCAN_OK" is '''T''  Scannung erfolgreich, ''F'' Scannung fehlerhaft';
comment on column DIRKSPZM32.ISI_SCAN_LOG."SID" is 'Oracle SID';



-- sqlcl_snapshot {"hash":"87909c9cbaad9b9ce656710cdb7b0bb4a458aced","type":"COMMENT","name":"isi_scan_log","schemaName":"dirkspzm32","sxml":""}