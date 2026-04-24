comment on table dirkspzm32.isi_order_pos is
    'Bestellungen und Ladelisten die zum Transport anstehen';

comment on column dirkspzm32.isi_order_pos.anbruch is
    'T = True Erlaubt (Nur Anbruch), F = False Verboten (Nur Vollpaletten), A = Ausnahmsweise Anbruch (Vorzugsweise Volle), V =Vorzugsweise Anbruch,  B = Volle Behälter bevorzugen, I = Egal (Ignorieren)'
    ;

comment on column dirkspzm32.isi_order_pos.arbeitsplatz_id is
    'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';

comment on column dirkspzm32.isi_order_pos.artikel_id is
    'Artikelnummer';

comment on column dirkspzm32.isi_order_pos.auftrag is
    'Auftragsnummer / Bestellung im DIAF';

comment on column dirkspzm32.isi_order_pos.auf_id is
    'eindeutige Sequenz-Nummer für Reservierungen und DISPO';

comment on column dirkspzm32.isi_order_pos.auf_id_extern is
    'Eindeutige Nummer vom Hostsystem';

comment on column dirkspzm32.isi_order_pos.auto_depal is
    '"Automatisches depaletieren möglich?
 T = True, F = False und NULL Unbekannt ob möglich oder nicht"';

comment on column dirkspzm32.isi_order_pos.besteller is
    'LVS, HOST, BDE, ISI';

comment on column dirkspzm32.isi_order_pos.best_nr_kunde is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.isi_order_pos.brutto_kg is
    'Brutto KG Gewicht der Transporte';

comment on column dirkspzm32.isi_order_pos.charge_id is
    'Charge';

comment on column dirkspzm32.isi_order_pos.fa_ag is
    'Arbeitsgang der Leitzahl';

comment on column dirkspzm32.isi_order_pos.fa_upos is
    'Unterposition evtl. je Charge';

comment on column dirkspzm32.isi_order_pos.fertig_datum is
    'Abgeschlossen am';

comment on column dirkspzm32.isi_order_pos.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.isi_order_pos.freigabe is
    'M = Manuelle Freigabe, A = Automatisch Freigeben zum Datum, E = Paletten Einzelanforderung';

comment on column dirkspzm32.isi_order_pos.freigabe_datum is
    'FREIGABE = früheste Startzeit';

comment on column dirkspzm32.isi_order_pos.freigegeben_datum is
    'Freigegeban am';

comment on column dirkspzm32.isi_order_pos.ist_menge is
    'Ist Menge';

comment on column dirkspzm32.isi_order_pos.komm_vorgabe_auto_depal is
    'Automatisches depaletieren?
 A=ISIPlus entscheidet, R=Zwingend Roboter, M=Zwingend Manuell';

comment on column dirkspzm32.isi_order_pos.komm_zeit_sec is
    'Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für diese Pos';

comment on column dirkspzm32.isi_order_pos.komplett_bereitstellen is
    'Warten im Loop vor der Bereitstellung; T=Ja bedeutet Warten bis alle Positionen im Loop umschalten, F=Nein wartet nicht auf alle gebinde, sonder wird ausgelagert wen möglich; '
    ;

comment on column dirkspzm32.isi_order_pos.komplett_reservieren is
    '"Grossauftrag-Strategie; Komplett-Lieferung
T=Ja    Alle Gebinte werden zum Start des Auftrags disponiert
F=Nein  Der Auftrag ist zu groß, nicht alle Gebinde können zu beginn des Autfrags disponiert werden, da diese andere dann blockieren würden. Schubweise Nachdisponieren"'
    ;

comment on column dirkspzm32.isi_order_pos.kom_lgr_orte is
    'Lagerorte aus aus denen für die Kommissionierung ware entnommen werden darf';

comment on column dirkspzm32.isi_order_pos.kom_mengeneinheit is
    'Mengeneinheit, für Kommissionierer';

comment on column dirkspzm32.isi_order_pos.kom_mg is
    'Menge Kommissionierer evtl hier Anzahl Karton';

comment on column dirkspzm32.isi_order_pos.labor_status is
    'DEFAULT = ''F''rei -> Zu vernendende Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung'
    ;

comment on column dirkspzm32.isi_order_pos.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.isi_order_pos.leitzahl is
    'Leitzahl Fertigungsauftrag';

comment on column dirkspzm32.isi_order_pos.liefer_datum is
    'Gewünsches Liefer/Transportdatum';

comment on column dirkspzm32.isi_order_pos.li_extern is
    'Lieferschein Nummer aus Externem System, sonst einen Lieferschein in eigener Tabelle anlegen';

comment on column dirkspzm32.isi_order_pos.li_nr is
    'Lieferschein Nummer';

comment on column dirkspzm32.isi_order_pos.li_pos_nr is
    'Lieferscheinposition -Nummer';

comment on column dirkspzm32.isi_order_pos.login_id is
    'ID des Erstellers';

comment on column dirkspzm32.isi_order_pos.lvs_info is
    'für Informationen vom LVS';

comment on column dirkspzm32.isi_order_pos.mengeneinheit is
    'Mengeneinheit aus Menge Basis';

comment on column dirkspzm32.isi_order_pos.menge_basis is
    'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';

comment on column dirkspzm32.isi_order_pos.mhd is
    'MHD Welches MHD soll genommen werden';

