comment on table dirkspzm32.s_rcv_dis_to_order is
    'Aufträge, die mit einem DIS-Prozess in die ISI-Order transportiert werden sollen';

comment on column dirkspzm32.s_rcv_dis_to_order.adr_art is
    'K = Kunde L = Lieferant';

comment on column dirkspzm32.s_rcv_dis_to_order.adr_liefer is
    'Lieferadresse bei Kunden aus ADR';

comment on column dirkspzm32.s_rcv_dis_to_order.adr_nr is
    'Kunden oder Lieferanten-Nummer aus ADR';

comment on column dirkspzm32.s_rcv_dis_to_order.anbruch is
    'Anbruchpalette T = Nur Anbruch, F = Nur Vollpaletten, V = Vorzug Anbruch, A = Ausnahmsweise Anbruch I = IGNORE (Egal)';

comment on column dirkspzm32.s_rcv_dis_to_order.arbeitsplatz_id is
    'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';

comment on column dirkspzm32.s_rcv_dis_to_order.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_rcv_dis_to_order.auftrag is
    'Auftragsnummer aus dem Host-System (Nicht die ID)';

comment on column dirkspzm32.s_rcv_dis_to_order.auf_id is
    'eindeutige Sequenz-Nummer in der ISI_ORDER kann hier mehrfach vorkommen (Referenz)';

comment on column dirkspzm32.s_rcv_dis_to_order.bearb_datum is
    'Bearbeitungsdatum, zuletzt bearbeitet am';

comment on column dirkspzm32.s_rcv_dis_to_order.besteller is
    'Aktor des Vorgangs z.B. HOST WAWI, ....';

comment on column dirkspzm32.s_rcv_dis_to_order.best_nr_kunde is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.s_rcv_dis_to_order.charge is
    'Charge';

comment on column dirkspzm32.s_rcv_dis_to_order.erstell_datum is
    'Erstellungsdatum, erstellt am';

comment on column dirkspzm32.s_rcv_dis_to_order.fa_ag is
    'Arbeitsgang';

comment on column dirkspzm32.s_rcv_dis_to_order.fehler_code is
    'Host-Übertragung Fehlernummer';

comment on column dirkspzm32.s_rcv_dis_to_order.fehler_text is
    'Host-Übertragung Fehlertext';

comment on column dirkspzm32.s_rcv_dis_to_order.freigabe is
    'M = Manuelle Freigabe, A = Automatisch Freigeben zum Datum, E = Paletten Einzelanforderung';

comment on column dirkspzm32.s_rcv_dis_to_order.freigabe_datum is
    'FREIGABE = früheste Startzeit';

comment on column dirkspzm32.s_rcv_dis_to_order.komm_ganz_gebinde is
    'Ganzes Gebinde;
T=Es müssen ganze Gebinde genommen werden. Die Gebinde dürfen geöffnet werden
F=Es müssen nicht nicht ganze Gebinde genommen werden. Es dürfen Teilmengen entnommen werden';

comment on column dirkspzm32.s_rcv_dis_to_order.komm_steuerung is
    'Roboter Steuerung (Automatisches DEPAL oder Palettieren);
A=Automatisch ISIPlus entscheidet,
R=Kommissionierung Roboter
M=Kommissionierung Manuell';

comment on column dirkspzm32.s_rcv_dis_to_order.komplett_bereitstellen is
    'Warten im Loop vor der Bereitstellung; T=Ja bedeutet Warten bis alle Positionen im Loop umschalten, F=Nein wartet nicht auf alle gebinde, sonder wird ausgelagert wen möglich; '
    ;

comment on column dirkspzm32.s_rcv_dis_to_order.komplett_reservieren is
    'Grossauftrag-Strategie; Komplett-Lieferung
T=Ja    Alle Gebinte werden zum Start des Auftrags disponiert
F=Nein  Der Auftrag ist zu groß, nicht alle Gebinde können zu beginn des Autfrags disponiert werden, da diese andere dann blockieren würden. Schubweise Nachdisponieren'
    ;

comment on column dirkspzm32.s_rcv_dis_to_order.kom_info is
    'zus. Info für Kommissionierer';

comment on column dirkspzm32.s_rcv_dis_to_order.kom_mengeneinheit is
    'Mengeneinheit, für Kommissionierer';

comment on column dirkspzm32.s_rcv_dis_to_order.kom_mg is
    'Menge Kommissionierer evtl hier Anzahl Karton';

comment on column dirkspzm32.s_rcv_dis_to_order.konsolidieren is
    'K=Nachschub Konsolidieren zusammenfassen in der ISI_ORDER, E=Einzelposition und im Vorgang in der ISI_ORDER';

