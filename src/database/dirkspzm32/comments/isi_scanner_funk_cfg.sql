comment on table DIRKSPZM32.ISI_SCANNER_FUNK_CFG is 'Beschreibung der Scanner Funkstationewn für den ISI Server';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."APPLI_FUNKTION" is 'z.B. WE,WA, BDE, ...';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."APPLI_MODUL" is 'MFREngine, SCEngine, ISIPlus ... (Für Filterfunktion wer darf diesen Scanner benutzen NULL= Jeder)';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."APPLI_SERVICE" is 'Wer soll diesen Verwalten? z.B. SCEngine';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."COM_NAME" is 'Angeschlossen an ComServer für Antworten etc.';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."SCANNER_FUNK_DELIMITER" is 'Trennzeichen zum Trenne des Scannernamens von den Scanndaten';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."SCANNER_FUNK_ENABLED" is 'Scanner Gruppe ENABLED  T = ENABLED, F = DISABLED (Nicht verfügbar)';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."SCANNER_FUNK_INIT_ANTWORT" is 'Timout für Antwort in Sec 0 = Keine Antwort';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."SCANNER_FUNK_INIT_STR" is 'Initialisierung für diesen Scanner';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."SCANNER_FUNK_NAME" is 'Name des Scanner';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."SCANNER_FUNK_POST" is 'Postambel für Funkstation. Bsp.: <ETX>';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."SCANNER_FUNK_PRAE" is 'Präambel in der Funkstation ohne Name Bsp.: <STX>';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."SCANNER_FUNK_TYP" is 'Funkstation Typ, evtl später für besondere Abhandlung';
comment on column DIRKSPZM32.ISI_SCANNER_FUNK_CFG."SCANNER_FUNK_VISUNAME" is 'Name in der Visu';



-- sqlcl_snapshot {"hash":"d299f445a8e5322f1ab00c0f619ac53acf7d7faa","type":"COMMENT","name":"isi_scanner_funk_cfg","schemaName":"dirkspzm32","sxml":""}