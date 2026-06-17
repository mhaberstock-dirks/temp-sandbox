comment on table DIRKSPZM32.S_RCV_DIS_TO_ORDER is 'Aufträge, die mit einem DIS-Prozess in die ISI-Order transportiert werden sollen';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ADR_ART" is 'K = Kunde L = Lieferant';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ADR_LIEFER" is 'Lieferadresse bei Kunden aus ADR';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ADR_NR" is 'Kunden oder Lieferanten-Nummer aus ADR';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ANBRUCH" is 'Anbruchpalette T = Nur Anbruch, F = Nur Vollpaletten, V = Vorzug Anbruch, A = Ausnahmsweise Anbruch I = IGNORE (Egal)';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ARBEITSPLATZ_ID" is 'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ARTIKEL" is 'Artikelnummer';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."AUFTRAG" is 'Auftragsnummer aus dem Host-System (Nicht die ID)';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."AUF_ID" is 'eindeutige Sequenz-Nummer in der ISI_ORDER kann hier mehrfach vorkommen (Referenz)';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."BEARB_DATUM" is 'Bearbeitungsdatum, zuletzt bearbeitet am';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."BESTELLER" is 'Aktor des Vorgangs z.B. HOST WAWI, ....';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."BEST_NR_KUNDE" is 'Bestellnummer des Kunden';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."CHARGE" is 'Charge';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ERSTELL_DATUM" is 'Erstellungsdatum, erstellt am';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."FA_AG" is 'Arbeitsgang';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."FEHLER_CODE" is 'Host-Übertragung Fehlernummer';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."FEHLER_TEXT" is 'Host-Übertragung Fehlertext';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."FREIGABE" is 'M = Manuelle Freigabe, A = Automatisch Freigeben zum Datum, E = Paletten Einzelanforderung';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."FREIGABE_DATUM" is 'FREIGABE = früheste Startzeit';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."KOMM_GANZ_GEBINDE" is 'Ganzes Gebinde;
T=Es müssen ganze Gebinde genommen werden. Die Gebinde dürfen geöffnet werden
F=Es müssen nicht nicht ganze Gebinde genommen werden. Es dürfen Teilmengen entnommen werden';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."KOMM_STEUERUNG" is 'Roboter Steuerung (Automatisches DEPAL oder Palettieren);
A=Automatisch ISIPlus entscheidet,
R=Kommissionierung Roboter
M=Kommissionierung Manuell';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."KOMPLETT_BEREITSTELLEN" is 'Warten im Loop vor der Bereitstellung; T=Ja bedeutet Warten bis alle Positionen im Loop umschalten, F=Nein wartet nicht auf alle gebinde, sonder wird ausgelagert wen möglich; ';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."KOMPLETT_RESERVIEREN" is 'Grossauftrag-Strategie; Komplett-Lieferung
T=Ja    Alle Gebinte werden zum Start des Auftrags disponiert
F=Nein  Der Auftrag ist zu groß, nicht alle Gebinde können zu beginn des Autfrags disponiert werden, da diese andere dann blockieren würden. Schubweise Nachdisponieren';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."KOM_INFO" is 'zus. Info für Kommissionierer';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."KOM_MENGENEINHEIT" is 'Mengeneinheit, für Kommissionierer';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."KOM_MG" is 'Menge Kommissionierer evtl hier Anzahl Karton';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."KONSOLIDIEREN" is 'K=Nachschub Konsolidieren zusammenfassen in der ISI_ORDER, E=Einzelposition und im Vorgang in der ISI_ORDER';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LABOR_STATUS" is 'DEFAULT = ''F''rei -> Zu vernendende Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL1" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL10" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL2" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL3" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL4" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL5" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL6" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL7" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL8" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LAM_SEL9" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LEITZAHL" is 'Leitzahl Fertigungsauftrag';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LIEFER_DATUM" is 'Gewünsches Lieferdatum';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LI_NR" is 'Lieferschein Nummer';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."LI_POS_NR" is 'Lieferscheinposition -Nummer';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."MHD" is 'MHD';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."POS_NR" is 'Positionsnummer';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."PRIORITAET" is 'Priorität (0..9), 9: hohe Priorität';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."PROD_PARAMS" is 'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."QUELL_LAGERORTE" is 'Lagerorte aus denen diese Ware entnommen werden kann';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."SATZART" is 'BE = Bestellung LI = Anstehende Lieferung MA = Maschinenanforderung LA = Lageranforderung LU = Umlagerung RL/RK = Retouren LK/BK = KONSI';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."SERIENNR" is 'Serien-Nummer';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."SOLL_MENGENEINHEIT" is 'Mengeneinheit Lagerbestand im ISI';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."SOLL_MG" is 'Soll-Menge Hier evtl. Stück';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."STRATEGIE" is 'FIFO, LIFO';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."S_RCV_DIS_TO_ORDER_ID" is 'eindeutige Sequenz-Nummer';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."TOUR" is 'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."UEBERT_STATUS" is 'Host-Übertragung Status; N=Neu noch nicht übernommen, U=In Übertragung, UE=erfolgreich übertragen, ERR=Fehler, D=Delete, zum löschen markiert';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."UEBER_UNTER_LIEFERN" is 'Nachschub (OL);
ULTE=Underdelivery LTE bedeutet, dass solange Paletten genommen werden, bis maximal die Menge erreicht ist. Bei der ersten Palette, die die Menge überschreitet wird die Reservierung beendet ohne diese zu reservieren
ULHM=Underdelivery LHM bedeutet, dass solange LHM (Kartons) genommen werden, bis maximal die Menge erreicht ist. Bei dem ersten LHM, das die Menge überschreitet wird die Reservierung beendet ohne dieses zu reservieren
EX=exakte Lieferung Die Menge muss exakt eingehalten werden, evtl. mit Einzelentnahmen in der Kommissionierung,
OLTE=Overdelivery LTE bedeutet, dass solange LTEs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LTE mit der die Menge überschritten wird, wird auch komplett reserviert
OLHM=Overdelivery LHM bedeutet, dass solange LHMs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LHM mit der die Menge überschritten wird, wird auch komplett reserviert
';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."UPOS_NR" is 'Unterposition Bsp.: Eine Position mit n Chargen etc.';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."VORGANG_ID" is 'Nummer um die Positionen zu Klammern (Z.B. TourNr oder Sendungsnummer)';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."WA_ZIEL" is 'SPED = Spedition SELB = Selbstabholer UPS = UPS DPAD = Paketversand';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ZIEL" is 'Transportziel';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ZIEL_PACKSCHEMA" is 'Ziel-Packschema, Nachschub T21';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ZIEL_TRAEGER" is 'Zieltraeger. z.B. Euro, HP; Ladungsträger bei Paletten, Behältertyp bei Behältern';
comment on column DIRKSPZM32.S_RCV_DIS_TO_ORDER."ZIEL_TRAEGER_MENGE" is 'Menge im Zieltraeger.';



-- sqlcl_snapshot {"hash":"ecc14ce2b593c64c0edc78727b6349a2a33cae95","type":"COMMENT","name":"s_rcv_dis_to_order","schemaName":"dirkspzm32","sxml":""}