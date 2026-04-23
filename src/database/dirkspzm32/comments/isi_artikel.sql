comment on table dirkspzm32.isi_artikel is
    'Artikelstamm';

comment on column dirkspzm32.isi_artikel.abc is
    '1= A = Schnell  2= B = Mittel 3= C = Langsam';

comment on column dirkspzm32.isi_artikel.abfuell_abschalt_fein is
    'Absch. Fein';

comment on column dirkspzm32.isi_artikel.abfuell_abschalt_grob is
    'Absch. Grob';

comment on column dirkspzm32.isi_artikel.abfuell_abschalt_mittel is
    'Absch. Mittel';

comment on column dirkspzm32.isi_artikel.abfuell_soll is
    'Sollgewicht für Abfüllung';

comment on column dirkspzm32.isi_artikel.abfuell_toleranz_minus is
    'Toleranz Minus';

comment on column dirkspzm32.isi_artikel.abfuell_toleranz_plus is
    'Toleranz Plus';

comment on column dirkspzm32.isi_artikel.aend_datum is
    'Datum der Aenderung';

comment on column dirkspzm32.isi_artikel.aend_login_id is
    'ID des Aenderung';

comment on column dirkspzm32.isi_artikel.aktiv is
    'T = Aktiv; F = Inaktiv';

comment on column dirkspzm32.isi_artikel.akt_inventur_id is
    'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR';

comment on column dirkspzm32.isi_artikel.anz_etikett_je_lte is
    'Anzahl gleicher Etiketten die pro Palette gedruckt werden müssen';

comment on column dirkspzm32.isi_artikel.artikel is
    'Artikelnummer aus Schnittstelle';

comment on column dirkspzm32.isi_artikel.artikel_fuer_kunde is
    'Adress-ID aus ISI_ADRESSEN für die Zuordnung KONSI für diesen Artikel';

comment on column dirkspzm32.isi_artikel.artikel_fuer_kunde_etikett is
    'Kundennummer für Etikettendruck zur Auswahl einenes Etiketts';

comment on column dirkspzm32.isi_artikel.artikel_id is
    'Nummer aus seq';

comment on column dirkspzm32.isi_artikel.artikel_kurz is
    'zweite Artikelnummer z.B. bei unterschiedlichen Nummern in verschiedenen Systemen';

comment on column dirkspzm32.isi_artikel.artikel_p1 is
    'Parameter P1';

comment on column dirkspzm32.isi_artikel.artikel_p10 is
    'Parameter P10';

comment on column dirkspzm32.isi_artikel.artikel_p2 is
    'Parameter P2';

comment on column dirkspzm32.isi_artikel.artikel_p3 is
    'Parameter P3';

comment on column dirkspzm32.isi_artikel.artikel_p4 is
    'Parameter P4';

comment on column dirkspzm32.isi_artikel.artikel_p5 is
    'Parameter P5';

comment on column dirkspzm32.isi_artikel.artikel_p6 is
    'Parameter P6';

comment on column dirkspzm32.isi_artikel.artikel_p7 is
    'Parameter P7';

comment on column dirkspzm32.isi_artikel.artikel_p8 is
    'Parameter P8';

comment on column dirkspzm32.isi_artikel.artikel_p9 is
    'Parameter P9';

comment on column dirkspzm32.isi_artikel.art_breite is
    'Breite';

comment on column dirkspzm32.isi_artikel.art_dicke is
    'Dicke';

comment on column dirkspzm32.isi_artikel.art_durch is
    'Durchmesser';

comment on column dirkspzm32.isi_artikel.art_gruppe_id is
    'Zugehörigkeit zu einer Artikelgruppe';

comment on column dirkspzm32.isi_artikel.art_laenge is
    'Länge';

comment on column dirkspzm32.isi_artikel.beschaffungs_kosten is
    'Kosten für Fremdbezug';

comment on column dirkspzm32.isi_artikel.bezeichnung1 is
    'Bezeichnung 1';

