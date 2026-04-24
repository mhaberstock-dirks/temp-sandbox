comment on table dirkspzm32.lvs_lam is
    'Lager Artikel Menge (Aktueller Lagerbestand kleinste Einheit)';

comment on column dirkspzm32.lvs_lam.abnr is
    'Auftragsbestätigungsnummer des Kundenauftragsbestätigung';

comment on column dirkspzm32.lvs_lam.akt_inventur_id is
    'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR';

comment on column dirkspzm32.lvs_lam.artikel_id is
    'Artikel ID in ISI_ARTIKEL';

comment on column dirkspzm32.lvs_lam.best_nr is
    'Bestellnummer beim Zugang';

comment on column dirkspzm32.lvs_lam.best_pos is
    'Bestellposition beim Zugang';

comment on column dirkspzm32.lvs_lam.charge_id is
    'ID der Charge';

comment on column dirkspzm32.lvs_lam.check_ware_transp_id is
    'Transport für den ein Waren-Check festgehalten wird';

comment on column dirkspzm32.lvs_lam.fae_id is
    'Fertigungs Einheit ID';

comment on column dirkspzm32.lvs_lam.fae_id_position is
    'R = Rechts, L = Links, V = Vorne, H = Hinten, O = Oben, U = Unten';

comment on column dirkspzm32.lvs_lam.fa_ag is
    'Aktueller Arbeitsgang der Leitzahl';

comment on column dirkspzm32.lvs_lam.fa_upos is
    'Unterposition der Arbeitsgangs';

comment on column dirkspzm32.lvs_lam.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lam.hersteller_kuerzel_liste is
    'Liste der Hersteller als Kürzel mit Semikolon getrennt';

comment on column dirkspzm32.lvs_lam.kd_art_nr is
    'Kundenartikelnummer';

comment on column dirkspzm32.lvs_lam.kunden_nr is
    'Kunde für den gefertigt wurde';

comment on column dirkspzm32.lvs_lam.labor_status is
    'Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung'
    ;

comment on column dirkspzm32.lvs_lam.labor_text is
    'Zusatztext aus Laborergebnis (Bsp. Ware darf nur zu einem bestimmten Kunden)';

comment on column dirkspzm32.lvs_lam.lam_id is
    'Lager Artikel Mengen ID auf die gebucht wurde (Bestands Key)';

comment on column dirkspzm32.lvs_lam.lam_kg is
    'Aktuelles Gewicht der Waren in KG';

comment on column dirkspzm32.lvs_lam.lam_mhd is
    'Min. Haldbar bis (Datum)';

comment on column dirkspzm32.lvs_lam.lam_mhd_ausgabe is
    'min. Haltbar bis aus LAM MHD Druck Datum,';

comment on column dirkspzm32.lvs_lam.lam_p1 is
    'Parameter P1';

comment on column dirkspzm32.lvs_lam.lam_p10 is
    'Parameter P10';

comment on column dirkspzm32.lvs_lam.lam_p2 is
    'Parameter P2';

comment on column dirkspzm32.lvs_lam.lam_p3 is
    'Parameter P3';

comment on column dirkspzm32.lvs_lam.lam_p4 is
    'Parameter P4';

comment on column dirkspzm32.lvs_lam.lam_p5 is
    'Parameter P5';

comment on column dirkspzm32.lvs_lam.lam_p6 is
    'Parameter P6';

comment on column dirkspzm32.lvs_lam.lam_p7 is
    'Parameter P7';

comment on column dirkspzm32.lvs_lam.lam_p8 is
    'Parameter P8';

comment on column dirkspzm32.lvs_lam.lam_p9 is
    'Parameter P9';

comment on column dirkspzm32.lvs_lam.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam.lam_text is
    'Zusatztext';

comment on column dirkspzm32.lvs_lam.leitzahl is
    'Fertigungsauftrag Nr. (Leitzahl)';

comment on column dirkspzm32.lvs_lam.letzte_inventur_datum is
    'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';

comment on column dirkspzm32.lvs_lam.letzte_inventur_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';

comment on column dirkspzm32.lvs_lam.letzte_inventur_login_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die Inventur hier durchgeführt';