comment on column dirkspzm32.s_rcv_dis_to_order.labor_status is
    'DEFAULT = ''F''rei -> Zu vernendende Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung'
    ;

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_rcv_dis_to_order.leitzahl is
    'Leitzahl Fertigungsauftrag';

comment on column dirkspzm32.s_rcv_dis_to_order.liefer_datum is
    'Gewünsches Lieferdatum';

comment on column dirkspzm32.s_rcv_dis_to_order.li_nr is
    'Lieferschein Nummer';

comment on column dirkspzm32.s_rcv_dis_to_order.li_pos_nr is
    'Lieferscheinposition -Nummer';

comment on column dirkspzm32.s_rcv_dis_to_order.mhd is
    'MHD';

comment on column dirkspzm32.s_rcv_dis_to_order.pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.s_rcv_dis_to_order.prioritaet is
    'Priorität (0..9), 9: hohe Priorität';

comment on column dirkspzm32.s_rcv_dis_to_order.prod_params is
    'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';

comment on column dirkspzm32.s_rcv_dis_to_order.quell_lagerorte is
    'Lagerorte aus denen diese Ware entnommen werden kann';

comment on column dirkspzm32.s_rcv_dis_to_order.satzart is
    'BE = Bestellung LI = Anstehende Lieferung MA = Maschinenanforderung LA = Lageranforderung LU = Umlagerung RL/RK = Retouren LK/BK = KONSI'
    ;

comment on column dirkspzm32.s_rcv_dis_to_order.seriennr is
    'Serien-Nummer';

comment on column dirkspzm32.s_rcv_dis_to_order.soll_mengeneinheit is
    'Mengeneinheit Lagerbestand im ISI';

comment on column dirkspzm32.s_rcv_dis_to_order.soll_mg is
    'Soll-Menge Hier evtl. Stück';

comment on column dirkspzm32.s_rcv_dis_to_order.strategie is
    'FIFO, LIFO';

comment on column dirkspzm32.s_rcv_dis_to_order.s_rcv_dis_to_order_id is
    'eindeutige Sequenz-Nummer';

comment on column dirkspzm32.s_rcv_dis_to_order.tour is
    'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';

comment on column dirkspzm32.s_rcv_dis_to_order.uebert_status is
    'Host-Übertragung Status; N=Neu noch nicht übernommen, U=In Übertragung, UE=erfolgreich übertragen, ERR=Fehler, D=Delete, zum löschen markiert'
    ;

comment on column dirkspzm32.s_rcv_dis_to_order.ueber_unter_liefern is
    'Nachschub (OL);
ULTE=Underdelivery LTE bedeutet, dass solange Paletten genommen werden, bis maximal die Menge erreicht ist. Bei der ersten Palette, die die Menge überschreitet wird die Reservierung beendet ohne diese zu reservieren
ULHM=Underdelivery LHM bedeutet, dass solange LHM (Kartons) genommen werden, bis maximal die Menge erreicht ist. Bei dem ersten LHM, das die Menge überschreitet wird die Reservierung beendet ohne dieses zu reservieren
EX=exakte Lieferung Die Menge muss exakt eingehalten werden, evtl. mit Einzelentnahmen in der Kommissionierung,
OLTE=Overdelivery LTE bedeutet, dass solange LTEs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LTE mit der die Menge überschritten wird, wird auch komplett reserviert
OLHM=Overdelivery LHM bedeutet, dass solange LHMs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LHM mit der die Menge überschritten wird, wird auch komplett reserviert
';

comment on column dirkspzm32.s_rcv_dis_to_order.upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';

comment on column dirkspzm32.s_rcv_dis_to_order.vorgang_id is
    'Nummer um die Positionen zu Klammern (Z.B. TourNr oder Sendungsnummer)';

comment on column dirkspzm32.s_rcv_dis_to_order.wa_ziel is
    'SPED = Spedition SELB = Selbstabholer UPS = UPS DPAD = Paketversand';

comment on column dirkspzm32.s_rcv_dis_to_order.ziel is
    'Transportziel';

comment on column dirkspzm32.s_rcv_dis_to_order.ziel_packschema is
    'Ziel-Packschema, Nachschub T21';

comment on column dirkspzm32.s_rcv_dis_to_order.ziel_traeger is
    'Zieltraeger. z.B. Euro, HP; Ladungsträger bei Paletten, Behältertyp bei Behältern';

comment on column dirkspzm32.s_rcv_dis_to_order.ziel_traeger_menge is
    'Menge im Zieltraeger.';


-- sqlcl_snapshot {"hash":"8fc11fa37f5a1a4b9980e4ceaeada9ef7110691e","type":"COMMENT","name":"s_rcv_dis_to_order","schemaName":"dirkspzm32","sxml":""}