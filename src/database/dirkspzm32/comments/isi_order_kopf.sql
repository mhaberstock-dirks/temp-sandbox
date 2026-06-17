comment on table DIRKSPZM32.ISI_ORDER_KOPF is 'Bestellungen und Ladelisten die zum Transport anstehen';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."ADRESS_ID" is 'ID aus Adressen Tabelle, Warenempfänger';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."ANBRUCH" is 'T = True Erlaubt, F = False Verboten, A = Vozugsweise Anbruch, V Vorzugsweise Volle';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."ARBEITSPLATZ_ID" is 'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."BESTELLER" is 'LVS, HOST, BDE, ISI';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."BE_NR" is 'Bestellnummer des Kunden aus externem System, sonst nur Kommentar';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."FERTIG_DATUM" is 'Abgeschlossen am';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."FREIGABE" is 'M = Manuelle Freigabe, A = Automatisch Freigeben zum Datum, E = Paletten Einzelanforderung';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."FREIGABE_DATUM" is 'FREIGABE = M --> Erst dann freizugeben, A --> Automatische Freigabe genau am';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."FREIGEGEBEN_DATUM" is 'Freigegeban am';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."KOMM_ZEIT_SEC" is 'Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für alle Positionen';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."LIEFER_DATUM" is 'Gewünsches Liefer/Transportdatum';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."LI_NR" is 'Lieferschein Nummer aus Externem System, sonst einen Lieferschein in eigener Tabelle anlegen. Bzw. Lieferantenbestellnummer';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."LKW_NR" is 'Wenn die LKW_NR nicht NULL dann Transportfreigebe immer nur für einen ganzen LKW mit dieser Nummer';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."LOGIN_ID" is 'ID des Erstellers';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."LVS_INFO" is 'für Informationen vom LVS';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."OHNE_TRANSPORT" is 'F = Nein, T= Schnellverladung, keine Aufträge in der ISI-Transport, wenn keine Positionen darf alles vereladen werden was auf einem Logerort mit Modul_bearbeiter SLS hat';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."OHNE_TRANSP_ANZ" is 'Anzahl der Stapler, die z.Zt. an diesem Auftrag arbeiten.';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."ORDER_ADRESS_ID" is 'ID, wer hat diese Bestellung erstellt (Rechnungsadresse)';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."ORDER_DATUM" is 'Generierungsdatum';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."ORDER_INFO" is 'Info für Kommissionierer';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."PRIORITAET" is 'Priorität (0..9), 9: hohe Priorität';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."QUELLE" is 'WE wenn Einlagerung';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."QUELL_LAGERORTE" is 'Lagerorte aus denen diese Ware entnommen werden kann';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."SATZART" is 'BE = Bestellung
LI = Anstehende Lieferung
MA = Maschinenanforderung
LA = Lageranforderung
LU = Umlagerung
RL/RK = Retouren
LK/BK = KONSI
MAK = Maschinenanforderung ggf. mit Kommissionierung
LAK = Lageranforderung ggf. mit Kommissionierung
LNK = Lager Nachschub ggf. mit Kommissionierung';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."SP_ADRESS_ID" is 'Spedition Adress_ID';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."STARTZEITPUNKT_BERECHNET" is 'Berechneter Startzeitpunkt für die erste Posion dieser Klammer';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."STATUS" is 'N = Neu/Noch nicht angefangen,
V = In Vorbereitung,
L= Lock/Satz Gesperrt,
F = Freigegeben,
A = Angefangen,
R = Reserviert,
D = Disponiert,
T = Im Transport,
X = Fertig, aber noch nicht zum HOST gemeldet
E = Fertig,
Z = Zurückgewiesen (Abgelehnt)';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."STRATEGIE" is 'FIFO, LIFO ...';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."TRANSPORT_GRUPPE" is 'Z.B. Beladereihenfolge für einen LKW Tournummer Oetker';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."TRANSP_ZEIT_SEC" is 'Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."VORGANG_ID" is 'Nummer um die Positionen zu Klammern Z.B. Tourennummer';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."VORGANG_TYP" is 'WEI/WAI = Zugang/Abgang Intern (z.B. Produktion), WEE/WAE = Zugang/Abgang Extern (Anlieferung, Versand) WUI/WUE = Umlagerung Intern/Extern KWE/KWA = Wareneingang/Warenabgang KONSI';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."WAE_ZIEL" is 'SPED = Spedition,
SELB = Selbstabholer,
UPS = UPS,
DPAD = Paketversand,
MASCH = Maschine,
LAGER = Lager,
(lt. HJG 2015-09-02) WA Platz aus LVS_LGR';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."WA_VERLADEPUNKT" is 'Verladepunkt, wenn zugeordnet (z.B. TOR etc.)';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."WA_VERL_START_SOLL" is 'Soll-Startzeitpunkt der Verladung';
comment on column DIRKSPZM32.ISI_ORDER_KOPF."ZIEL" is 'WA wenn Auslagerung';



-- sqlcl_snapshot {"hash":"000650349b1d01adf38a6db9e7d1b2e49a28f633","type":"COMMENT","name":"isi_order_kopf","schemaName":"dirkspzm32","sxml":""}