comment on column dirkspzm32.isi_artikel.bezeichnung2 is
    'Bezeichnung 2';

comment on column dirkspzm32.isi_artikel.bezeichnung3 is
    'Bezeichnung 3';

comment on column dirkspzm32.isi_artikel.default_lieferant_id is
    'Standard Lieferant_ID';

comment on column dirkspzm32.isi_artikel.ean is
    'EAN je kleinster Einheit (z.B. Je Becher, Päckchen, Stück etc.)';

comment on column dirkspzm32.isi_artikel.einlagerung is
    'einlagerung als AR Artikelrein, MP mischpalette MK Mischkanal';

comment on column dirkspzm32.isi_artikel.einlager_tage is
    'Einlagerung in LVS Fifo identisch z.B. 3 tage MHD ist identisch NULL = MHD Tage aus Firma';

comment on column dirkspzm32.isi_artikel.einsatzgewicht_kg is
    'Einsatzgewicht in kg (erforderlich für die Berechnung des Legierungszuschlags)';

comment on column dirkspzm32.isi_artikel.einzelgewicht_g is
    'Einzelgewicht des Artikels in Gramm (g) Erforderlich zur Berechnung des Gesamtgewichtes in unterschiedlichen LHM';

comment on column dirkspzm32.isi_artikel.ersatzteil is
    'T = ist ein Ersatzteil, F = ist kein Ersatzteil, U = unbekannt/undefiniert (grayed in checkbox)';

comment on column dirkspzm32.isi_artikel.erz_datum is
    'Datum der Erstellung';

comment on column dirkspzm32.isi_artikel.erz_login_id is
    'ID des Erstellers';

comment on column dirkspzm32.isi_artikel.gefahren_klasse is
    '0 = Klein, 99 = Hoch';

comment on column dirkspzm32.isi_artikel.herstell_kosten is
    'Kosten für eigene Herstellung';

comment on column dirkspzm32.isi_artikel.inventur_datum is
    'Datum der letzten inventur dieses Artikels';

comment on column dirkspzm32.isi_artikel.inventur_user_id is
    'Verantwortlicher der letzten Inventur';

comment on column dirkspzm32.isi_artikel.labor_vorgabe_status is
    'U = Unfrei (Muss noch geprüft werden), F = Frei (Kann geliefert werden), G = Gesperrt (Geprüft und gesperrt)';

comment on column dirkspzm32.isi_artikel.lagerorte is
    'Lagerorte in die eingelagert werden darf';

comment on column dirkspzm32.isi_artikel.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.isi_artikel.laufrichtung is
    'Ist das Teil Laufrichtungsgebunden? Null=noch nicht spezifiziert! M=mit Bindung, O=ohne Bindung, E=egal (Montage Reifenflanke innen/aussen egal)'
    ;

comment on column dirkspzm32.isi_artikel.leg_zuschlag_artikel_id is
    'Referenz auf den Artikeldatensatz der den Legierungszuschlag repräsentiert';

comment on column dirkspzm32.isi_artikel.leg_zuschlag_p_1000kg is
    'Aktueller Wert des Legierungszuschlags in normierter Form von Preis pro 1000 kg (wichtig für die Berechnung des Verkaufswertes inkl. Zuschlag)'
    ;

comment on column dirkspzm32.isi_artikel.letzte_inventur_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';

comment on column dirkspzm32.isi_artikel.lgr_letzter_platz is
    'Neue überdenken (wird je Werk benötigt) Achtung: Es gibt zwischefertigungsschritte ohne eigene Artikelnummer';

comment on column dirkspzm32.isi_artikel.lgr_ort_vorgabe is
    'Lagerort für als Vorgabe im Automatikmodus LTE_CRT ohne Linie';

comment on column dirkspzm32.isi_artikel.lgr_such_grp is
    'Neue überdenken (wird je Werk benötigt) Achtung: Es gibt zwischefertigungsschritte ohne eigene Artikelnummer';

