comment on table DIRKSPZM32.S_ERP_SEND_BEW is 'Materialbuchung Bestandsübergabe werden von ISIPlus an COMUL übertragen';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."AKTION" is 'AV = Status in Vorbereitung
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
comment on column DIRKSPZM32.S_ERP_SEND_BEW."AKTION_HOST" is 'Aktion oder Message die dem Host gemeldtet werden soll wenn AKTION = ZZZ';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."ARBEITSPLATZ_ID" is 'Arbeitsplatz der Versands bei Auslieferung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."ARTIKEL" is 'Artikelnummer';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."AUF_ID" is '  eindeutige Sequenz-Nummer in Tabelle (S_ERP_RCV_...) oder Sequenz-Nummer aus ISIPlus wenn TABELLE = NULL (Dient zur eindeutigen Referenzierung zum Ursprung / Auslöser im ERP)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."BEW_ID" is 'ID der Übertragung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."BRUTTO_KG" is 'Brutto KG Gewicht für Rückmeldung im Lieferschein (LIF)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."B_DATE" is 'Buchungszeitpunkt als Date';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."B_DATUM" is 'Buchungszeitpunkt als String';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."CALCDATUM" is 'Berechnetes Datum, z.B. für TA_PLAN_ZEIT';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."CHARGE" is 'Charge des Materials';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."CREATED_DATE" is 'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."CREATED_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz erstellt hat';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."CYCLE" is 'Anzahl der Versuche der Übertragung  (Versuchszähler)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."EXT_AUFTRAG" is 'Auftragsnummer / Bestellung im ERP';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."EXT_BEST_NR" is 'Externe Bestellnummer bei Anlieferungen';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."EXT_BEST_POS" is 'Externe Bestellposition bei Anlieferungen';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."EXT_HOST_REFERENZ" is 'Externe Referenz Hostsystem z.B. IDOC Nr. (Wird nicht von den ISIPLus-Standardprozessen gefüllt)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."EXT_LIEF_NR" is 'Externe Lieferscheinnummer bei Anlieferungen';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."EXT_LIEF_POS" is 'Externe Lieferscheinposition bei Anlieferungen';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."EXT_POS_NR" is 'Positionsnummer';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."EXT_TOUR" is 'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."EXT_UPOS_NR" is 'Unterposition Bsp.: Eine Position mit n Chargen etc.';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."FA_AG" is 'Fertigungsauftrag Arbeitsgang';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."FA_UPOS" is 'Unterposition für Gruppenarbeit (Split)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."FEHLER_CODE" is 'Fehlercode siehe Schnittstellenbeschreibung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."FEHLER_TEXT" is 'Fehlertext';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."GEB_TYP_Q" is 'Quell-Gebindetyp';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."GEB_TYP_Z" is 'Ziel-Gebindetyp';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."HERKUNFT" is '"ISI" immer konstant';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."INVENTURDIFFERENZ" is 'Inventurdifferenz';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."IST_BESTAND" is 'IST_BESTAND für BAG oder INV';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."KOMM_Q_LHM_ID" is 'Quell LHM bei Kommissionierung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."KOMM_Q_LTE_ID" is 'Quell LTE bei Kommissionierung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."KOMM_Q_REST_LHM" is 'Dann Rest in LHM';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."KOMM_Q_REST_LTE" is 'Dann Rest in LTE';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."KOMM_Z_LHM_ID" is 'Ziel LHM bei Kommissionierung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."KOMM_Z_LTE_ID" is 'Ziel LTE bei Kommissionierung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LABOR_STATUS" is 'Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAGERORT" is 'Lagerort im HOST';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAGERPLATZ" is 'Lagerplatz im ISI';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL1" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL10" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL2" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL3" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL4" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL5" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL6" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL7" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL8" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAM_SEL9" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LEITZAHL" is 'Leitzahl aus FA_Auftrag';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LHM_NR" is 'Nummer des Lagerhilfsmittel (Barcode)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LIEF_NR" is 'Lieferant-Nr.';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LTE_NAME" is 'Art, Name der Transporteinheit';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."LTE_NR" is 'Nummer der Transporteinheit (Barcode)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."MA_ID" is 'Maschinen ID aus HOST';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."MA_STATUS" is 'Maschinenstatus P = Produktion U = Unterbrechung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."MA_S_GRUND" is 'Störgrundnummer';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."ME" is 'Mengeneinheit aus isi-artikel';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."MENGE" is '1.Wahl Stück (LVS / BDE) oder Störgrund';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."MENGE_B" is 'B Qualität Stück (Nicht für Euscher)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."NIO_TEXT" is 'NIO Text';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."ORDER_POS_AUF_ID" is 'Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."PRODZEIT_IST" is 'Produktionszeit in Minuten';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."PROD_ZEIT_ERF" is 'Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."PRUEF_PLAN_NUMMERN" is 'Prüfplannummern, die für diese Charge vergeben wurde (Prüfnummer, nicht die ID des Prüfplans). Alle Prüfplannummern, die in der LTE enthalten sind konkateniert. ';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."RET_CODE" is 'Returncode aus Übertragung';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."RUESTZEIT_IST" is 'Rüstzeit in Minuten (Produktionsfertigmeldung)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."RUEST_ZEIT_ERF" is 'Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."R_MENGE" is 'Menge Rüsten 1.Wahl Stück (Nicht für Euscher)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."R_MENGE_B" is 'Menge Rüsten B Qualität Stück (Nicht für Euscher)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."R_SCHROTT" is 'Schrottmenge beim Rüsten in Stück';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."SCHROTT" is 'Schrottmenge in Stück';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."SERIE" is 'Seriennummer des Materials';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."STATUS" is 'N = Neu, im ERP noch nicht Übernommen
U = Ist in übertragung,
UE = ERP hat den Satz übernommen,
ERR = Fehler,
D = Delete -> ISIPlus kann den Eintrag Löschen';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."STOERZEIT_IST" is 'Störzeit in Minuten (Produktionsfertigmeldung)';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."TABELLE" is 'NULL = Keine Referenz zu ERP Tabellen sonst Tabellenname';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."VORGANG_ID" is 'Nummer um die Positionen zu Klammern Z.B. Tourennummer';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."WICKELPROGRAMM" is 'Wickel Programm Nr. mit der die LTE aktuell gewickelt werden soll';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."ZLAGERORT" is 'Ziellagerort im HOST';
comment on column DIRKSPZM32.S_ERP_SEND_BEW."ZLAGERPLATZ" is 'Ziellagerplatz im ISI';



-- sqlcl_snapshot {"hash":"cc6784b8275e5dde7cdca1872769814c199652d6","type":"COMMENT","name":"s_erp_send_bew","schemaName":"dirkspzm32","sxml":""}