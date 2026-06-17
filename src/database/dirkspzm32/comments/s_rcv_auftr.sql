comment on table DIRKSPZM32.S_RCV_AUFTR is 'Bestellungen und Ladelisten die zur Verladung anstehen';
comment on column DIRKSPZM32.S_RCV_AUFTR."ADR_ART" is 'K = Kunde L = Lieferant';
comment on column DIRKSPZM32.S_RCV_AUFTR."ADR_LIEFER" is 'Lieferadresse bei Kunden aus ADR';
comment on column DIRKSPZM32.S_RCV_AUFTR."ADR_NR" is 'Kunden oder Lieferanten-Nummer aus ADR';
comment on column DIRKSPZM32.S_RCV_AUFTR."ANBRUCH" is 'Anbruchpalette T = Nur Anbruch, F = Nur Vollpaletten, V = Vorzug Anbruch, A = Ausnahmsweise Anbruch I = IGNORE (Egal)';
comment on column DIRKSPZM32.S_RCV_AUFTR."ARBEITSPLATZ_ID" is 'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';
comment on column DIRKSPZM32.S_RCV_AUFTR."ARTIKEL" is 'Artikelnummer';
comment on column DIRKSPZM32.S_RCV_AUFTR."AUFTRAG" is 'Auftragsnummer / Bestellung im DIAF';
comment on column DIRKSPZM32.S_RCV_AUFTR."AUF_ID" is 'eindeutige Sequenz-Nummer';
comment on column DIRKSPZM32.S_RCV_AUFTR."BESTELLER" is 'Aktor des Vorgangs z.B. HOST WAWI, ....';
comment on column DIRKSPZM32.S_RCV_AUFTR."BEST_NR_KUNDE" is 'Bestellnummer des Kunden';
comment on column DIRKSPZM32.S_RCV_AUFTR."CHARGE" is 'Charge';
comment on column DIRKSPZM32.S_RCV_AUFTR."FA_AG" is 'Arbeitsgang';
comment on column DIRKSPZM32.S_RCV_AUFTR."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.S_RCV_AUFTR."GEN_DATUM" is 'Generierungsdatum';
comment on column DIRKSPZM32.S_RCV_AUFTR."IST_MENGE" is 'Ist Menge';
comment on column DIRKSPZM32.S_RCV_AUFTR."KOM_INFO" is 'zus. Info für Kommissionierer';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL1" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL10" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL2" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL3" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL4" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL5" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL6" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL7" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL8" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LAM_SEL9" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_AUFTR."LEITZAHL" is 'Leitzahl Fertigungsauftrag';
comment on column DIRKSPZM32.S_RCV_AUFTR."LIEFER_DATUM" is 'Gewünsches Liefer/Transportdatum';
comment on column DIRKSPZM32.S_RCV_AUFTR."LI_NR" is 'Lieferschein Nummer';
comment on column DIRKSPZM32.S_RCV_AUFTR."LI_POS_NR" is 'Lieferscheinposition -Nummer';
comment on column DIRKSPZM32.S_RCV_AUFTR."LVS_INFO" is 'für Informationen vom LVS';
comment on column DIRKSPZM32.S_RCV_AUFTR."MHD" is 'MHD';
comment on column DIRKSPZM32.S_RCV_AUFTR."POS_NR" is 'Positionsnummer';
comment on column DIRKSPZM32.S_RCV_AUFTR."PRIORITAET" is 'Priorität (0..9), 9: hohe Priorität';
comment on column DIRKSPZM32.S_RCV_AUFTR."SATZART" is 'BE = Bestellung LI = Anstehende Lieferung';
comment on column DIRKSPZM32.S_RCV_AUFTR."SERIENNR" is 'Serien-Nummer';
comment on column DIRKSPZM32.S_RCV_AUFTR."SOLL_MG" is 'Soll-Menge';
comment on column DIRKSPZM32.S_RCV_AUFTR."STATUS" is 'NULL = Noch nicht angefangen V = In Vorbereitung F = Fertig A = AngefangenL = Löschen';
comment on column DIRKSPZM32.S_RCV_AUFTR."STRATEGIE" is 'FIFO, LIFO';
comment on column DIRKSPZM32.S_RCV_AUFTR."TOUR" is 'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';
comment on column DIRKSPZM32.S_RCV_AUFTR."UEBER_UNTER_LIEFERN" is 'Nachschub (OL);
ULTE=Underdelivery LTE bedeutet, dass solange Paletten genommen werden, bis maximal die Menge erreicht ist. Bei der ersten Palette, die die Menge überschreitet wird die Reservierung beendet ohne diese zu reservieren
ULHM=Underdelivery LHM bedeutet, dass solange LHM (Kartons) genommen werden, bis maximal die Menge erreicht ist. Bei dem ersten LHM, das die Menge überschreitet wird die Reservierung beendet ohne dieses zu reservieren
EX=exakte Lieferung Die Menge muss exakt eingehalten werden, evtl. mit Einzelentnahmen in der Kommissionierung,
OLTE=Overdelivery LTE bedeutet, dass solange LTEs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LTE mit der die Menge überschritten wird, wird auch komplett reserviert
OLHM=Overdelivery LHM bedeutet, dass solange LHMs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LHM mit der die Menge überschritten wird, wird auch komplett reserviert
';
comment on column DIRKSPZM32.S_RCV_AUFTR."UPOS_NR" is 'Unterposition Bsp.: Eine Position mit n Chargen etc.';
comment on column DIRKSPZM32.S_RCV_AUFTR."VORGANG" is 'Nummer um die Positionen zu Klammern';
comment on column DIRKSPZM32.S_RCV_AUFTR."WA_ZIEL" is 'SPED = Spedition SELB = Selbstabholer UPS = UPS DPAD = Paketversand';
comment on column DIRKSPZM32.S_RCV_AUFTR."ZIEL" is 'Transportziel';



-- sqlcl_snapshot {"hash":"32c17ae67a3c3a08a0d64fa6aba7ad8be1d9a592","type":"COMMENT","name":"s_rcv_auftr","schemaName":"dirkspzm32","sxml":""}