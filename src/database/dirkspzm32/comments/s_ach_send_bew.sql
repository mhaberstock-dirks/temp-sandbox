comment on table dirkspzm32.s_ach_send_bew is
    'Bewegungsdaten aus ISIPlus';

comment on column dirkspzm32.s_ach_send_bew.aktion is
    'AV = Status in Vorbereitung AA = Status Angefangen AR = Status Rüsten  AP = Status Produktion UE = Im ISIPlus übernommen L = Position im ISIPlus gelöscht LIF = Lieferschein fertig BEF = Bestellung Fertig F = Prod. Fertig TF = Prod. Teilfertig STB = Störung Beginn STG = Störung begründen STE = Störung Ende WEI = Zugang Intern (z.B. Produktion) WAI = Abgang Intern (z.B. Maschine) WEE = Zugang Extern (Warenanlieferung) WAE = Abgang Extern (Versand von Ware) WUI = Umlagerung Intern WUE = Umlagerung Extern BAG = Bestandsabgleich INV = Inventur FRE = Freigeben SPR = Sperren'
    ;

comment on column dirkspzm32.s_ach_send_bew.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_ach_send_bew.auf_id is
    'eindeutige Sequenz-Nummer in Tabelle (S_ACH_RES...) oder Sequenz-Nummer aus ISIPlus wenn TABELLE = NULL';

comment on column dirkspzm32.s_ach_send_bew.bew_id is
    'Eindeutige Nummer der Bewegung';

comment on column dirkspzm32.s_ach_send_bew.b_datum is
    'Buchungszeitpunkt';

comment on column dirkspzm32.s_ach_send_bew.err_nr is
    'Fehlernummer z.B. 1 = LTE nicht vorhanden2 = LTE schon disponiert3 = Artikelnr fehlt';

comment on column dirkspzm32.s_ach_send_bew.ext_lief_nr is
    'Externe Lieferscheinnummer bei Anlieferungen';

comment on column dirkspzm32.s_ach_send_bew.ext_lief_pos is
    'Externe Lieferscheinposition bei Anlieferungen';

comment on column dirkspzm32.s_ach_send_bew.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_ach_send_bew.herkunft is
    '"ISI" immer konstant';

comment on column dirkspzm32.s_ach_send_bew.ist_bestand is
    'IST_BESTAND für BAG oder INV';

comment on column dirkspzm32.s_ach_send_bew.lagerort is
    'Lagerort im ACH';

comment on column dirkspzm32.s_ach_send_bew.lhm_id is
    'Nummer des Lagerhilfsmittel (Barcode)';

comment on column dirkspzm32.s_ach_send_bew.lte_id is
    'Nummer der Transporteinheit (Barcode)';

comment on column dirkspzm32.s_ach_send_bew.menge is
    '1.Wahl Stück (LVS / BDE) oder Störgrund';

comment on column dirkspzm32.s_ach_send_bew.status is
    'NULL = Im ACH noch nicht Übernommen UE = ACH hat den Satz übernommen A = ACH hat Angefangen F = ACH ist Fertig L = ISIPlus kann den Eintrag Löschen'
    ;

comment on column dirkspzm32.s_ach_send_bew.tabelle is
    'NULL = Keine Referenz zu ACH Tabellen sonst Tabellenname';

comment on column dirkspzm32.s_ach_send_bew.text is
    'Rückgabetext';


-- sqlcl_snapshot {"hash":"7bb62e79d9a08132ae0c0f9dabe68925bc67638e","type":"COMMENT","name":"s_ach_send_bew","schemaName":"dirkspzm32","sxml":""}