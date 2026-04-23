comment on table dirkspzm32.isi_tor_cfg is
    'Beschreibung der Tore für den ISI Server';

comment on column dirkspzm32.isi_tor_cfg.com_name is
    'Angeschlossen an ComServer für Antworten etc.';

comment on column dirkspzm32.isi_tor_cfg.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_tor_cfg.sched_res_id is
    'Resourcen-ID für den Task-Scheduler';

comment on column dirkspzm32.isi_tor_cfg.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_tor_cfg.tor_ablauf is
    'Welche Funktion handelt die Comunikation ab';

comment on column dirkspzm32.isi_tor_cfg.tor_alle is
    '''T'' Alle eingetragenen Transponder dürfen dieses Tor öffnen';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen is
    'Soll das Tor eine Daueroeffnung haben T = Ja F = Nein';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_bis is
    'Uhrzeit ab wann ist das Tor daueroffen';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_di is
    'Gillt fuer Dienstags';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_do is
    'Gillt fuer Donnerstags';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_feiertag is
    'Gillt Feiertags';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_fr is
    'Gillt fuer Freitags';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_mi is
    'Gillt fuer Mittwochs';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_mo is
    'Gillt fuer Montags';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_sa is
    'Gillt fuer Samstags';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_so is
    'Gillt fuer Sonntags';

comment on column dirkspzm32.isi_tor_cfg.tor_dauer_offen_von is
    'Uhrzeit ab wann ist das Tor daueroffen';

comment on column dirkspzm32.isi_tor_cfg.tor_id_lesegeraet is
    'Name vom Transponderleser für Tor';

comment on column dirkspzm32.isi_tor_cfg.tor_id_lesegeraet_typ is
    'Lesertyp vom Transponderleser';

comment on column dirkspzm32.isi_tor_cfg.tor_name is
    'Name des TOR';

comment on column dirkspzm32.isi_tor_cfg.tor_offen_zeit is
    'Wie lange ist das Tor offen in Sekunden';

comment on column dirkspzm32.isi_tor_cfg.tor_post is
    'Postambel für TOR (Letzte Zeichen vor 0x0D) Bsp.: ]]';

comment on column dirkspzm32.isi_tor_cfg.tor_prae is
    'Präambel im TOR ohne Name Bsp.: [[';

comment on column dirkspzm32.isi_tor_cfg.tor_rs485_adresse is
    'Adresse des Tors bei Protokoll RS485';

comment on column dirkspzm32.isi_tor_cfg.tor_typ is
    'TOR Typ, evtl später für besondere Abhandlung';

comment on column dirkspzm32.isi_tor_cfg.tor_visuname is
    'Name in der Visu';

comment on column dirkspzm32.isi_tor_cfg.tor_warte_antwort is
    'Zus. Wartezeit für Antwort, wenn Antwort noch nicht da';

comment on column dirkspzm32.isi_tor_cfg.tor_warte_daten is
    'Wartezeit beim Lesen ob noch etwas kommt';

comment on column dirkspzm32.isi_tor_cfg.tor_warte_execute is
    'Wartezeit im EXECUTE';

comment on column dirkspzm32.isi_tor_cfg.tor_warte_n_senden is
    'Wartezeit nach Senden zum ComServer';


-- sqlcl_snapshot {"hash":"810cab5c603691bb7ee8a834e7ef3cc338e43a4a","type":"COMMENT","name":"isi_tor_cfg","schemaName":"dirkspzm32","sxml":""}