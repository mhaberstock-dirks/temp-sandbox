comment on column dirkspzm32.mfr_element_cfg.aktions_logik is
    'ProgrammLogik aufnahmeAutrag, VollAuftrag, Staubahn, abgabeAuftrag....';

comment on column dirkspzm32.mfr_element_cfg.anlagen_id is
    'Element gehört zu Anlage -> MFR_ANLAGE (Security Relevant)';

comment on column dirkspzm32.mfr_element_cfg.auftr_art is
    'HALB VOLL ...';

comment on column dirkspzm32.mfr_element_cfg.default_quell_id is
    'Bei RBG mit 2.Stuf. Einlagerung EP sonst frei verwendbar';

comment on column dirkspzm32.mfr_element_cfg.editor_sperre is
    'Editor sperre wenn Notstrategie -> Wege aus der Applik. geändert wird dieses  Flag gesetzt';

comment on column dirkspzm32.mfr_element_cfg.element_typ is
    'RBG, QTW, ...';

comment on column dirkspzm32.mfr_element_cfg.enabled is
    'Nur Enabled wird das  Element vom MFR beauftragt.';

comment on column dirkspzm32.mfr_element_cfg.fahrzeug is
    'Name des Fahrzeugs';

comment on column dirkspzm32.mfr_element_cfg.fahrzeug_ix is
    'IX unikat für Liste MFR Intern';

comment on column dirkspzm32.mfr_element_cfg.fahrzkurz is
    'Kurzname des Fahrzeugs z.B. auch als Hostname verwendbar !!!!!';

comment on column dirkspzm32.mfr_element_cfg.geschwindigkeit_cm_pro_min is
    'Geschwindigkeit des Transportbandes in  CM pro Minute';

comment on column dirkspzm32.mfr_element_cfg.gewerke_nr is
    'Gewerke  NR mit dieser nr und der Positions nummer wird das Gewerk eindeutig';

comment on column dirkspzm32.mfr_element_cfg.info_links_customer is
    'HTML Links auf  Dokumentationen für Kunden';

comment on column dirkspzm32.mfr_element_cfg.info_links_maintenance is
    'HTML Links auf  Dokumentationen für Service Instandhaltung';

comment on column dirkspzm32.mfr_element_cfg.info_text is
    'Infotext beschreibt die Besonderheiten Merkmale dieses Elements';

comment on column dirkspzm32.mfr_element_cfg.is_ziel is
    '0 = Kein Ziel, 1= internes Ziel, 2= externes Ziel';

comment on column dirkspzm32.mfr_element_cfg.konfig_params is
    'individual Parameter wie in INI Datei  SCANNER=100; Peter=200; ';

comment on column dirkspzm32.mfr_element_cfg.koordinat_bewegung is
    'Visualisierung in welche Richtung';

comment on column dirkspzm32.mfr_element_cfg.koordinat_gesamtlaenge_cm is
    'Gesamtlaenge des Elements in cm';

comment on column dirkspzm32.mfr_element_cfg.koordinat_pos_x_anfang_cm is
    'Raumkoordinate des Elements X Pos. Anfangsposition in cm';

comment on column dirkspzm32.mfr_element_cfg.koordinat_pos_x_ende_cm is
    'Raumkoordinate des Elements X Pos. Endeposition in cm';

comment on column dirkspzm32.mfr_element_cfg.koordinat_pos_y_anfang_cm is
    'Raumkoordinate des Elements Y Pos. Anfangsposition in cm';

comment on column dirkspzm32.mfr_element_cfg.koordinat_pos_y_ende_cm is
    'Raumkoordinate des Elements Y Pos.  Endeposition in cm';

comment on column dirkspzm32.mfr_element_cfg.koordinat_pos_z_anfang_cm is
    'Raumkoordinate des Elements Z Pos. Anfangsposition in cm';

comment on column dirkspzm32.mfr_element_cfg.koordinat_pos_z_ende_cm is
    'Raumkoordinate des Elements Z Pos.  Endeposition in cm';

comment on column dirkspzm32.mfr_element_cfg.liste_orts_kennzeichen is
    'Semikolon getrennte Liste an Ortskennzeichen  für Elemente mit mehr als einer LTe';

comment on column dirkspzm32.mfr_element_cfg.liste_positions_nr is
    'Semikolon getrennte Liste an Positionsnummern für Elemente mit mehr als einer LTe';

comment on column dirkspzm32.mfr_element_cfg.lvs_transp_event is
    'LVSTransportBuchung 0 = Keine; 1 = AuslTransport ;  2= AuslFertig;';

comment on column dirkspzm32.mfr_element_cfg.max_lte is
    'max. Anzahl an LTE auf diesem Element';

comment on column dirkspzm32.mfr_element_cfg.max_lte_hoehe is
    'Max LTE Höhe die dieses Element transportieren kann.';

