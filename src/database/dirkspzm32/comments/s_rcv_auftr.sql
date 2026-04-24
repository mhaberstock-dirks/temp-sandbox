comment on table dirkspzm32.s_rcv_auftr is
    'Bestellungen und Ladelisten die zur Verladung anstehen';

comment on column dirkspzm32.s_rcv_auftr.adr_art is
    'K = Kunde L = Lieferant';

comment on column dirkspzm32.s_rcv_auftr.adr_liefer is
    'Lieferadresse bei Kunden aus ADR';

comment on column dirkspzm32.s_rcv_auftr.adr_nr is
    'Kunden oder Lieferanten-Nummer aus ADR';

comment on column dirkspzm32.s_rcv_auftr.anbruch is
    'Anbruchpalette T = Nur Anbruch, F = Nur Vollpaletten, V = Vorzug Anbruch, A = Ausnahmsweise Anbruch I = IGNORE (Egal)';

comment on column dirkspzm32.s_rcv_auftr.arbeitsplatz_id is
    'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';

comment on column dirkspzm32.s_rcv_auftr.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_rcv_auftr.auftrag is
    'Auftragsnummer / Bestellung im DIAF';

comment on column dirkspzm32.s_rcv_auftr.auf_id is
    'eindeutige Sequenz-Nummer';

comment on column dirkspzm32.s_rcv_auftr.besteller is
    'Aktor des Vorgangs z.B. HOST WAWI, ....';

comment on column dirkspzm32.s_rcv_auftr.best_nr_kunde is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.s_rcv_auftr.charge is
    'Charge';

comment on column dirkspzm32.s_rcv_auftr.fa_ag is
    'Arbeitsgang';

comment on column dirkspzm32.s_rcv_auftr.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_rcv_auftr.gen_datum is
    'Generierungsdatum';

comment on column dirkspzm32.s_rcv_auftr.ist_menge is
    'Ist Menge';

comment on column dirkspzm32.s_rcv_auftr.kom_info is
    'zus. Info für Kommissionierer';

comment on column dirkspzm32.s_rcv_auftr.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_auftr.leitzahl is
    'Leitzahl Fertigungsauftrag';

comment on column dirkspzm32.s_rcv_auftr.liefer_datum is
    'Gewünsches Liefer/Transportdatum';

comment on column dirkspzm32.s_rcv_auftr.li_nr is
    'Lieferschein Nummer';

comment on column dirkspzm32.s_rcv_auftr.li_pos_nr is
    'Lieferscheinposition -Nummer';

comment on column dirkspzm32.s_rcv_auftr.lvs_info is
    'für Informationen vom LVS';

comment on column dirkspzm32.s_rcv_auftr.mhd is
    'MHD';

comment on column dirkspzm32.s_rcv_auftr.pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.s_rcv_auftr.prioritaet is
    'Priorität (0..9), 9: hohe Priorität';

comment on column dirkspzm32.s_rcv_auftr.satzart is
    'BE = Bestellung LI = Anstehende Lieferung';

comment on column dirkspzm32.s_rcv_auftr.seriennr is
    'Serien-Nummer';

comment on column dirkspzm32.s_rcv_auftr.soll_mg is
    'Soll-Menge';

comment on column dirkspzm32.s_rcv_auftr.status is
    'NULL = Noch nicht angefangen V = In Vorbereitung F = Fertig A = AngefangenL = Löschen';

comment on column dirkspzm32.s_rcv_auftr.strategie is
    'FIFO, LIFO';

comment on column dirkspzm32.s_rcv_auftr.tour is
    'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';

comment on column dirkspzm32.s_rcv_auftr.ueber_unter_liefern is
    'Nachschub (OL);
ULTE=Underdelivery LTE bedeutet, dass solange Paletten genommen werden, bis maximal die Menge erreicht ist. Bei der ersten Palette, die die Menge überschreitet wird die Reservierung beendet ohne diese zu reservieren
ULHM=Underdelivery LHM bedeutet, dass solange LHM (Kartons) genommen werden, bis maximal die Menge erreicht ist. Bei dem ersten LHM, das die Menge überschreitet wird die Reservierung beendet ohne dieses zu reservieren
EX=exakte Lieferung Die Menge muss exakt eingehalten werden, evtl. mit Einzelentnahmen in der Kommissionierung,
OLTE=Overdelivery LTE bedeutet, dass solange LTEs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LTE mit der die Menge überschritten wird, wird auch komplett reserviert
OLHM=Overdelivery LHM bedeutet, dass solange LHMs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LHM mit der die Menge überschritten wird, wird auch komplett reserviert
';

comment on column dirkspzm32.s_rcv_auftr.upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';

comment on column dirkspzm32.s_rcv_auftr.vorgang is
    'Nummer um die Positionen zu Klammern';

comment on column dirkspzm32.s_rcv_auftr.wa_ziel is
    'SPED = Spedition SELB = Selbstabholer UPS = UPS DPAD = Paketversand';

comment on column dirkspzm32.s_rcv_auftr.ziel is
    'Transportziel';


-- sqlcl_snapshot {"hash":"da04cf3059f642793816e9fc44e45fe644bb4a56","type":"COMMENT","name":"s_rcv_auftr","schemaName":"dirkspzm32","sxml":""}