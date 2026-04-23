comment on table dirkspzm32.lvs_lam_hist is
    'Lager Artikel Menge (Aktueller Lagerbestand kleinste Einheit)';

comment on column dirkspzm32.lvs_lam_hist.abnr is
    'Auftragsbestätigungsnummer des Kundenauftragsbestätigung';

comment on column dirkspzm32.lvs_lam_hist.akt_inventur_id is
    'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR';

comment on column dirkspzm32.lvs_lam_hist.artikel_id is
    'Artikel ID in ISI_ARTIKEL';

comment on column dirkspzm32.lvs_lam_hist.best_nr is
    'Bestellnummer beim Zugang';

comment on column dirkspzm32.lvs_lam_hist.best_pos is
    'Bestellposition beim Zugang';

comment on column dirkspzm32.lvs_lam_hist.charge_id is
    'ID der Charge';

comment on column dirkspzm32.lvs_lam_hist.check_ware_transp_id is
    'Transport für den ein Waren-Check festgehalten wird';

comment on column dirkspzm32.lvs_lam_hist.fae_id is
    'Fertigungs Einheit ID';

comment on column dirkspzm32.lvs_lam_hist.fae_id_position is
    'R = Rechts, L = Links, V = Vorne, H = Hinten, O = Oben, U = Unten';

comment on column dirkspzm32.lvs_lam_hist.fa_ag is
    'Aktueller Arbeitsgang der Leitzahl';

comment on column dirkspzm32.lvs_lam_hist.fa_upos is
    'Unterposition der Arbeitsgangs';

comment on column dirkspzm32.lvs_lam_hist.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lam_hist.hersteller_kuerzel_liste is
    'Liste der Hersteller als Kürzel mit Semikolon getrennt';

comment on column dirkspzm32.lvs_lam_hist.kd_art_nr is
    'Kundenartikelnummer';

comment on column dirkspzm32.lvs_lam_hist.kunden_nr is
    'Kunde für den gefertigt wurde';

comment on column dirkspzm32.lvs_lam_hist.labor_status is
    'Laborstatus (Q, G, F.....)';

comment on column dirkspzm32.lvs_lam_hist.labor_text is
    'Zusatztext aus Laborergebnis (Bsp. Ware darf nur zu einem bestimmten Kunden)';

comment on column dirkspzm32.lvs_lam_hist.lam_id is
    'Lager Artikel Mengen ID auf die gebucht wurde (Bestands Key)';

comment on column dirkspzm32.lvs_lam_hist.lam_kg is
    'Aktuelles Gewicht der Waren in KG';

comment on column dirkspzm32.lvs_lam_hist.lam_mhd is
    'Min. Haldbar bis (Datum)';

comment on column dirkspzm32.lvs_lam_hist.lam_mhd_ausgabe is
    'min. Haltbar bis aus LAM MHD Druck Datum,';

comment on column dirkspzm32.lvs_lam_hist.lam_p1 is
    'Parameter P1';

comment on column dirkspzm32.lvs_lam_hist.lam_p10 is
    'Parameter P10';

comment on column dirkspzm32.lvs_lam_hist.lam_p2 is
    'Parameter P2';

comment on column dirkspzm32.lvs_lam_hist.lam_p3 is
    'Parameter P3';

comment on column dirkspzm32.lvs_lam_hist.lam_p4 is
    'Parameter P4';

comment on column dirkspzm32.lvs_lam_hist.lam_p5 is
    'Parameter P5';

comment on column dirkspzm32.lvs_lam_hist.lam_p6 is
    'Parameter P6';

comment on column dirkspzm32.lvs_lam_hist.lam_p7 is
    'Parameter P7';

comment on column dirkspzm32.lvs_lam_hist.lam_p8 is
    'Parameter P8';

comment on column dirkspzm32.lvs_lam_hist.lam_p9 is
    'Parameter P9';

comment on column dirkspzm32.lvs_lam_hist.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_lam_hist.lam_text is
    'Zusatztext';

comment on column dirkspzm32.lvs_lam_hist.leitzahl is
    'Fertigungsauftrag Nr. (Leitzahl)';

comment on column dirkspzm32.lvs_lam_hist.letzte_inventur_datum is
    'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';

comment on column dirkspzm32.lvs_lam_hist.letzte_inventur_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';

comment on column dirkspzm32.lvs_lam_hist.letzte_inventur_login_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die Inventur hier durchgeführt';

