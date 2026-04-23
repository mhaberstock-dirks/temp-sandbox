comment on column dirkspzm32.fls_element_cfg.aktions_logik is
    'ProgrammLogik aufnahmeAutrag, VollAuftrag, Staubahn, abgabeAuftrag....';

comment on column dirkspzm32.fls_element_cfg.auftr_art is
    'HALB, VOLL ...';

comment on column dirkspzm32.fls_element_cfg.default_quell_id is
    'Bei RBG mit 2.Stuf. Einlagerung EP sonst frei verwendbar';

comment on column dirkspzm32.fls_element_cfg.editor_sperre is
    'Editor sperre wenn Notstrategie -> Wege aus der Applik. geändert wird dieses  Flag gesetzt';

comment on column dirkspzm32.fls_element_cfg.element_ix is
    'IX unikat für Liste FLS Intern';

comment on column dirkspzm32.fls_element_cfg.element_name is
    'Name des Fahrzeugs';

comment on column dirkspzm32.fls_element_cfg.element_typ is
    'RBG, QTW, ...';

comment on column dirkspzm32.fls_element_cfg.enabled is
    'Nur Enabled wird das  Element vom MFR beauftragt.';

comment on column dirkspzm32.fls_element_cfg.geschwindigkeit_cm_pro_min is
    'Geschwindigkeit des Transportbandes in  CM pro Minute';

comment on column dirkspzm32.fls_element_cfg.gewerke_nr is
    'Gewerke  NR mit dieser nr und der Positions nummer wird das Gewerk eindeutig';

comment on column dirkspzm32.fls_element_cfg.is_ziel is
    '0 = Kein Ziel, 1= internes Ziel, 2= externes Ziel';

comment on column dirkspzm32.fls_element_cfg.konfig_params is
    'individual Parameter wie in INI Datei  SCANNER=100; Peter=200; ';

comment on column dirkspzm32.fls_element_cfg.koordinat_bewegung is
    'Visualisierung in welche Richtung';

comment on column dirkspzm32.fls_element_cfg.koordinat_gesamtlaenge_cm is
    'Gesamtlaenge des Elements in cm';

comment on column dirkspzm32.fls_element_cfg.koordinat_pos_x_anfang_cm is
    'Raumkoordinate des Elements X Pos. Anfangsposition in cm';

comment on column dirkspzm32.fls_element_cfg.koordinat_pos_x_ende_cm is
    'Raumkoordinate des Elements X Pos. Endeposition in cm';

comment on column dirkspzm32.fls_element_cfg.koordinat_pos_y_anfang_cm is
    'Raumkoordinate des Elements Y Pos. Anfangsposition in cm';

comment on column dirkspzm32.fls_element_cfg.koordinat_pos_y_ende_cm is
    'Raumkoordinate des Elements Y Pos.  Endeposition in cm';

comment on column dirkspzm32.fls_element_cfg.koordinat_pos_z_anfang_cm is
    'Raumkoordinate des Elements Z Pos. Anfangsposition in cm';

comment on column dirkspzm32.fls_element_cfg.koordinat_pos_z_ende_cm is
    'Raumkoordinate des Elements Z Pos.  Endeposition in cm';

comment on column dirkspzm32.fls_element_cfg.kurzname is
    'Kurzname des Fahrzeugs z.B. auch als Hostname verwendbar !!!!!';

comment on column dirkspzm32.fls_element_cfg.max_fe is
    'max. Anzahl an Fertigungseinheiten auf diesem Element';

comment on column dirkspzm32.fls_element_cfg.pos_nr is
    'positions Nr z.B Positionsnummer des Aufstellungsplans';

comment on column dirkspzm32.fls_element_cfg.progr_nr is
    'Nummer zur verwendung in ';

comment on column dirkspzm32.fls_element_cfg.reset_gruppen_id is
    'Gruppierung für eine  Reset gruppe ';

comment on column dirkspzm32.fls_element_cfg.simulat_sps_mt_zentel_sek is
    'Simulation in Zehntel Sekunden bis MT Anmeldung gesendet wird ';

comment on column dirkspzm32.fls_element_cfg.simulat_sps_pq_zentel_sek is
    'Simulation in zehntel Sekunden bis Auftrag quittiert wird';

comment on column dirkspzm32.fls_element_cfg.strategie_auftr_timeout_zs is
    'Zehntel Sekunden';

comment on column dirkspzm32.fls_element_cfg.strategie_ausschleus_moegl is
    'Ausschleusen moeglich z.B. immer ausschleusen vom WE auf Default Ziel ';

comment on column dirkspzm32.fls_element_cfg.strategie_ausschleus_ziel_id is
    'zu welchem ELement wird ausgeschleust z.B. bei einem Konturenfehler';

