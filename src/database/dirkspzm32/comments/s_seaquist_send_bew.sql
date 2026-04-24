comment on table dirkspzm32.s_seaquist_send_bew is
    'Bewegungsdaten aus ISIPlus';

comment on column dirkspzm32.s_seaquist_send_bew.aktion is
    'AV = Status in Vorbereitung AA = Status Angefangen AR = Status Rüsten  AP = Status Produktion UE = Im ISIPlus übernommen L = Position im ISIPlus gelöscht LIF = Lieferschein fertig BEF = Bestellung Fertig F = Prod. Fertig TF = Prod. Teilfertig STB = Störung Beginn STG = Störung begründen STE = Störung Ende WEI = Zugang Intern (z.B. Produktion) WAI = Abgang Intern (z.B. Maschine) WEE = Zugang Extern (Warenanlieferung) WAE = Abgang Extern (Versand von Ware) WUI = Umlagerung Intern WUE = Umlagerung Extern BAG = Bestandsabgleich INV = Inventur FRE = Freigeben SPR = Sperren'
    ;

comment on column dirkspzm32.s_seaquist_send_bew.arb_pl_id is
    'Arbeitsplatz der Versands bei Auslieferung';

comment on column dirkspzm32.s_seaquist_send_bew.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_seaquist_send_bew.auf_id is
    'eindeutige Sequenz-Nummer in Tabelle (S_SeaQuist_RES...) oder Sequenz-Nummer aus ISIPlus wenn TABELLE = NULL';

comment on column dirkspzm32.s_seaquist_send_bew.bew_id is
    'Eindeutig ID';

comment on column dirkspzm32.s_seaquist_send_bew.brutto_kg is
    'Brutto KG Gewicht für Rückmeldung im Lieferschein (LIF)';

comment on column dirkspzm32.s_seaquist_send_bew.b_datum is
    'Buchungszeitpunkt';

comment on column dirkspzm32.s_seaquist_send_bew.charge is
    'Charge des Materials';

comment on column dirkspzm32.s_seaquist_send_bew.ext_lie_nr is
    'Externe Lieferscheinnummer bei Anlieferungen';

comment on column dirkspzm32.s_seaquist_send_bew.ext_lie_po is
    'Externe Lieferscheinposition bei Anlieferungen';

comment on column dirkspzm32.s_seaquist_send_bew.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_seaquist_send_bew.herkunft is
    '"ISI" immer konstant';

comment on column dirkspzm32.s_seaquist_send_bew.ist_best is
    'IST_BESTAND für BAG oder INV';

comment on column dirkspzm32.s_seaquist_send_bew.lagerort is
    'Lagerort im SeaQuist';

comment on column dirkspzm32.s_seaquist_send_bew.lhm_nr is
    'Nummer des Lagerhilfsmittel (Barcode)';

comment on column dirkspzm32.s_seaquist_send_bew.lte_nr is
    'Nummer der Transporteinheit (Barcode)';

comment on column dirkspzm32.s_seaquist_send_bew.ma_id is
    'Maschinen ID aus SeaQuist';

comment on column dirkspzm32.s_seaquist_send_bew.ma_status is
    'Maschinenstatus P = Produktion U = Unterbrechung';

comment on column dirkspzm32.s_seaquist_send_bew.ma_s_grund is
    'Störgrundnummer';

comment on column dirkspzm32.s_seaquist_send_bew.menge is
    '1.Wahl Stück (LVS / BDE) oder Störgrund';

comment on column dirkspzm32.s_seaquist_send_bew.menge_b is
    'B Qualität Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_seaquist_send_bew.prodz_ist is
    'Produktionszeit in Minuten';

comment on column dirkspzm32.s_seaquist_send_bew.ruestz_ist is
    'Rüstzeit in Minuten (Produktionsfertigmeldung)';

comment on column dirkspzm32.s_seaquist_send_bew.r_menge is
    'Menge Rüsten 1.Wahl Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_seaquist_send_bew.r_menge_b is
    'Menge Rüsten B Qualität Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_seaquist_send_bew.r_schrott is
    'Schrottmenge beim Rüsten in Stück';

comment on column dirkspzm32.s_seaquist_send_bew.schrott is
    'Schrottmenge in Stück';

comment on column dirkspzm32.s_seaquist_send_bew.serie is
    'Seriennummer des Materials';

comment on column dirkspzm32.s_seaquist_send_bew.status is
    'NULL = Im SeaQuist noch nicht Übernommen UE = SeaQuist hat den Satz übernommen A = SeaQuist hat Angefangen F = SeaQuist ist Fertig L = ISIPlus kann den Eintrag Löschen'
    ;

comment on column dirkspzm32.s_seaquist_send_bew.stoerz_ist is
    'Störzeit in Minuten (Produktionsfertigmeldung)';

comment on column dirkspzm32.s_seaquist_send_bew.tabelle is
    'NULL = Keine Referenz zu SeaQuist Tabellen sonst Tabellenname';

comment on column dirkspzm32.s_seaquist_send_bew.zlagerort is
    'Ziellagerort im SeaQuist';


-- sqlcl_snapshot {"hash":"0afc0ad44fbfb043f88c8fe74e1cd586e8c42412","type":"COMMENT","name":"s_seaquist_send_bew","schemaName":"dirkspzm32","sxml":""}