comment on column dirkspzm32.mfr_element_cfg.pos_nr is
    'positions Nr z.B Positionsnummer des Aufstellungsplans';

comment on column dirkspzm32.mfr_element_cfg.progr_nr is
    'Nummer zur verwendung in ';

comment on column dirkspzm32.mfr_element_cfg.proj_spez_a is
    'Projekt spezifische Verwendung Parameter A';

comment on column dirkspzm32.mfr_element_cfg.proj_spez_b is
    'Projekt spezifische Verwendung Parameter B';

comment on column dirkspzm32.mfr_element_cfg.proj_spez_c is
    'Projekt spezifische Verwendung Parameter C';

comment on column dirkspzm32.mfr_element_cfg.proj_spez_d is
    'Projekt spezifische Verwendung Parameter D';

comment on column dirkspzm32.mfr_element_cfg.reset_gruppen_id is
    'Gruppierung für eine  Reset gruppe ';

comment on column dirkspzm32.mfr_element_cfg.simulat_sps_mt_zentel_sek is
    'Simulation in Zehntel Sekunden bis MT Anmeldung gesendet wird ';

comment on column dirkspzm32.mfr_element_cfg.simulat_sps_pq_zentel_sek is
    'Simulation in zehntel Sekunden bis Auftrag quittiert wird';

comment on column dirkspzm32.mfr_element_cfg.strategie_auftr_timeout_zs is
    'Zehntel Sekunden';

comment on column dirkspzm32.mfr_element_cfg.strategie_ausschleus_moegl is
    'Ausschleusen moeglich z.B. immer ausschleusen vom WE auf Default Ziel ';

comment on column dirkspzm32.mfr_element_cfg.strategie_ausschleus_ziel_id is
    'zu welchem ELement wird ausgeschleust z.B. bei einem Konturenfehler';

comment on column dirkspzm32.mfr_element_cfg.strategie_auto_transp_ziel_id is
    'zu welchem Ziel wird transportiert, wenn Palette automatisch am WE z.B. ohne Daten gestartet werden Soll.';

comment on column dirkspzm32.mfr_element_cfg.strategie_defekt_def_ziel_id is
    'Ausschleusziel der einlagerpaletten wenn ein RBG,.. auf defekt gesetzt wird';

comment on column dirkspzm32.mfr_element_cfg.strategie_durchschl_moeglich is
    'Hauptsächlich RBG: Kann dieses Fahrzeug Durchschleusen 0=Nein 1= Ja ...';

comment on column dirkspzm32.mfr_element_cfg.strategie_einl_ausl_verh is
    'Strategie Verhältnis einlagerungen zu Auslagerungen';

comment on column dirkspzm32.mfr_element_cfg.strategie_ersatz_ziel_id is
    'zu welchem Ziel';

comment on column dirkspzm32.mfr_element_cfg.strategie_lagerorte_erreichbar is
    'FÜR WE und EP Eintrag -> 0;1;3;';

comment on column dirkspzm32.mfr_element_cfg.strategie_lagerplatz is
    'z.B.  RBG Ein-/Auslagerbahn Lagerplatz , RBG Verfahr. Pos. für Bedienereinstieg.';

comment on column dirkspzm32.mfr_element_cfg.strategie_max_beschl_proz is
    'maximale Beschleunigung  des Fahrzeugs in Prozent  ';

comment on column dirkspzm32.mfr_element_cfg.strategie_max_geschw_proz is
    'maximale Geschwindigkeit des Fahrzeugs in Prozent';

comment on column dirkspzm32.mfr_element_cfg.strategie_min_beschl_proz is
    'minimale Beschleunigung  des Fahrzeugs in Prozent.  Bei 100% kann das Fahrzeug keine dynamische Änderung';

comment on column dirkspzm32.mfr_element_cfg.strategie_min_geschw_proz is
    'minimale Geschwindigkeit des Fahrzeugs in Prozent. Bei 100% kann das Fahrzeug keine dynamische Änderung';

comment on column dirkspzm32.mfr_element_cfg.strategie_partner_fahrzeuge is
    'IDs der Partnerfahrzeuge -> 0;1;2;3;';

comment on column dirkspzm32.mfr_element_cfg.strategie_pkt_belegung is
    'Strategie Punkte für Belegung je Palette';

comment on column dirkspzm32.mfr_element_cfg.strategie_pkt_warten is
    'Strategie Punkte für Warten je Sekunde';

comment on column dirkspzm32.mfr_element_cfg.strategie_punktevergabe is
    'nach welcher Strategie Erfolgt die Punktevergabe 1= Standart, 2= TourNummer, 3= Artikel Lagerplatz';

comment on column dirkspzm32.mfr_element_cfg.strategie_rbg_ausl_verfahren is
    'Kann  RBG Verfahraufträge,  um Auslageraufträge zu Optimieren ';

