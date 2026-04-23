comment on table dirkspzm32.s_erp_send_bew is
    'Materialbuchung Bestandsübergabe werden von ISIPlus an COMUL übertragen';

comment on column dirkspzm32.s_erp_send_bew.aktion is
    'AV = Status in Vorbereitung
AA = Status Angefangen
AR = Status Rüsten
AP = Status Produktion
L = Position im ISIPlus gelöscht
LIF = Lieferschein fertig
BEF = Bestellung Fertig
F = Prod. Fertig
TF = Prod. Teilfertig
STB = Störung Beginn
STG = Störung begründen
STE = Störung Ende
WEI = Zugang Intern (z.B. Produktion)
UWAI = Abgang Intern (z.B. Maschine) Ungeplant
WAI = Abgang Intern (z.B. Maschine)
WEE = Zugang Extern (Warenanlieferung)
WAE = Abgang Extern (Versand von Ware)
WUI = Umlagerung Intern
WUE = Umlagerung Extern
BAG = Bestandsabgleich
INV = Inventur
FRE = Freigeben
SPR = Sperren';

comment on column dirkspzm32.s_erp_send_bew.aktion_host is
    'Aktion oder Message die dem Host gemeldtet werden soll wenn AKTION = ZZZ';

comment on column dirkspzm32.s_erp_send_bew.arbeitsplatz_id is
    'Arbeitsplatz der Versands bei Auslieferung';

comment on column dirkspzm32.s_erp_send_bew.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_erp_send_bew.auf_id is
    '  eindeutige Sequenz-Nummer in Tabelle (S_ERP_RCV_...) oder Sequenz-Nummer aus ISIPlus wenn TABELLE = NULL (Dient zur eindeutigen Referenzierung zum Ursprung / Auslöser im ERP)'
    ;

comment on column dirkspzm32.s_erp_send_bew.bew_id is
    'ID der Übertragung';

comment on column dirkspzm32.s_erp_send_bew.brutto_kg is
    'Brutto KG Gewicht für Rückmeldung im Lieferschein (LIF)';

comment on column dirkspzm32.s_erp_send_bew.b_date is
    'Buchungszeitpunkt als Date';

comment on column dirkspzm32.s_erp_send_bew.b_datum is
    'Buchungszeitpunkt als String';

comment on column dirkspzm32.s_erp_send_bew.calcdatum is
    'Berechnetes Datum, z.B. für TA_PLAN_ZEIT';

comment on column dirkspzm32.s_erp_send_bew.charge is
    'Charge des Materials';

comment on column dirkspzm32.s_erp_send_bew.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';

comment on column dirkspzm32.s_erp_send_bew.created_login_id is
    'Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.s_erp_send_bew.cycle is
    'Anzahl der Versuche der Übertragung  (Versuchszähler)';

comment on column dirkspzm32.s_erp_send_bew.ext_auftrag is
    'Auftragsnummer / Bestellung im ERP';

comment on column dirkspzm32.s_erp_send_bew.ext_best_nr is
    'Externe Bestellnummer bei Anlieferungen';

comment on column dirkspzm32.s_erp_send_bew.ext_best_pos is
    'Externe Bestellposition bei Anlieferungen';

comment on column dirkspzm32.s_erp_send_bew.ext_host_referenz is
    'Externe Referenz Hostsystem z.B. IDOC Nr. (Wird nicht von den ISIPLus-Standardprozessen gefüllt)';

comment on column dirkspzm32.s_erp_send_bew.ext_lief_nr is
    'Externe Lieferscheinnummer bei Anlieferungen';

comment on column dirkspzm32.s_erp_send_bew.ext_lief_pos is
    'Externe Lieferscheinposition bei Anlieferungen';

comment on column dirkspzm32.s_erp_send_bew.ext_pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.s_erp_send_bew.ext_tour is
    'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';

comment on column dirkspzm32.s_erp_send_bew.ext_upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';

comment on column dirkspzm32.s_erp_send_bew.fa_ag is
    'Fertigungsauftrag Arbeitsgang';

comment on column dirkspzm32.s_erp_send_bew.fa_upos is
    'Unterposition für Gruppenarbeit (Split)';

comment on column dirkspzm32.s_erp_send_bew.fehler_code is
    'Fehlercode siehe Schnittstellenbeschreibung';

comment on column dirkspzm32.s_erp_send_bew.fehler_text is
    'Fehlertext';

comment on column dirkspzm32.s_erp_send_bew.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_erp_send_bew.geb_typ_q is
    'Quell-Gebindetyp';

comment on column dirkspzm32.s_erp_send_bew.geb_typ_z is
    'Ziel-Gebindetyp';

comment on column dirkspzm32.s_erp_send_bew.herkunft is
    '"ISI" immer konstant';

comment on column dirkspzm32.s_erp_send_bew.inventurdifferenz is
    'Inventurdifferenz';

comment on column dirkspzm32.s_erp_send_bew.ist_bestand is
    'IST_BESTAND für BAG oder INV';

comment on column dirkspzm32.s_erp_send_bew.komm_q_lhm_id is
    'Quell LHM bei Kommissionierung';

comment on column dirkspzm32.s_erp_send_bew.komm_q_lte_id is
    'Quell LTE bei Kommissionierung';

