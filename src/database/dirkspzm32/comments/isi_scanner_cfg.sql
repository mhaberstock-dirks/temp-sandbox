comment on table DIRKSPZM32.ISI_SCANNER_CFG is 'Beschreibung der Scanner für den ISI Server (Aufgabe etc.)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."AKT_AUFGABE" is 'Akt. Aufgabe z.B. PRODUKTION, BESCHICKEN, SPERREN ... oder Scanns einer Position annehmen z.B. AUFG_1, WE1, WA1 ...';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."APPLI_FUNKTION" is 'z.B. WE,WA, BDE, ...';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."APPLI_MODUL" is 'ENG, MFR, LVS, BDE ... (Für Filterfunktion wer darf diesen Scanner benutzen NULL= Jeder)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."APPLI_SERVICE" is 'Wer soll diesen Verwalten? z.B. SCEngine';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."APPLI_ZIEL" is 'Wer soll die die Scannerdaten verarbeiten z.B. Hostname, TCP/IP Adresse oder die Arbeitspltz_ID';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."APPLI_ZIEL_TYP" is 'Typ der Empfängeradresse z.B. IP oder ARBEITSPLATZ_ID';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."BARCODE_BEZ" is 'ID ... (Spaeter auch MENGE, ...)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."BARCODE_TYP" is 'CCG, VDA, ... NULL = Keine Formatierung';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."COMPUTERNAME" is 'Mit welchem Cumputer soll dieser Scanner zusammenarbeiten (nicht wenn über ISI_SCANNER_FUNK_CFG verbunden)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."COM_NAME" is 'Angeschlossen an ComServer für Antworten etc.';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."CONFIG_PARAMS" is 'individual Parameter wie in INI Datei  SCANNER=100; Peter=200; code_replace=@,<GS>';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."DRUCKER" is 'Drucker auf dem gedruckt werden soll';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."HERSTELLER" is 'Hersteller des Scanner';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."LS_LOGIN_ID" is 'Akt. Verbunden mit welchem User';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."MODELL" is 'Modell z.B. FZY302(SYMBOL), M101(DRAGON)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."RCV_CMD_ACK" is 'Acknowledge vom Scanner nach Steuer-Sequenz';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."RES_ID" is 'Akt. Verbunden mit welcher Maschine (Resource)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_DATEN" is 'Datenbuffer für letzten noch nicht verarbeiteten Barcode (Bsp.: Dragon)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_ENABLED" is 'Scanner ENABLED  T = ENABLED, F = DISABLED (Nicht verfügbar)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_FUNK_NAME" is 'Name der Funkstation für diesen Scanner (Dann ohne Comserver! Bsp. Dragon über OM-Dragon)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_MESSAGE_NO_READ" is 'Was schickt der Scanner bei NoRead';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_NAME" is 'Name des Scanner';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_POST" is 'Postambel für Scanner (Letzte Zeichen vor 0x0D) Bsp.: ]]';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_PRAE" is 'Präambel im Scanner ohne Name Bsp.: [[';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_START_READ" is 'Steuersequenz um den Scanner einzuschalten (Beam)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_TYP" is 'Scanner Typ, evtl später für besondere Abhandlung';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SCANNER_VISUNAME" is 'Name in der Visu';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SEND_SCAN_RES_1" is 'Responce Steuer-Sequenz 1 an den Scanner (z.B. Ausgang 1)';
comment on column DIRKSPZM32.ISI_SCANNER_CFG."SEND_SCAN_RES_2" is 'Responce Steuer-Sequenz 2 an den Scanner (z.B. Ausgang 2)';



-- sqlcl_snapshot {"hash":"47be1ef2110972bf22c0ece6e5cf4c6c0c76aa94","type":"COMMENT","name":"isi_scanner_cfg","schemaName":"dirkspzm32","sxml":""}