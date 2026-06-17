comment on table DIRKSPZM32.ISI_ORDER_POS is 'Bestellungen und Ladelisten die zum Transport anstehen';
comment on column DIRKSPZM32.ISI_ORDER_POS."ANBRUCH" is 'T = True Erlaubt (Nur Anbruch), F = False Verboten (Nur Vollpaletten), A = Ausnahmsweise Anbruch (Vorzugsweise Volle), V =Vorzugsweise Anbruch,  B = Volle Behälter bevorzugen, I = Egal (Ignorieren)';
comment on column DIRKSPZM32.ISI_ORDER_POS."ARBEITSPLATZ_ID" is 'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';
comment on column DIRKSPZM32.ISI_ORDER_POS."ARTIKEL_ID" is 'Artikelnummer';
comment on column DIRKSPZM32.ISI_ORDER_POS."AUFTRAG" is 'Auftragsnummer / Bestellung im DIAF';
comment on column DIRKSPZM32.ISI_ORDER_POS."AUF_ID" is 'eindeutige Sequenz-Nummer für Reservierungen und DISPO';
comment on column DIRKSPZM32.ISI_ORDER_POS."AUF_ID_EXTERN" is 'Eindeutige Nummer vom Hostsystem';
comment on column DIRKSPZM32.ISI_ORDER_POS."AUTO_DEPAL" is '"Automatisches depaletieren möglich?
 T = True, F = False und NULL Unbekannt ob möglich oder nicht"';
comment on column DIRKSPZM32.ISI_ORDER_POS."BESTELLER" is 'LVS, HOST, BDE, ISI';
comment on column DIRKSPZM32.ISI_ORDER_POS."BEST_NR_KUNDE" is 'Bestellnummer des Kunden';
comment on column DIRKSPZM32.ISI_ORDER_POS."BRUTTO_KG" is 'Brutto KG Gewicht der Transporte';
comment on column DIRKSPZM32.ISI_ORDER_POS."CHARGE_ID" is 'Charge';
comment on column DIRKSPZM32.ISI_ORDER_POS."FA_AG" is 'Arbeitsgang der Leitzahl';
comment on column DIRKSPZM32.ISI_ORDER_POS."FA_UPOS" is 'Unterposition evtl. je Charge';
comment on column DIRKSPZM32.ISI_ORDER_POS."FERTIG_DATUM" is 'Abgeschlossen am';
comment on column DIRKSPZM32.ISI_ORDER_POS."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.ISI_ORDER_POS."FREIGABE" is 'M = Manuelle Freigabe, A = Automatisch Freigeben zum Datum, E = Paletten Einzelanforderung';
comment on column DIRKSPZM32.ISI_ORDER_POS."FREIGABE_DATUM" is 'FREIGABE = früheste Startzeit';
comment on column DIRKSPZM32.ISI_ORDER_POS."FREIGEGEBEN_DATUM" is 'Freigegeban am';
comment on column DIRKSPZM32.ISI_ORDER_POS."IST_MENGE" is 'Ist Menge';
comment on column DIRKSPZM32.ISI_ORDER_POS."KOMM_VORGABE_AUTO_DEPAL" is 'Automatisches depaletieren?
 A=ISIPlus entscheidet, R=Zwingend Roboter, M=Zwingend Manuell';