comment on column dirkspzm32.isi_artikel.lhm_ean is
    'EAN für LHM';

comment on column dirkspzm32.isi_artikel.lhm_gewicht_kg is
    'LHM Gewicht incl. Verpackung';

comment on column dirkspzm32.isi_artikel.lhm_hoehe_lage is
    'Höhe einer Lage (Kartons, LHM, ....)';

comment on column dirkspzm32.isi_artikel.lhm_menge is
    'LHM = Kleinste Gebindemenge';

comment on column dirkspzm32.isi_artikel.lhm_name is
    'Name des LHM z.B. K600 = Karton 600 aus LVS_LHM_CFG';

comment on column dirkspzm32.isi_artikel.lhm_namen is
    'In diese LHMs kann dieser Artikel auch eingelagert werden mit ; getrennt';

comment on column dirkspzm32.isi_artikel.lhm_tara is
    'LHM TARA ist das Taragewicht für die Verwiegung (Übergabe an die Waage)';

comment on column dirkspzm32.isi_artikel.lte_breite_max is
    'Max Breite incl. Überstand';

comment on column dirkspzm32.isi_artikel.lte_ean is
    'EAN für eine Transporteinheit';

comment on column dirkspzm32.isi_artikel.lte_gewicht_kg is
    'Max Gewicht der Transporteinheit (Gilt nur für Artikelreine Ttransporteinheit)';

comment on column dirkspzm32.isi_artikel.lte_hoehe_max is
    'Max Höhe incl. Transporteinheit';

comment on column dirkspzm32.isi_artikel.lte_lhm_lagen is
    'Anzahl Lagen (LHM''s) je LTE';

comment on column dirkspzm32.isi_artikel.lte_lhm_menge is
    'Anzahl LHM je Transporteinheit';

comment on column dirkspzm32.isi_artikel.lte_lhm_pro_lage is
    'Anzahl LHM je Lage';

comment on column dirkspzm32.isi_artikel.lte_menge is
    'Menge je Mengeneinheit pro. Transporteinheit';

comment on column dirkspzm32.isi_artikel.lte_name is
    'EURO = Europalette, INDU = INDU-Palette, CHEPEURO = Chep-Europalette ... aus LVS_LTE_CFG';

comment on column dirkspzm32.isi_artikel.lte_namen is
    'Auf diese LTEs kann dieser Artikel optinal auch eingelagert werden mit ; getrennt';

comment on column dirkspzm32.isi_artikel.lte_tiefe_max is
    'Max Tiefe incl. Überstand';

comment on column dirkspzm32.isi_artikel.materialart is
    'Material z.B. Zur für findung der Rohdichte aus ISI_ROHSTOFF_MATERIALART';

comment on column dirkspzm32.isi_artikel.max_bestand is
    'Maximaler Bestand in kleinster Mengeneinheit des Artikels';

comment on column dirkspzm32.isi_artikel.max_temp is
    'max. temperatur für Lagerung';

comment on column dirkspzm32.isi_artikel.mengeneinheit is
    'Mengeneinheit STK = Stück, KG = Kilogramm, L = Liter, M = Meter, M2, M3, PCK = Päckchen';

comment on column dirkspzm32.isi_artikel.mengeneinheit_basis is
    'Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE';

comment on column dirkspzm32.isi_artikel.menge_basis is
    'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';

comment on column dirkspzm32.isi_artikel.mhd_berechnung is
    'TA= Taggenau MA= Monatsanfang ME=Monatsende  WE= Wochen Ende WochenAnfang';

comment on column dirkspzm32.isi_artikel.mhd_festes_datum is
    'Dieser Artikel bekommt immer dieses Datum fest eingestellt als MHD ';

comment on column dirkspzm32.isi_artikel.mhd_tage is
    'Min. Haldbar in Tagen';

comment on column dirkspzm32.isi_artikel.min_bestand is
    'Mindest Bestand in kleinster mengeneinheit des Artikels';

