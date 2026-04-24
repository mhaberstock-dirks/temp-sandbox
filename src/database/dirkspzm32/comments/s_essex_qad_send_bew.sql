comment on table dirkspzm32.s_essex_qad_send_bew is
    'Bewegungsdaten aus ISIPlus';

comment on column dirkspzm32.s_essex_qad_send_bew.aktion is
    'AV = Status in Vorbereitung AA = Status Angefangen AR = Status Rüsten  AP = Status Produktion UE = Im ISIPlus übernommen, L = Position im ISIPlus gelöscht LIF = Lieferschein fertig BEF = Bestellung Fertig F = Prod. Fertig TF = Prod. Teilfertig STB = Störung Beginn STG = Störung begründen STE = Störung Ende WEI = Zugang Intern (z.B. Produktion) UWAI = Abgang Intern (z.B. Maschine) Ungeplant
 WAI = Abgang Intern (z.B. Maschine) WEE = Zugang Extern (Warenanlieferung) WAE = Abgang Extern (Versand von Ware) WUI = Umlagerung Intern WUE = Umlagerung Extern BAG = Bestandsabgleich INV = Inventur FRE = Freigeben SPR = Sperren'
    ;

comment on column dirkspzm32.s_essex_qad_send_bew.arbeitsplatz_id is
    'Arbeitsplatz der Versands bei Auslieferung';

comment on column dirkspzm32.s_essex_qad_send_bew.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_essex_qad_send_bew.auf_id is
    'eindeutige Sequenz-Nummer in Tabelle (S_essex_qad_RES...) oder Sequenz-Nummer aus ISIPlus wenn TABELLE = NULL';

comment on column dirkspzm32.s_essex_qad_send_bew.brutto_kg is
    'Brutto KG Gewicht für Rückmeldung im Lieferschein (LIF)';

comment on column dirkspzm32.s_essex_qad_send_bew.b_date is
    'Buchungszeitpunkt als Date';

comment on column dirkspzm32.s_essex_qad_send_bew.b_datum is
    'Buchungszeitpunkt';

comment on column dirkspzm32.s_essex_qad_send_bew.charge is
    'Charge des Materials';

comment on column dirkspzm32.s_essex_qad_send_bew.cycle is
    'Anzahl der Versuche der Übertragung  (Versuchszähler)';

comment on column dirkspzm32.s_essex_qad_send_bew.ext_best_nr is
    'Externe Bestellnummer bei Anlieferungen
';

comment on column dirkspzm32.s_essex_qad_send_bew.ext_best_pos is
    'Externe Bestellposition bei Anlieferungen
';

comment on column dirkspzm32.s_essex_qad_send_bew.ext_lief_nr is
    'Externe Lieferscheinnummer bei Anlieferungen';

comment on column dirkspzm32.s_essex_qad_send_bew.ext_lief_pos is
    'Externe Lieferscheinposition bei Anlieferungen';

comment on column dirkspzm32.s_essex_qad_send_bew.fa_ag is
    'Vorgangsnummer in SAP
';

comment on column dirkspzm32.s_essex_qad_send_bew.fa_upos is
    'Unterposition für Gruppenarbeit
';

comment on column dirkspzm32.s_essex_qad_send_bew.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_essex_qad_send_bew.herkunft is
    '"ISI" immer konstant';

comment on column dirkspzm32.s_essex_qad_send_bew.ist_bestand is
    'IST_BESTAND für BAG oder INV';

comment on column dirkspzm32.s_essex_qad_send_bew.lagerort is
    'Lagerort im SAP';

comment on column dirkspzm32.s_essex_qad_send_bew.leitzahl is
    'Fertigungsauftrag in SAP
';

comment on column dirkspzm32.s_essex_qad_send_bew.lhm_nr is
    'Nummer des Lagerhilfsmittel (Barcode)';

comment on column dirkspzm32.s_essex_qad_send_bew.lte_nr is
    'Nummer der Transporteinheit (Barcode)';

comment on column dirkspzm32.s_essex_qad_send_bew.ma_id is
    'Maschinen ID aus SAP';

comment on column dirkspzm32.s_essex_qad_send_bew.ma_status is
    'Maschinenstatus P = Produktion U = Unterbrechung';

comment on column dirkspzm32.s_essex_qad_send_bew.ma_s_grund is
    'Störgrundnummer';

comment on column dirkspzm32.s_essex_qad_send_bew.me is
    'Mengeneinheit aus isi-artikel
';

comment on column dirkspzm32.s_essex_qad_send_bew.menge is
    '1.Wahl Stück (LVS / BDE) oder Störgrund';

comment on column dirkspzm32.s_essex_qad_send_bew.menge_b is
    'B Qualität Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_essex_qad_send_bew.prodzeit_ist is
    'Produktionszeit in Minuten';

comment on column dirkspzm32.s_essex_qad_send_bew.ret_code is
    'Returncode aus Übertragung';

comment on column dirkspzm32.s_essex_qad_send_bew.ruestzeit_ist is
    'Rüstzeit in Minuten (Produktionsfertigmeldung)';

comment on column dirkspzm32.s_essex_qad_send_bew.r_menge is
    'Menge Rüsten 1.Wahl Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_essex_qad_send_bew.r_menge_b is
    'Menge Rüsten B Qualität Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_essex_qad_send_bew.r_schrott is
    'Schrottmenge beim Rüsten in Stück';

comment on column dirkspzm32.s_essex_qad_send_bew.schrott is
    'Schrottmenge in Stück';

comment on column dirkspzm32.s_essex_qad_send_bew.serie is
    'Seriennummer des Materials';

comment on column dirkspzm32.s_essex_qad_send_bew.status is
    'N = Neu, im SAP noch nicht Übernommen U = Ist in übertragung, UE = SAP hat den Satz übernommen, ERR = Fehler, D = Delete -> ISIPlus kann den Eintrag Löschen'
    ;

comment on column dirkspzm32.s_essex_qad_send_bew.stoerzeit_ist is
    'Störzeit in Minuten (Produktionsfertigmeldung)';

comment on column dirkspzm32.s_essex_qad_send_bew.tabelle is
    'NULL = Keine Referenz zu SAP Tabellen sonst Tabellenname';

comment on column dirkspzm32.s_essex_qad_send_bew.ts is
    'ID der Übertragung';

comment on column dirkspzm32.s_essex_qad_send_bew.zlagerort is
    'Ziellagerort im SAP';


-- sqlcl_snapshot {"hash":"f6f2b4ac7c7596f6790b5a576789ef119f3539de","type":"COMMENT","name":"s_essex_qad_send_bew","schemaName":"dirkspzm32","sxml":""}