comment on column DIRKSPZM32.ISI_ORDER_POS."KOMM_ZEIT_SEC" is 'Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für diese Pos';
comment on column DIRKSPZM32.ISI_ORDER_POS."KOMPLETT_BEREITSTELLEN" is 'Warten im Loop vor der Bereitstellung; T=Ja bedeutet Warten bis alle Positionen im Loop umschalten, F=Nein wartet nicht auf alle gebinde, sonder wird ausgelagert wen möglich; ';
comment on column DIRKSPZM32.ISI_ORDER_POS."KOMPLETT_RESERVIEREN" is '"Grossauftrag-Strategie; Komplett-Lieferung
T=Ja    Alle Gebinte werden zum Start des Auftrags disponiert
F=Nein  Der Auftrag ist zu groß, nicht alle Gebinde können zu beginn des Autfrags disponiert werden, da diese andere dann blockieren würden. Schubweise Nachdisponieren"';
comment on column DIRKSPZM32.ISI_ORDER_POS."KOM_LGR_ORTE" is 'Lagerorte aus aus denen für die Kommissionierung ware entnommen werden darf';
comment on column DIRKSPZM32.ISI_ORDER_POS."KOM_MENGENEINHEIT" is 'Mengeneinheit, für Kommissionierer';
comment on column DIRKSPZM32.ISI_ORDER_POS."KOM_MG" is 'Menge Kommissionierer evtl hier Anzahl Karton';
comment on column DIRKSPZM32.ISI_ORDER_POS."LABOR_STATUS" is 'DEFAULT = ''F''rei -> Zu vernendende Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL1" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL10" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL2" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL3" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL4" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL5" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL6" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL7" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL8" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LAM_SEL9" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.ISI_ORDER_POS."LEITZAHL" is 'Leitzahl Fertigungsauftrag';
comment on column DIRKSPZM32.ISI_ORDER_POS."LIEFER_DATUM" is 'Gewünsches Liefer/Transportdatum';
comment on column DIRKSPZM32.ISI_ORDER_POS."LI_EXTERN" is 'Lieferschein Nummer aus Externem System, sonst einen Lieferschein in eigener Tabelle anlegen';
comment on column DIRKSPZM32.ISI_ORDER_POS."LI_NR" is 'Lieferschein Nummer';
comment on column DIRKSPZM32.ISI_ORDER_POS."LI_POS_NR" is 'Lieferscheinposition -Nummer';
comment on column DIRKSPZM32.ISI_ORDER_POS."LOGIN_ID" is 'ID des Erstellers';
comment on column DIRKSPZM32.ISI_ORDER_POS."LVS_INFO" is 'für Informationen vom LVS';
comment on column DIRKSPZM32.ISI_ORDER_POS."MENGENEINHEIT" is 'Mengeneinheit aus Menge Basis';
comment on column DIRKSPZM32.ISI_ORDER_POS."MENGE_BASIS" is 'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';
comment on column DIRKSPZM32.ISI_ORDER_POS."MHD" is 'MHD Welches MHD soll genommen werden';
comment on column DIRKSPZM32.ISI_ORDER_POS."MIN_MHD_TAGE" is 'Mindest MHD-Tage für die Ware';
comment on column DIRKSPZM32.ISI_ORDER_POS."MIN_REIFEZEIT" is 'Mindest Reifezeit für diesen Artikel';
comment on column DIRKSPZM32.ISI_ORDER_POS."ORDER_DATUM" is 'Generierungsdatum';
comment on column DIRKSPZM32.ISI_ORDER_POS."ORDER_INFO" is 'Info für Kommissionierer';
comment on column DIRKSPZM32.ISI_ORDER_POS."POS_NR" is 'Positionsnummer';
comment on column DIRKSPZM32.ISI_ORDER_POS."PRIORITAET" is 'Priorität (0..9), 9: hohe Priorität';
comment on column DIRKSPZM32.ISI_ORDER_POS."PROD_PARAMS" is 'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';
comment on column DIRKSPZM32.ISI_ORDER_POS."QUELLE" is 'WE wenn Einlagerung';
comment on column DIRKSPZM32.ISI_ORDER_POS."QUELL_LAGERORTE" is 'Lagerorte aus denen diese Ware entnommen werden kann';
comment on column DIRKSPZM32.ISI_ORDER_POS."SATZART" is 'BE = Bestellung
LI = Anstehende Lieferung
MA = Maschinenanforderung
LA = Lageranforderung
LU = Umlagerung
RL/RK = Retouren
LK/BK = KONSI
MAK = Maschinenanforderung ggf. mit Kommissionierung
LAK = Lageranforderung ggf. mit Kommissionierung
LNK = Lager Nachschub ggf. mit Kommissionierung';
comment on column DIRKSPZM32.ISI_ORDER_POS."SERIENNR_ID" is 'Serien-Nummer';
comment on column DIRKSPZM32.ISI_ORDER_POS."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_ORDER_POS."SOLL_MENGE" is 'Soll-Menge';
comment on column DIRKSPZM32.ISI_ORDER_POS."STARTZEITPUNKT_BERECHNET" is 'Berechneter Startzeitpunkt für diese Position';
comment on column DIRKSPZM32.ISI_ORDER_POS."STATUS" is '''N'' = Noch nicht angefangen V = In Vorbereitung F = Freigegeben E = Fertig A = Angefangen  X = Fertig, aber noch nicht zum HOST Z = Zurückgewiesen (Abgelehnt)';
comment on column DIRKSPZM32.ISI_ORDER_POS."STRATEGIE" is 'FIFO, LIFO ...';
comment on column DIRKSPZM32.ISI_ORDER_POS."TRANSPORT_GRUPPE" is 'Z.B. Beladereihenfolge für einen LKW Tournummer Oetker';
comment on column DIRKSPZM32.ISI_ORDER_POS."TRANSP_ZEIT_SEC" is 'Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.';
comment on column DIRKSPZM32.ISI_ORDER_POS."UPOS_NR" is 'Unterposition Bsp.: Eine Position mit n Chargen etc.';
comment on column DIRKSPZM32.ISI_ORDER_POS."VORGANG_ID" is 'Nummer um die Positionen zu Klammern Z.B. Tourennummer';
comment on column DIRKSPZM32.ISI_ORDER_POS."VORGANG_POS" is 'Position im Vorgang';
comment on column DIRKSPZM32.ISI_ORDER_POS."VORGANG_TYP" is 'WEI/WAI = Zugang/Abgang Intern (z.B. Produktion), WEE/WAE = Zugang/Abgang Extern (Anlieferung, Versand) WUI/WUE = Umlagerung Intern/Extern KWE/KWA = Wareneingang/Warenabgang KONSI';
comment on column DIRKSPZM32.ISI_ORDER_POS."WAE_ZIEL" is 'SPED = Spedition,
SELB = Selbstabholer,
UPS = UPS,
DPAD = Paketversand,
MASCH = Maschine,
LAGER = Lager,
(lt. HJG 2015-09-02) WA Platz aus LVS_LGR';
comment on column DIRKSPZM32.ISI_ORDER_POS."WARE_DISPONIERT" is 'T = True Ware bereits disponiert (Reserviert)  F = Ware nicht disponiert';
comment on column DIRKSPZM32.ISI_ORDER_POS."WA_MENGE_UEBERLIEF" is '"Nachschub (OL);
ULTE=Underdelivery LTE bedeutet, dass solange Paletten genommen werden, bis maximal die Menge erreicht ist. Bei der ersten Palette, die die Menge überschreitet wird die Reservierung beendet ohne diese zu reservieren
ULHM=Underdelivery LHM bedeutet, dass solange LHM (Kartons) genommen werden, bis maximal die Menge erreicht ist. Bei dem ersten LHM, das die Menge überschreitet wird die Reservierung beendet ohne dieses zu reservieren
EX=exakte Lieferung Die Menge muss exakt eingehalten werden, evtl. mit Einzelentnahmen in der Kommissionierung,
OLTE=Overdelivery LTE bedeutet, dass solange LTEs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LTE mit der die Menge überschritten wird, wird auch komplett reserviert
OLHM=Overdelivery LHM bedeutet, dass solange LHMs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LHM mit der die Menge überschritten wird, wird auch komplett reserviert
"';
comment on column DIRKSPZM32.ISI_ORDER_POS."ZEICHNUNG_INDEX" is 'Zeichnungsindex';
comment on column DIRKSPZM32.ISI_ORDER_POS."ZIEL" is 'WA wenn Auslagerung';
comment on column DIRKSPZM32.ISI_ORDER_POS."ZIEL_LHM_MENGE" is 'Menge für das Zielgebinde';
comment on column DIRKSPZM32.ISI_ORDER_POS."ZIEL_LHM_NAME" is 'Zielgebinde-Typ: z.B. Behälter(-Typ), Karton(-Typ), Eimer, etc.';
comment on column DIRKSPZM32.ISI_ORDER_POS."ZIEL_LTE_NAME" is 'Zieltraeger. z.B. Euro, HP; Ladungsträger bei Paletten, Behältertyp bei Behältern';
comment on column DIRKSPZM32.ISI_ORDER_POS."ZIEL_PACKSCHEMA_KOPF_ID" is 'Ziel-Packschema, Nachschub T21- Zeiger auf LVS_PACKSCHEMA_KOPF';



-- sqlcl_snapshot {"hash":"d850c944c87ac5afec8eb54cdb9a1dd829d0e369","type":"COMMENT","name":"isi_order_pos","schemaName":"dirkspzm32","sxml":""}