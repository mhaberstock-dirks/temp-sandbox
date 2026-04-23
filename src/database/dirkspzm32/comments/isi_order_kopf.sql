comment on table dirkspzm32.isi_order_kopf is
    'Bestellungen und Ladelisten die zum Transport anstehen';

comment on column dirkspzm32.isi_order_kopf.adress_id is
    'ID aus Adressen Tabelle, Warenempfänger';

comment on column dirkspzm32.isi_order_kopf.anbruch is
    'T = True Erlaubt, F = False Verboten, A = Vozugsweise Anbruch, V Vorzugsweise Volle';

comment on column dirkspzm32.isi_order_kopf.arbeitsplatz_id is
    'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';

comment on column dirkspzm32.isi_order_kopf.besteller is
    'LVS, HOST, BDE, ISI';

comment on column dirkspzm32.isi_order_kopf.be_nr is
    'Bestellnummer des Kunden aus externem System, sonst nur Kommentar';

comment on column dirkspzm32.isi_order_kopf.fertig_datum is
    'Abgeschlossen am';

comment on column dirkspzm32.isi_order_kopf.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.isi_order_kopf.freigabe is
    'M = Manuelle Freigabe, A = Automatisch Freigeben zum Datum, E = Paletten Einzelanforderung';

comment on column dirkspzm32.isi_order_kopf.freigabe_datum is
    'FREIGABE = M --> Erst dann freizugeben, A --> Automatische Freigabe genau am';

comment on column dirkspzm32.isi_order_kopf.freigegeben_datum is
    'Freigegeban am';

comment on column dirkspzm32.isi_order_kopf.komm_zeit_sec is
    'Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für alle Positionen';

comment on column dirkspzm32.isi_order_kopf.liefer_datum is
    'Gewünsches Liefer/Transportdatum';

comment on column dirkspzm32.isi_order_kopf.li_nr is
    'Lieferschein Nummer aus Externem System, sonst einen Lieferschein in eigener Tabelle anlegen. Bzw. Lieferantenbestellnummer';

comment on column dirkspzm32.isi_order_kopf.lkw_nr is
    'Wenn die LKW_NR nicht NULL dann Transportfreigebe immer nur für einen ganzen LKW mit dieser Nummer';

comment on column dirkspzm32.isi_order_kopf.login_id is
    'ID des Erstellers';

comment on column dirkspzm32.isi_order_kopf.lvs_info is
    'für Informationen vom LVS';

comment on column dirkspzm32.isi_order_kopf.ohne_transport is
    'F = Nein, T= Schnellverladung, keine Aufträge in der ISI-Transport, wenn keine Positionen darf alles vereladen werden was auf einem Logerort mit Modul_bearbeiter SLS hat'
    ;

comment on column dirkspzm32.isi_order_kopf.ohne_transp_anz is
    'Anzahl der Stapler, die z.Zt. an diesem Auftrag arbeiten.';

comment on column dirkspzm32.isi_order_kopf.order_adress_id is
    'ID, wer hat diese Bestellung erstellt (Rechnungsadresse)';

comment on column dirkspzm32.isi_order_kopf.order_datum is
    'Generierungsdatum';

comment on column dirkspzm32.isi_order_kopf.order_info is
    'Info für Kommissionierer';

comment on column dirkspzm32.isi_order_kopf.prioritaet is
    'Priorität (0..9), 9: hohe Priorität';

comment on column dirkspzm32.isi_order_kopf.quelle is
    'WE wenn Einlagerung';

comment on column dirkspzm32.isi_order_kopf.quell_lagerorte is
    'Lagerorte aus denen diese Ware entnommen werden kann';

comment on column dirkspzm32.isi_order_kopf.satzart is
    'BE = Bestellung
LI = Anstehende Lieferung
MA = Maschinenanforderung
LA = Lageranforderung
LU = Umlagerung
RL/RK = Retouren
LK/BK = KONSI
MAK = Maschinenanforderung ggf. mit Kommissionierung
LAK = Lageranforderung ggf. mit Kommissionierung
LNK = Lager Nachschub ggf. mit Kommissionierung';

comment on column dirkspzm32.isi_order_kopf.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_order_kopf.sp_adress_id is
    'Spedition Adress_ID';

comment on column dirkspzm32.isi_order_kopf.startzeitpunkt_berechnet is
    'Berechneter Startzeitpunkt für die erste Posion dieser Klammer';

comment on column dirkspzm32.isi_order_kopf.status is
    'N = Neu/Noch nicht angefangen,
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

comment on column dirkspzm32.isi_order_kopf.strategie is
    'FIFO, LIFO ...';

comment on column dirkspzm32.isi_order_kopf.transport_gruppe is
    'Z.B. Beladereihenfolge für einen LKW Tournummer Oetker';

comment on column dirkspzm32.isi_order_kopf.transp_zeit_sec is
    'Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.'
    ;

comment on column dirkspzm32.isi_order_kopf.vorgang_id is
    'Nummer um die Positionen zu Klammern Z.B. Tourennummer';

comment on column dirkspzm32.isi_order_kopf.vorgang_typ is
    'WEI/WAI = Zugang/Abgang Intern (z.B. Produktion), WEE/WAE = Zugang/Abgang Extern (Anlieferung, Versand) WUI/WUE = Umlagerung Intern/Extern KWE/KWA = Wareneingang/Warenabgang KONSI'
    ;

comment on column dirkspzm32.isi_order_kopf.wae_ziel is
    'SPED = Spedition,
SELB = Selbstabholer,
UPS = UPS,
DPAD = Paketversand,
MASCH = Maschine,
LAGER = Lager,
(lt. HJG 2015-09-02) WA Platz aus LVS_LGR';

comment on column dirkspzm32.isi_order_kopf.wa_verladepunkt is
    'Verladepunkt, wenn zugeordnet (z.B. TOR etc.)';

comment on column dirkspzm32.isi_order_kopf.wa_verl_start_soll is
    'Soll-Startzeitpunkt der Verladung';

comment on column dirkspzm32.isi_order_kopf.ziel is
    'WA wenn Auslagerung';


-- sqlcl_snapshot {"hash":"108773c7b8249249a64bd0fbb8dd3ce3d8773013","type":"COMMENT","name":"isi_order_kopf","schemaName":"dirkspzm32","sxml":""}