comment on table dirkspzm32.isi_scanner_cfg is
    'Beschreibung der Scanner für den ISI Server (Aufgabe etc.)';

comment on column dirkspzm32.isi_scanner_cfg.akt_aufgabe is
    'Akt. Aufgabe z.B. PRODUKTION, BESCHICKEN, SPERREN ... oder Scanns einer Position annehmen z.B. AUFG_1, WE1, WA1 ...';

comment on column dirkspzm32.isi_scanner_cfg.appli_funktion is
    'z.B. WE,WA, BDE, ...';

comment on column dirkspzm32.isi_scanner_cfg.appli_modul is
    'ENG, MFR, LVS, BDE ... (Für Filterfunktion wer darf diesen Scanner benutzen NULL= Jeder)';

comment on column dirkspzm32.isi_scanner_cfg.appli_service is
    'Wer soll diesen Verwalten? z.B. SCEngine';

comment on column dirkspzm32.isi_scanner_cfg.appli_ziel is
    'Wer soll die die Scannerdaten verarbeiten z.B. Hostname, TCP/IP Adresse oder die Arbeitspltz_ID';

comment on column dirkspzm32.isi_scanner_cfg.appli_ziel_typ is
    'Typ der Empfängeradresse z.B. IP oder ARBEITSPLATZ_ID';

comment on column dirkspzm32.isi_scanner_cfg.barcode_bez is
    'ID ... (Spaeter auch MENGE, ...)';

comment on column dirkspzm32.isi_scanner_cfg.barcode_typ is
    'CCG, VDA, ... NULL = Keine Formatierung';

comment on column dirkspzm32.isi_scanner_cfg.computername is
    'Mit welchem Cumputer soll dieser Scanner zusammenarbeiten (nicht wenn über ISI_SCANNER_FUNK_CFG verbunden)';

comment on column dirkspzm32.isi_scanner_cfg.com_name is
    'Angeschlossen an ComServer für Antworten etc.';

comment on column dirkspzm32.isi_scanner_cfg.config_params is
    'individual Parameter wie in INI Datei  SCANNER=100; Peter=200; code_replace=@,<GS>';

comment on column dirkspzm32.isi_scanner_cfg.drucker is
    'Drucker auf dem gedruckt werden soll';

comment on column dirkspzm32.isi_scanner_cfg.hersteller is
    'Hersteller des Scanner';

comment on column dirkspzm32.isi_scanner_cfg.ls_login_id is
    'Akt. Verbunden mit welchem User';

comment on column dirkspzm32.isi_scanner_cfg.modell is
    'Modell z.B. FZY302(SYMBOL), M101(DRAGON)';

comment on column dirkspzm32.isi_scanner_cfg.rcv_cmd_ack is
    'Acknowledge vom Scanner nach Steuer-Sequenz';

comment on column dirkspzm32.isi_scanner_cfg.res_id is
    'Akt. Verbunden mit welcher Maschine (Resource)';

comment on column dirkspzm32.isi_scanner_cfg.scanner_daten is
    'Datenbuffer für letzten noch nicht verarbeiteten Barcode (Bsp.: Dragon)';

comment on column dirkspzm32.isi_scanner_cfg.scanner_enabled is
    'Scanner ENABLED  T = ENABLED, F = DISABLED (Nicht verfügbar)';

comment on column dirkspzm32.isi_scanner_cfg.scanner_funk_name is
    'Name der Funkstation für diesen Scanner (Dann ohne Comserver! Bsp. Dragon über OM-Dragon)';

comment on column dirkspzm32.isi_scanner_cfg.scanner_message_no_read is
    'Was schickt der Scanner bei NoRead';

comment on column dirkspzm32.isi_scanner_cfg.scanner_name is
    'Name des Scanner';

comment on column dirkspzm32.isi_scanner_cfg.scanner_post is
    'Postambel für Scanner (Letzte Zeichen vor 0x0D) Bsp.: ]]';

comment on column dirkspzm32.isi_scanner_cfg.scanner_prae is
    'Präambel im Scanner ohne Name Bsp.: [[';

comment on column dirkspzm32.isi_scanner_cfg.scanner_start_read is
    'Steuersequenz um den Scanner einzuschalten (Beam)';

comment on column dirkspzm32.isi_scanner_cfg.scanner_typ is
    'Scanner Typ, evtl später für besondere Abhandlung';

comment on column dirkspzm32.isi_scanner_cfg.scanner_visuname is
    'Name in der Visu';

comment on column dirkspzm32.isi_scanner_cfg.send_scan_res_1 is
    'Responce Steuer-Sequenz 1 an den Scanner (z.B. Ausgang 1)';

comment on column dirkspzm32.isi_scanner_cfg.send_scan_res_2 is
    'Responce Steuer-Sequenz 2 an den Scanner (z.B. Ausgang 2)';


-- sqlcl_snapshot {"hash":"726518307a4bc38413e57462cd0468eadff9f687","type":"COMMENT","name":"isi_scanner_cfg","schemaName":"dirkspzm32","sxml":""}