comment on column dirkspzm32.lvs_lam.lgr_platz is
    'Aktueller Lagerplatz';

comment on column dirkspzm32.lvs_lam.lhm_c_lfd_nr is
    'laufende LHM-Nummer innerhalb der Charge (1,2,...,n)';

comment on column dirkspzm32.lvs_lam.lhm_id is
    'ID des Lagerhilfsmittel';

comment on column dirkspzm32.lvs_lam.lhm_lfd_nr is
    'laufende LHM-Nummer innerhalb des Auftrags (1,2,...,n)';

comment on column dirkspzm32.lvs_lam.lieferant_nr is
    'Lieferantennummer';

comment on column dirkspzm32.lvs_lam.li_nr_lief is
    'Lieferscheinnummer (Vom Lieferanten bei der Anlieferung)';

comment on column dirkspzm32.lvs_lam.ls_login_id is
    'Login ID des Erfassers';

comment on column dirkspzm32.lvs_lam.lte_id is
    'ID der Transporteinheit';

comment on column dirkspzm32.lvs_lam.lte_id_lieferant is
    'Packstücknummern des Lieferanten';

comment on column dirkspzm32.lvs_lam.menge is
    'Aktuelle Menge';

comment on column dirkspzm32.lvs_lam.mengeneinheit_basis is
    'Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE';

comment on column dirkspzm32.lvs_lam.menge_basis is
    'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';

comment on column dirkspzm32.lvs_lam.nr_pruefung is
    'Nummer der Prüfung (Nicht der Stammsatz der die Prüfung beschreibt)';

comment on column dirkspzm32.lvs_lam.order_pos_auf_id is
    'Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)';

comment on column dirkspzm32.lvs_lam.owner_address_id is
    'ID in der ISI_ADRESSEN für KONSI. Ist der Wert != NULL dann ist die Adresse dieser ID Eigentümer der Ware';

comment on column dirkspzm32.lvs_lam.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.lvs_lam.packschema_lfdn is
    'Nummer (Reihenfolge) auf der Palette';

comment on column dirkspzm32.lvs_lam.prod_datum is
    'Zeitpunkt des Produktion';

comment on column dirkspzm32.lvs_lam.qs_status is
    'NULL = nicht definiert, 1 = 1. Wahl (A-Ware), 2 = 2. Wahl (B-Ware), S = Schrott, [M = Musterware, ...], ZM = Zuordnungsfehler mit Mail über DIS, Z = Zuordnungsfehler, ZMM = Zuordnung Rohmaterial Fehler mit Mail über DIS'
    ;

comment on column dirkspzm32.lvs_lam.res_id is
    'Resourcen ID (Produktionsmaschine)';

comment on column dirkspzm32.lvs_lam.res_login_id is
    'Login_ID für den Bearbeiter zur Erkennung der Dispo und für Druckfunktionen (Teilreservierung einer LTE)';

comment on column dirkspzm32.lvs_lam.res_menge is
    'Reservierte Menge für Teilentnahme';

comment on column dirkspzm32.lvs_lam.res_ziel_lte_id is
    'Reservierte Menge soll bei Auftrag auf diese LTE gepackt werden';

comment on column dirkspzm32.lvs_lam.serie_id is
    'ID Der Serie';

comment on column dirkspzm32.lvs_lam.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lam.sonst_id_lieferant is
    'Weitere ID des Lieferanten (Nicht weiter spez.) für Rückverfolgung beim Lieferanten';

comment on column dirkspzm32.lvs_lam.waren_typ is
    'aus ISI_ARTIKEL: RW = Rohware, HW = Teilfertig/Halbfertigware (Zwischenprodukt), FW = Fertigware, VRW = Vorabserie Rohware, VFW = Vorabserie Fertigware'
    ;

comment on column dirkspzm32.lvs_lam.zeichnung is
    'Externe Zeichnung';

comment on column dirkspzm32.lvs_lam.zeichnung_index is
    'Zeichnungsindex';

comment on column dirkspzm32.lvs_lam.zug_datum is
    'Zugangsdatum';


-- sqlcl_snapshot {"hash":"5c6730fc2b5c03882a46592de812efe3a0ff439c","type":"COMMENT","name":"lvs_lam","schemaName":"dirkspzm32","sxml":""}