comment on column dirkspzm32.fls_element_cfg.strategie_auto_transp_ziel_id is
    'zu welchem Ziel wird transportiert, wenn Palette automatisch am WE z.B. ohne Daten gestartet werden Soll.';

comment on column dirkspzm32.fls_element_cfg.strategie_defekt_def_ziel_id is
    'Ausschleusziel der einlagerpaletten wenn ein RBG,.. auf defekt gesetzt wird';

comment on column dirkspzm32.fls_element_cfg.strategie_durchschl_moeglich is
    'Hauptsächlich RBG: Kann dieses Fahrzeug Durchschleusen 0=Nein 1= Ja ...';

comment on column dirkspzm32.fls_element_cfg.strategie_einl_ausl_verh is
    'Strategie Verhältnis einlagerungen zu Auslagerungen';

comment on column dirkspzm32.fls_element_cfg.strategie_ersatz_ziel_id is
    'zu welchem Ziel';

comment on column dirkspzm32.fls_element_cfg.strategie_lagerplatz is
    'z.B.  RBG Ein-/Auslagerbahn Lagerplatz , RBG Verfahr. Pos. für Bedienereinstieg.';

comment on column dirkspzm32.fls_element_cfg.strategie_pkt_belegung is
    'Strategie Punkte für Belegung je Palette';

comment on column dirkspzm32.fls_element_cfg.strategie_pkt_warten is
    'Strategie Punkte für Warten je Sekunde';

comment on column dirkspzm32.fls_element_cfg.strategie_punktevergabe is
    'nach welcher Strategie Erfolgt die Punktevergabe 1= Standart, 2= TourNummer, 3= Artikel Lagerplatz';

comment on column dirkspzm32.fls_element_cfg.strategie_reihenfolge_bis is
    'Reihenfolge suche bis LTE_ReihenfolgeNr';

comment on column dirkspzm32.fls_element_cfg.strategie_reihenfolge_von is
    'Reihenfolge suche von LTE ReihenfolgeNr';

comment on column dirkspzm32.fls_element_cfg.strategie_scann_betr_waehlen is
    'Scannerbetriebsvorwahl möglich ';

comment on column dirkspzm32.fls_element_cfg.strategie_verl_st_vorg is
    'Verlade-Status vorgabe für eine Ziel Element';

comment on column dirkspzm32.fls_element_cfg.telegr_fc is
    'SPS Auftrags Functionscode';

comment on column dirkspzm32.fls_element_cfg.telegr_fe_id_anfang is
    'SPS Foerder element ID (Auftrags Quellbahn bzw. Auftrags Zielbahn) Anfangsposition in Transportrichtung';

comment on column dirkspzm32.fls_element_cfg.telegr_fe_id_ende is
    'SPS Foerder element ID (Auftrags Quellbahn bzw. Auftrags Zielbahn) Endeposition in Transportrichtung';

comment on column dirkspzm32.fls_element_cfg.telegr_konturen_kontrolle is
    'Konturenkontrolle ? an dieser Position';

comment on column dirkspzm32.fls_element_cfg.telegr_koppl_nr is
    'Schnittstellennummer über die die Kommunikation zur SPS funktioniert';

comment on column dirkspzm32.fls_element_cfg.telegr_meld_nr is
    'Meldungs nummer für die Fehler eingetragen wird';

comment on column dirkspzm32.fls_element_cfg.telegr_mt_abmeldung is
    'SPS Palette abgemeldet';

comment on column dirkspzm32.fls_element_cfg.telegr_mt_belegt is
    'SPS Palette Anmeldung';

comment on column dirkspzm32.fls_element_cfg.telegr_mt_freiplatz is
    'SPS Platz wieder frei';

comment on column dirkspzm32.fls_element_cfg.telegr_mt_we is
    'SPS Palette auf WE ';

comment on column dirkspzm32.fls_element_cfg.telegr_paletten_hoehe is
    'Palettenhoehe an diser Position im Telegramm ?';

comment on column dirkspzm32.fls_element_cfg.telegr_paletten_typ is
    'Palettentyp an dieser position im  Telegramm';

comment on column dirkspzm32.fls_element_cfg.telegr_sps_bereich_nr is
    'Gruppen nummer, logischer getrennter Bereich';

comment on column dirkspzm32.fls_element_cfg.visu_logik is
    'Logik-Name, die in der Visualisierung benutzt werden soll, um die anzuzeigenden Daten aufzubereiten.';

comment on column dirkspzm32.fls_element_cfg.zusatz_logik_namen is
    'Zusatz Logik Namen // Kontrollscann AUfgabe Automatischer WT....';


-- sqlcl_snapshot {"hash":"dbe70dfc5ffd72cc0c499e4e8e732bcb70b6698a","type":"COMMENT","name":"fls_element_cfg","schemaName":"dirkspzm32","sxml":""}