comment on column dirkspzm32.mfr_element_cfg.strategie_rbg_physikalisch is
    'FÜR WE und EP  Eintrag -> 01;02;03;';

comment on column dirkspzm32.mfr_element_cfg.strategie_rbg_verfuegbar is
    'FÜR WE und EP  Eintrag -> 01;02;03;';

comment on column dirkspzm32.mfr_element_cfg.strategie_reihenfolge_bis is
    'Reihenfolge suche bis LTE_ReihenfolgeNr';

comment on column dirkspzm32.mfr_element_cfg.strategie_reihenfolge_von is
    'Reihenfolge suche von LTE ReihenfolgeNr';

comment on column dirkspzm32.mfr_element_cfg.strategie_scann_betr_waehlen is
    'Scannerbetriebsvorwahl möglich ';

comment on column dirkspzm32.mfr_element_cfg.strategie_solldurchs_je_stunde is
    'SollDurchsatz jeStunde geplanter Durchsattz Ware je Stunde';

comment on column dirkspzm32.mfr_element_cfg.strategie_verl_st_vorg is
    'Verlade-Status vorgabe für eine Ziel Element';

comment on column dirkspzm32.mfr_element_cfg.telegr_fc is
    'SPS Auftrags Functionscode';

comment on column dirkspzm32.mfr_element_cfg.telegr_fe_id_anfang is
    'SPS Foerder element ID (Auftrags Quellbahn bzw. Auftrags Zielbahn) Anfangsposition in Transportrichtung';

comment on column dirkspzm32.mfr_element_cfg.telegr_fe_id_ende is
    'SPS Foerder element ID (Auftrags Quellbahn bzw. Auftrags Zielbahn) Endeposition in Transportrichtung';

comment on column dirkspzm32.mfr_element_cfg.telegr_konturen_kontrolle is
    'Konturenkontrolle ? an dieser Position';

comment on column dirkspzm32.mfr_element_cfg.telegr_koppl_nr is
    'Schnittstellennummer über die die Kommunikation zur SPS funktioniert';

comment on column dirkspzm32.mfr_element_cfg.telegr_meld_nr is
    'Meldungs nummer für die Fehler eingetragen wird';

comment on column dirkspzm32.mfr_element_cfg.telegr_mt_abmeldung is
    'SPS Palette abgemeldet';

comment on column dirkspzm32.mfr_element_cfg.telegr_mt_belegt is
    'SPS Palette Anmeldung';

comment on column dirkspzm32.mfr_element_cfg.telegr_mt_freiplatz is
    'SPS Platz wieder frei';

comment on column dirkspzm32.mfr_element_cfg.telegr_mt_we is
    'SPS Palette auf WE ';

comment on column dirkspzm32.mfr_element_cfg.telegr_paletten_hoehe is
    'Palettenhoehe an diser Position im Telegramm ?';

comment on column dirkspzm32.mfr_element_cfg.telegr_paletten_typ is
    'Palettentyp an dieser position im  Telegramm';

comment on column dirkspzm32.mfr_element_cfg.telegr_sps_bereich_nr is
    'Gruppen nummer, logischer getrennter Bereich';

comment on column dirkspzm32.mfr_element_cfg.transport_einheit is
    'Transportierte Ware ''LTE'' = Alle LTE_CFG, ''LHM'' = Alle LHM_CFG, ''LTE_LTE'' = LTE_CFG vom Transporttyp LTE oder ''LTE_LHM'' = LTE_CFG vom Transporttyp LHM'
    ;

comment on column dirkspzm32.mfr_element_cfg.transp_abgabe_verbote is
    '1;2; Semikolon getrennte ELEMENT_IX Liste aller Ziele,  die von diesem Element  nicht angesteuert werden dürfen.';

comment on column dirkspzm32.mfr_element_cfg.transp_aufnahme_verbote is
    '1;2; Semikolon getrennte ELEMENT_IX Liste aller Quellen, die von diesem Element  nicht angesteuert werden dürfen.';

comment on column dirkspzm32.mfr_element_cfg.transp_log is
    'Log Transport in MFR_TRANSP_LOG  0= Aus; 1= Aufnahme; 2= Abgabe; 3= Halb; 4= Voll;';

comment on column dirkspzm32.mfr_element_cfg.zusatz_logik_namen is
    'Zusatz Logik Namen // Kontrollscann AUfgabe Automatischer WT....';

comment on column dirkspzm32.mfr_element_cfg.zustandsautomat_meld_gruppe is
    'Zeigt auf die Meldgruppe für die SPS StateMachine Anzeige';


-- sqlcl_snapshot {"hash":"03823aafacf9f322b224c382fbad22fb26a08586","type":"COMMENT","name":"mfr_element_cfg","schemaName":"dirkspzm32","sxml":""}