comment on column dirkspzm32.lvs_lam_hist.lgr_platz is
    'Aktueller Lagerplatz';

comment on column dirkspzm32.lvs_lam_hist.lhm_c_lfd_nr is
    'laufende LHM-Nummer innerhalb der Charge (1,2,...,n)';

comment on column dirkspzm32.lvs_lam_hist.lhm_id is
    'ID des Lagerhilfsmittel';

comment on column dirkspzm32.lvs_lam_hist.lhm_lfd_nr is
    'laufende LHM-Nummer innerhalb des Auftrags (1,2,...,n)';

comment on column dirkspzm32.lvs_lam_hist.lieferant_nr is
    'Lieferantennummer';

comment on column dirkspzm32.lvs_lam_hist.li_nr_lief is
    'Lieferscheinnummer (Vom Lieferanten bei der Anlieferung)';

comment on column dirkspzm32.lvs_lam_hist.ls_login_id is
    'Login ID des Erfassers';

comment on column dirkspzm32.lvs_lam_hist.lte_id is
    'ID der Transporteinheit';

comment on column dirkspzm32.lvs_lam_hist.lte_id_lieferant is
    'Packstücknummern des Lieferanten';

comment on column dirkspzm32.lvs_lam_hist.menge is
    'Aktuelle Menge';

comment on column dirkspzm32.lvs_lam_hist.mengeneinheit_basis is
    'Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE';

comment on column dirkspzm32.lvs_lam_hist.menge_basis is
    'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';

comment on column dirkspzm32.lvs_lam_hist.nr_pruefung is
    'Nummer der Prüfung (Nicht der Stammsatz der die Prüfung beschreibt)';

comment on column dirkspzm32.lvs_lam_hist.order_pos_auf_id is
    'Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)';

comment on column dirkspzm32.lvs_lam_hist.owner_address_id is
    'ID in der ISI_ADRESSEN für KONSI. Ist der Wert != NULL dann ist die Adresse dieser ID Eigentümer der Ware';

comment on column dirkspzm32.lvs_lam_hist.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.lvs_lam_hist.packschema_lfdn is
    'Nummer (Reihenfolge) auf der Palette';

comment on column dirkspzm32.lvs_lam_hist.prod_datum is
    'Zeitpunkt des Produktion';

comment on column dirkspzm32.lvs_lam_hist.qs_status is
    'NULL = nicht definiert, 1 = 1. Wahl (A-Ware), 2 = 2. Wahl (B-Ware), S = Schrott, [M = Musterware, ...]';

comment on column dirkspzm32.lvs_lam_hist.res_id is
    'Resourcen ID (Produktionsmaschine)';

comment on column dirkspzm32.lvs_lam_hist.res_login_id is
    'Login_ID für den Bearbeiter zur Erkennung der Dispo und für Druckfunktionen (Teilreservierung einer LTE)';

comment on column dirkspzm32.lvs_lam_hist.res_menge is
    'Reservierte Menge für Teilentnahme';

comment on column dirkspzm32.lvs_lam_hist.res_ziel_lte_id is
    'Reservierte Menge soll bei Auftrag auf diese LTE gepackt werden';

comment on column dirkspzm32.lvs_lam_hist.serie_id is
    'ID Der Serie';

comment on column dirkspzm32.lvs_lam_hist.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lam_hist.sonst_id_lieferant is
    'Weitere ID des Lieferanten (Nicht weiter spez.) für Rückverfolgung beim Lieferanten';

comment on column dirkspzm32.lvs_lam_hist.waren_typ is
    'aus ISI_ARTIKEL: RW = Rohware, HW = Teilfertig/Halbfertigware (Zwischenprodukt), FW = Fertigware, VRW = Vorabserie Rohware, VFW = Vorabserie Fertigware'
    ;

comment on column dirkspzm32.lvs_lam_hist.zeichnung is
    'Externe Zeichnung';

comment on column dirkspzm32.lvs_lam_hist.zeichnung_index is
    'Zeichnungsindex';

comment on column dirkspzm32.lvs_lam_hist.zug_datum is
    'Zugangsdatum';


-- sqlcl_snapshot {"hash":"d33949a6fbd6a23c49c5a634b601d26fbf4841e9","type":"COMMENT","name":"lvs_lam_hist","schemaName":"dirkspzm32","sxml":""}