comment on column dirkspzm32.isi_order_pos.min_mhd_tage is
    'Mindest MHD-Tage für die Ware';

comment on column dirkspzm32.isi_order_pos.min_reifezeit is
    'Mindest Reifezeit für diesen Artikel';

comment on column dirkspzm32.isi_order_pos.order_datum is
    'Generierungsdatum';

comment on column dirkspzm32.isi_order_pos.order_info is
    'Info für Kommissionierer';

comment on column dirkspzm32.isi_order_pos.pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.isi_order_pos.prioritaet is
    'Priorität (0..9), 9: hohe Priorität';

comment on column dirkspzm32.isi_order_pos.prod_params is
    'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';

comment on column dirkspzm32.isi_order_pos.quelle is
    'WE wenn Einlagerung';

comment on column dirkspzm32.isi_order_pos.quell_lagerorte is
    'Lagerorte aus denen diese Ware entnommen werden kann';

comment on column dirkspzm32.isi_order_pos.satzart is
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

comment on column dirkspzm32.isi_order_pos.seriennr_id is
    'Serien-Nummer';

comment on column dirkspzm32.isi_order_pos.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_order_pos.soll_menge is
    'Soll-Menge';

comment on column dirkspzm32.isi_order_pos.startzeitpunkt_berechnet is
    'Berechneter Startzeitpunkt für diese Position';

comment on column dirkspzm32.isi_order_pos.status is
    '''N'' = Noch nicht angefangen V = In Vorbereitung F = Freigegeben E = Fertig A = Angefangen  X = Fertig, aber noch nicht zum HOST Z = Zurückgewiesen (Abgelehnt)'
    ;

comment on column dirkspzm32.isi_order_pos.strategie is
    'FIFO, LIFO ...';

comment on column dirkspzm32.isi_order_pos.transport_gruppe is
    'Z.B. Beladereihenfolge für einen LKW Tournummer Oetker';

comment on column dirkspzm32.isi_order_pos.transp_zeit_sec is
    'Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.'
    ;

comment on column dirkspzm32.isi_order_pos.upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';

comment on column dirkspzm32.isi_order_pos.vorgang_id is
    'Nummer um die Positionen zu Klammern Z.B. Tourennummer';

comment on column dirkspzm32.isi_order_pos.vorgang_pos is
    'Position im Vorgang';

comment on column dirkspzm32.isi_order_pos.vorgang_typ is
    'WEI/WAI = Zugang/Abgang Intern (z.B. Produktion), WEE/WAE = Zugang/Abgang Extern (Anlieferung, Versand) WUI/WUE = Umlagerung Intern/Extern KWE/KWA = Wareneingang/Warenabgang KONSI'
    ;

comment on column dirkspzm32.isi_order_pos.wae_ziel is
    'SPED = Spedition,
SELB = Selbstabholer,
UPS = UPS,
DPAD = Paketversand,
MASCH = Maschine,
LAGER = Lager,
(lt. HJG 2015-09-02) WA Platz aus LVS_LGR';

comment on column dirkspzm32.isi_order_pos.ware_disponiert is
    'T = True Ware bereits disponiert (Reserviert)  F = Ware nicht disponiert';

comment on column dirkspzm32.isi_order_pos.wa_menge_ueberlief is
    '"Nachschub (OL);
ULTE=Underdelivery LTE bedeutet, dass solange Paletten genommen werden, bis maximal die Menge erreicht ist. Bei der ersten Palette, die die Menge überschreitet wird die Reservierung beendet ohne diese zu reservieren
ULHM=Underdelivery LHM bedeutet, dass solange LHM (Kartons) genommen werden, bis maximal die Menge erreicht ist. Bei dem ersten LHM, das die Menge überschreitet wird die Reservierung beendet ohne dieses zu reservieren
EX=exakte Lieferung Die Menge muss exakt eingehalten werden, evtl. mit Einzelentnahmen in der Kommissionierung,
OLTE=Overdelivery LTE bedeutet, dass solange LTEs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LTE mit der die Menge überschritten wird, wird auch komplett reserviert
OLHM=Overdelivery LHM bedeutet, dass solange LHMs reserviert werden, bis die Menge Erreicht oder überschritten ist. Die LHM mit der die Menge überschritten wird, wird auch komplett reserviert
"';

comment on column dirkspzm32.isi_order_pos.zeichnung_index is
    'Zeichnungsindex';

comment on column dirkspzm32.isi_order_pos.ziel is
    'WA wenn Auslagerung';

comment on column dirkspzm32.isi_order_pos.ziel_lhm_menge is
    'Menge für das Zielgebinde';

comment on column dirkspzm32.isi_order_pos.ziel_lhm_name is
    'Zielgebinde-Typ: z.B. Behälter(-Typ), Karton(-Typ), Eimer, etc.';

comment on column dirkspzm32.isi_order_pos.ziel_lte_name is
    'Zieltraeger. z.B. Euro, HP; Ladungsträger bei Paletten, Behältertyp bei Behältern';

comment on column dirkspzm32.isi_order_pos.ziel_packschema_kopf_id is
    'Ziel-Packschema, Nachschub T21- Zeiger auf LVS_PACKSCHEMA_KOPF';


-- sqlcl_snapshot {"hash":"8e0fd8e07009ad8a1cb67101357501dad99cd10f","type":"COMMENT","name":"isi_order_pos","schemaName":"dirkspzm32","sxml":""}