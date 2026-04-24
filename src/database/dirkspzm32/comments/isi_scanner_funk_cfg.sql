comment on table dirkspzm32.isi_scanner_funk_cfg is
    'Beschreibung der Scanner Funkstationewn für den ISI Server';

comment on column dirkspzm32.isi_scanner_funk_cfg.appli_funktion is
    'z.B. WE,WA, BDE, ...';

comment on column dirkspzm32.isi_scanner_funk_cfg.appli_modul is
    'MFREngine, SCEngine, ISIPlus ... (Für Filterfunktion wer darf diesen Scanner benutzen NULL= Jeder)';

comment on column dirkspzm32.isi_scanner_funk_cfg.appli_service is
    'Wer soll diesen Verwalten? z.B. SCEngine';

comment on column dirkspzm32.isi_scanner_funk_cfg.com_name is
    'Angeschlossen an ComServer für Antworten etc.';

comment on column dirkspzm32.isi_scanner_funk_cfg.scanner_funk_delimiter is
    'Trennzeichen zum Trenne des Scannernamens von den Scanndaten';

comment on column dirkspzm32.isi_scanner_funk_cfg.scanner_funk_enabled is
    'Scanner Gruppe ENABLED  T = ENABLED, F = DISABLED (Nicht verfügbar)';

comment on column dirkspzm32.isi_scanner_funk_cfg.scanner_funk_init_antwort is
    'Timout für Antwort in Sec 0 = Keine Antwort';

comment on column dirkspzm32.isi_scanner_funk_cfg.scanner_funk_init_str is
    'Initialisierung für diesen Scanner';

comment on column dirkspzm32.isi_scanner_funk_cfg.scanner_funk_name is
    'Name des Scanner';

comment on column dirkspzm32.isi_scanner_funk_cfg.scanner_funk_post is
    'Postambel für Funkstation. Bsp.: <ETX>';

comment on column dirkspzm32.isi_scanner_funk_cfg.scanner_funk_prae is
    'Präambel in der Funkstation ohne Name Bsp.: <STX>';

comment on column dirkspzm32.isi_scanner_funk_cfg.scanner_funk_typ is
    'Funkstation Typ, evtl später für besondere Abhandlung';

comment on column dirkspzm32.isi_scanner_funk_cfg.scanner_funk_visuname is
    'Name in der Visu';


-- sqlcl_snapshot {"hash":"81b26dca26722545ce0ce9a7e5acb1f2bf9b1290","type":"COMMENT","name":"isi_scanner_funk_cfg","schemaName":"dirkspzm32","sxml":""}