comment on table dirkspzm32.s_send_bew is
    'Bewegungsdaten aus ISIPlus';

comment on column dirkspzm32.s_send_bew.aktion is
    'AV = Status in Vorbereitung AA = Status Angefangen AR = Status Rüsten  AP = Status Produktion UE = Im ISIPlus übernommen L = Position im ISIPlus gelöscht F = Position komplett Fertig TF = Position ist Teilfertig STB = Störung Beginn STG = Störung begründen STE = Störung Ende WEI = Zugang Intern (z.B. Produktion) WAI = Abgang Intern (z.B. Maschine) WEE = Zugang Extern (Warenanlieferung) WAE = Abgang Extern (Versand von Ware) WUI = Umlagerung Intern WUE = Umlagerung Extern BAG = Bestandsabgleich INV = Inventur FRE = Freigeben SPR = Sperren'
    ;

comment on column dirkspzm32.s_send_bew.arbeitsplatz_id is
    'Arbeitsplatz der Versands bei Auslieferung';

comment on column dirkspzm32.s_send_bew.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_send_bew.auf_id is
    'eindeutige Sequenz-Nummer in Tabelle (S_RES...) oder Sequenz-Nummer aus ISIPlus wenn TABELLE = NULL';

comment on column dirkspzm32.s_send_bew.brutto_kg is
    'Brutto KG Gewicht für Rückmeldung im Lieferschein (LIF)';

comment on column dirkspzm32.s_send_bew.b_datum is
    'Buchungszeitpunkt';

comment on column dirkspzm32.s_send_bew.charge is
    'Charge des Materials';

comment on column dirkspzm32.s_send_bew.err_nr is
    'Fehlernummer z.B. 1 = LTE nicht vorhanden2 = LTE schon disponiert3 = Artikelnr fehlt';

comment on column dirkspzm32.s_send_bew.ext_lief_nr is
    'Externe Lieferscheinnummer bei Anlieferungen';

comment on column dirkspzm32.s_send_bew.ext_lief_pos is
    'Externe Lieferscheinposition bei Anlieferungen';

comment on column dirkspzm32.s_send_bew.fa_ag is
    'Arbeitsgang';

comment on column dirkspzm32.s_send_bew.fa_upos is
    'Unterposition';

comment on column dirkspzm32.s_send_bew.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_send_bew.herkunft is
    '"ISI" immer konstant';

comment on column dirkspzm32.s_send_bew.ist_bestand is
    'IST_BESTAND für BAG oder INV';

comment on column dirkspzm32.s_send_bew.labor_status is
    'Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung'
    ;

comment on column dirkspzm32.s_send_bew.lagerort is
    'Lagerort im HOST';

comment on column dirkspzm32.s_send_bew.lagerplatz is
    'Lagerplatz im ISI';

comment on column dirkspzm32.s_send_bew.lam_ag is
    'AG aus LAM (Zwischenprodukt)';

comment on column dirkspzm32.s_send_bew.lam_bh_id is
    'ID der Buchung';

comment on column dirkspzm32.s_send_bew.lam_bh_typ is
    'LA, LZ oder LU Lagerabgang, Zugang oder Umlagerung';

comment on column dirkspzm32.s_send_bew.lam_id is
    'ID aus LVS_LAM';

comment on column dirkspzm32.s_send_bew.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_send_bew.leitzahl is
    'Leitzahl aus FA_Auftrag';

comment on column dirkspzm32.s_send_bew.lhm_nr is
    'Nummer des Lagerhilfsmittel (Barcode)';

comment on column dirkspzm32.s_send_bew.lte_name is
    'Art, Name der Transporteinheit';

comment on column dirkspzm32.s_send_bew.lte_nr is
    'Nummer der Transporteinheit (Barcode)';

comment on column dirkspzm32.s_send_bew.ma_id is
    'Maschinen ID aus HOST';

comment on column dirkspzm32.s_send_bew.ma_last_s_grund is
    'Letzter Status Grund (Vor diesen aktuelle Status)';

comment on column dirkspzm32.s_send_bew.ma_status is
    'Maschinenstatus P = Produktion U = Unterbrechung';

comment on column dirkspzm32.s_send_bew.ma_s_grund is
    'Störgrundnummer';

comment on column dirkspzm32.s_send_bew.menge is
    '1.Wahl Stück (LVS / BDE) oder Störgrund';

comment on column dirkspzm32.s_send_bew.menge_b is
    'B Qualität Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_send_bew.order_pos_auf_id is
    'Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)';

comment on column dirkspzm32.s_send_bew.pers_nr is
    'Personalnummer des Benutzers (Bei integriertem PZM wir die Personalnumme und die Kontaktdaten von PZM übersteuert (Trigger im PZM)'
    ;

comment on column dirkspzm32.s_send_bew.prodzeit_ist is
    'Produktionszeit in Minuten';

comment on column dirkspzm32.s_send_bew.prod_zeit_erf is
    'Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden';

comment on column dirkspzm32.s_send_bew.res_id is
    'Res_id der Erzeugermaschine';

comment on column dirkspzm32.s_send_bew.ruestzeit_ist is
    'Rüstzeit in Minuten (Produktionsfertigmeldung)';

comment on column dirkspzm32.s_send_bew.ruest_zeit_erf is
    'Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden';

comment on column dirkspzm32.s_send_bew.r_menge is
    'Menge Rüsten 1.Wahl Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_send_bew.r_menge_b is
    'Menge Rüsten B Qualität Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_send_bew.r_schrott is
    'Schrottmenge beim Rüsten in Stück';

comment on column dirkspzm32.s_send_bew.schrott is
    'Schrottmenge in Stück';

comment on column dirkspzm32.s_send_bew.send_id is
    'ID, mit der diese Bewegung versendet wurde';

comment on column dirkspzm32.s_send_bew.serie is
    'Seriennummer des Materials';

comment on column dirkspzm32.s_send_bew.sper_grund is
    'Sperr- oder Schrottgrund aus LAM. LABOR_TEXT';

comment on column dirkspzm32.s_send_bew.status is
    'NULL = Im HOST noch nicht Übernommen UE = HOST hat den Satz übernommen A = HOST hat Angefangen F = HOST ist Fertig L = ISIPlus kann den Eintrag Löschen, SB/SE/SW = Schicht Beg./Ende/Wechsel, RS/RE/PS/PE = Auftrag Start/Ende Rüsten Produktion, SG = Statusgrund gewechselt'
    ;

comment on column dirkspzm32.s_send_bew.stoerzeit_ist is
    'Störzeit in Minuten (Produktionsfertigmeldung)';

comment on column dirkspzm32.s_send_bew.tabelle is
    'NULL = Keine Referenz zu HOST Tabellen sonst Tabellenname';

comment on column dirkspzm32.s_send_bew.text is
    'Rückgabetext';

comment on column dirkspzm32.s_send_bew.user_name is
    'Username aus ISI_User';

comment on column dirkspzm32.s_send_bew.zlagerort is
    'Ziellagerort im HOST';

comment on column dirkspzm32.s_send_bew.zlagerplatz is
    'Ziellagerplatz im ISI';


-- sqlcl_snapshot {"hash":"d3d550ff2c7d798b33399b6400ebeac343ce293b","type":"COMMENT","name":"s_send_bew","schemaName":"dirkspzm32","sxml":""}