comment on column dirkspzm32.s_erp_send_bew.komm_q_rest_lhm is
    'Dann Rest in LHM';

comment on column dirkspzm32.s_erp_send_bew.komm_q_rest_lte is
    'Dann Rest in LTE';

comment on column dirkspzm32.s_erp_send_bew.komm_z_lhm_id is
    'Ziel LHM bei Kommissionierung';

comment on column dirkspzm32.s_erp_send_bew.komm_z_lte_id is
    'Ziel LTE bei Kommissionierung';

comment on column dirkspzm32.s_erp_send_bew.labor_status is
    'Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung'
    ;

comment on column dirkspzm32.s_erp_send_bew.lagerort is
    'Lagerort im HOST';

comment on column dirkspzm32.s_erp_send_bew.lagerplatz is
    'Lagerplatz im ISI';

comment on column dirkspzm32.s_erp_send_bew.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_send_bew.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.s_erp_send_bew.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.s_erp_send_bew.leitzahl is
    'Leitzahl aus FA_Auftrag';

comment on column dirkspzm32.s_erp_send_bew.lhm_nr is
    'Nummer des Lagerhilfsmittel (Barcode)';

comment on column dirkspzm32.s_erp_send_bew.lief_nr is
    'Lieferant-Nr.';

comment on column dirkspzm32.s_erp_send_bew.lte_name is
    'Art, Name der Transporteinheit';

comment on column dirkspzm32.s_erp_send_bew.lte_nr is
    'Nummer der Transporteinheit (Barcode)';

comment on column dirkspzm32.s_erp_send_bew.ma_id is
    'Maschinen ID aus HOST';

comment on column dirkspzm32.s_erp_send_bew.ma_status is
    'Maschinenstatus P = Produktion U = Unterbrechung';

comment on column dirkspzm32.s_erp_send_bew.ma_s_grund is
    'Störgrundnummer';

comment on column dirkspzm32.s_erp_send_bew.me is
    'Mengeneinheit aus isi-artikel';

comment on column dirkspzm32.s_erp_send_bew.menge is
    '1.Wahl Stück (LVS / BDE) oder Störgrund';

comment on column dirkspzm32.s_erp_send_bew.menge_b is
    'B Qualität Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_erp_send_bew.nio_text is
    'NIO Text';

comment on column dirkspzm32.s_erp_send_bew.order_pos_auf_id is
    'Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)';

comment on column dirkspzm32.s_erp_send_bew.prodzeit_ist is
    'Produktionszeit in Minuten';

comment on column dirkspzm32.s_erp_send_bew.prod_zeit_erf is
    'Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden';

comment on column dirkspzm32.s_erp_send_bew.pruef_plan_nummern is
    'Prüfplannummern, die für diese Charge vergeben wurde (Prüfnummer, nicht die ID des Prüfplans). Alle Prüfplannummern, die in der LTE enthalten sind konkateniert. '
    ;

comment on column dirkspzm32.s_erp_send_bew.ret_code is
    'Returncode aus Übertragung';

comment on column dirkspzm32.s_erp_send_bew.ruestzeit_ist is
    'Rüstzeit in Minuten (Produktionsfertigmeldung)';

comment on column dirkspzm32.s_erp_send_bew.ruest_zeit_erf is
    'Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden';

comment on column dirkspzm32.s_erp_send_bew.r_menge is
    'Menge Rüsten 1.Wahl Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_erp_send_bew.r_menge_b is
    'Menge Rüsten B Qualität Stück (Nicht für Euscher)';

comment on column dirkspzm32.s_erp_send_bew.r_schrott is
    'Schrottmenge beim Rüsten in Stück';

comment on column dirkspzm32.s_erp_send_bew.schrott is
    'Schrottmenge in Stück';

comment on column dirkspzm32.s_erp_send_bew.serie is
    'Seriennummer des Materials';

comment on column dirkspzm32.s_erp_send_bew.status is
    'N = Neu, im ERP noch nicht Übernommen
U = Ist in übertragung,
UE = ERP hat den Satz übernommen,
ERR = Fehler,
D = Delete -> ISIPlus kann den Eintrag Löschen';

comment on column dirkspzm32.s_erp_send_bew.stoerzeit_ist is
    'Störzeit in Minuten (Produktionsfertigmeldung)';

comment on column dirkspzm32.s_erp_send_bew.tabelle is
    'NULL = Keine Referenz zu ERP Tabellen sonst Tabellenname';

comment on column dirkspzm32.s_erp_send_bew.vorgang_id is
    'Nummer um die Positionen zu Klammern Z.B. Tourennummer';

comment on column dirkspzm32.s_erp_send_bew.wickelprogramm is
    'Wickel Programm Nr. mit der die LTE aktuell gewickelt werden soll';

comment on column dirkspzm32.s_erp_send_bew.zlagerort is
    'Ziellagerort im HOST';

comment on column dirkspzm32.s_erp_send_bew.zlagerplatz is
    'Ziellagerplatz im ISI';


-- sqlcl_snapshot {"hash":"6127b14d78ce28791ca98e38f2f688ce25f30c5b","type":"COMMENT","name":"s_erp_send_bew","schemaName":"dirkspzm32","sxml":""}