comment on column dirkspzm32.isi_artikel.min_mhd_tage_ausl is
    'Mindest MHD-Tage für Auslagerung';

comment on column dirkspzm32.isi_artikel.min_mhd_tage_ms is
    'Mindest MHD-Tage für die Weiterverarbeitung';

comment on column dirkspzm32.isi_artikel.min_temp is
    'mindest temperatur für Lagerung';

comment on column dirkspzm32.isi_artikel.opt_grp is
    'Rüstgruppe zur optimierung im APS';

comment on column dirkspzm32.isi_artikel.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.isi_artikel.pack_vorschr is
    'Verpackungsvorschrift';

comment on column dirkspzm32.isi_artikel.preis_gleitend is
    'Preis gleitend in EUR';

comment on column dirkspzm32.isi_artikel.preis_standard is
    'Standardpreis in EUR';

comment on column dirkspzm32.isi_artikel.reife_zeit_tage is
    'Reifezeit in Tagen   0,5 = 12 Stunden';

comment on column dirkspzm32.isi_artikel.res_artikel is
    'Reservierung der Lagerplätze über Artikel (Achtung, FW Artikel kann auch HW sein (Arbeitsgang) darum auch FA_AG mit abspeichern'
    ;

comment on column dirkspzm32.isi_artikel.res_charge is
    'Reservierung der Lagerplätze über Charge (Chargenrein)';

comment on column dirkspzm32.isi_artikel.res_fa_auftrag is
    'Reservierung der Lagerplätze über Auftragsnummer';

comment on column dirkspzm32.isi_artikel.res_kunde is
    'Reservierung der Lagerplätze über Kunde';

comment on column dirkspzm32.isi_artikel.res_mhd is
    'Reservierung der Lagerplätze über MHD';

comment on column dirkspzm32.isi_artikel.res_mhd_tage is
    'Reservierung der Lagerplätze über MHD Wie lange werden MHD''s als gleich betrachtet';

comment on column dirkspzm32.isi_artikel.res_serie is
    'Reservierung der Lagerplätze über Seriennummer';

comment on column dirkspzm32.isi_artikel.res_string is
    'Vorgabe für RES_STRING -> Lagerplatzreservierung für Bsp. Artikel, Charge oder FA + FA_AG + Charge etc.';

comment on column dirkspzm32.isi_artikel.stueckzahl_pro_preis is
    'Anzahl Stück pro Eink bzw Verk Preis';

comment on column dirkspzm32.isi_artikel.verk_preis is
    'Verkauf Preis ';

comment on column dirkspzm32.isi_artikel.verk_rabatt_faktor is
    'Verkaus Rabatt Faktor bezogen auf standart EINK_PREIS';

comment on column dirkspzm32.isi_artikel.waren_gruppe is
    '1=Ring 2=Ventilteller 3=VT Ring 20=Tech 30=SPÜ 40=FLVT60=Mat';

comment on column dirkspzm32.isi_artikel.waren_typ is
    'RW = Rohware, HW = Teilfertig/Halbfertigware (Zwischenprodukt), FW = Fertigware, VRW = Vorabserie Rohware, VFW = Vorabserie Fertigware'
    ;

comment on column dirkspzm32.isi_artikel.wert_klasse is
    '0 = Klein, 99 = Hoch';

comment on column dirkspzm32.isi_artikel.wieder_besch is
    'Wiederbeschaffungszeit in Tagen';

comment on column dirkspzm32.isi_artikel.zeichnung is
    'Externe Zeichnung';

comment on column dirkspzm32.isi_artikel.zeichnung_index is
    'Zeichnungsindex (quasi Variante des Artikels)';


-- sqlcl_snapshot {"hash":"59c2dd488fe37e638cbc5fa07584adbe7eb6ef56","type":"COMMENT","name":"isi_artikel","schemaName":"dirkspzm32","sxml":""}