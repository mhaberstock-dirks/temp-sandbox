comment on table dirkspzm32.s_rcv_artikel is
    'Artikelstamm uebergabe aus DIAF';

comment on column dirkspzm32.s_rcv_artikel.abc is
    'A = Schnell B = Mittel C = Langsam';

comment on column dirkspzm32.s_rcv_artikel.abfuell_abschalt_fein is
    'Absch. Fein';

comment on column dirkspzm32.s_rcv_artikel.abfuell_abschalt_grob is
    'Absch. Grob';

comment on column dirkspzm32.s_rcv_artikel.abfuell_abschalt_mittel is
    'Absch. Mittel';

comment on column dirkspzm32.s_rcv_artikel.abfuell_soll is
    'Sollmenge für die Abfüllung';

comment on column dirkspzm32.s_rcv_artikel.abfuell_toleranz_minus is
    'Toleranz Minus';

comment on column dirkspzm32.s_rcv_artikel.abfuell_toleranz_plus is
    'Toleranz Plus';

comment on column dirkspzm32.s_rcv_artikel.aktiv is
    'Status Aktiv T = Artikelnummer ist gültig, F = Artikelnummer ist ungültig';

comment on column dirkspzm32.s_rcv_artikel.anz_etikett_je_lte is
    'Anzahl gleicher Etiketten die pro Palette gedruckt werden müssen';

comment on column dirkspzm32.s_rcv_artikel.artikel is
    'Artikelnummer aus Schnittstelle';

comment on column dirkspzm32.s_rcv_artikel.artikel_fuer_kunde is
    'ADRESS_ID aus ISI_ADRESSEN';

comment on column dirkspzm32.s_rcv_artikel.artikel_fuer_kunde_etikett is
    'Kundennummer für Etikettendruck zur Auswahl einenes Etiketts';

comment on column dirkspzm32.s_rcv_artikel.artikel_kurz is
    'Artikel_Kurz aus alten DOS-Systemen';

comment on column dirkspzm32.s_rcv_artikel.artikel_p1 is
    'Parameter P1';

comment on column dirkspzm32.s_rcv_artikel.artikel_p10 is
    'Parameter P10';

comment on column dirkspzm32.s_rcv_artikel.artikel_p2 is
    'Parameter P2';

comment on column dirkspzm32.s_rcv_artikel.artikel_p3 is
    'Parameter P3';

comment on column dirkspzm32.s_rcv_artikel.artikel_p4 is
    'Parameter P4';

comment on column dirkspzm32.s_rcv_artikel.artikel_p5 is
    'Parameter P5';

comment on column dirkspzm32.s_rcv_artikel.artikel_p6 is
    'Parameter P6';

comment on column dirkspzm32.s_rcv_artikel.artikel_p7 is
    'Parameter P7';

comment on column dirkspzm32.s_rcv_artikel.artikel_p8 is
    'Parameter P8';

comment on column dirkspzm32.s_rcv_artikel.artikel_p9 is
    'Parameter P9';

comment on column dirkspzm32.s_rcv_artikel.art_gruppe_id is
    'Zugehörigkeit zu einer Artikelgruppe';

comment on column dirkspzm32.s_rcv_artikel.beschaffungs_kosten is
    'Kosten für Fremdbezug';

comment on column dirkspzm32.s_rcv_artikel.bezeichnung1 is
    'Bezeichnung 1';

comment on column dirkspzm32.s_rcv_artikel.bezeichnung2 is
    'Bezeichnung 2';

comment on column dirkspzm32.s_rcv_artikel.bezeichnung3 is
    'Bezeichnung 3';

comment on column dirkspzm32.s_rcv_artikel.breite is
    'Breite des Artikels in mm';

comment on column dirkspzm32.s_rcv_artikel.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';

comment on column dirkspzm32.s_rcv_artikel.created_login_id is
    'Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.s_rcv_artikel.durch is
    'Durchmesser';

comment on column dirkspzm32.s_rcv_artikel.ean is
    'EAN je kleinster Einheit (z.B. Je Becher, Päckchen, Stück etc.)';

comment on column dirkspzm32.s_rcv_artikel.einlagerung is
    'Eeinlagerung als AR Artikelrein, MP mischpalette MK Mischkanal';

comment on column dirkspzm32.s_rcv_artikel.gefahren_klasse is
    '0 = Klein, 99 = Hoch';

comment on column dirkspzm32.s_rcv_artikel.gewicht is
    'Gewicht in Gramm je Mengeneinheit';

comment on column dirkspzm32.s_rcv_artikel.herstell_kosten is
    'Herstell';

comment on column dirkspzm32.s_rcv_artikel.hoehe is
    'Höhe des Artikels in mm';

comment on column dirkspzm32.s_rcv_artikel.labor_vorg_status is
    'U = Unfrei (Muss noch geprüft werden), F = Frei (Kann geliefert werden), G = Gesperrt (Geprüft und gesperrt)';

comment on column dirkspzm32.s_rcv_artikel.laenge is
    'Länge des Artikels in mm';

comment on column dirkspzm32.s_rcv_artikel.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter als Default';

comment on column dirkspzm32.s_rcv_artikel.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.s_rcv_artikel.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.s_rcv_artikel.laufrichtung is
    'Ist das Teil Laufrichtungsgebunden? Null=noch nicht spezifiziert! M=mit Bindung, O=ohne Bindung, E=egal (Montage Reifenflanke innen/aussen egal)'
    ;

comment on column dirkspzm32.s_rcv_artikel.lhm_ean is
    'EAN für LHM';

comment on column dirkspzm32.s_rcv_artikel.lhm_gewicht_kg is
    'LHM Gewicht incl. Verpackung';

comment on column dirkspzm32.s_rcv_artikel.lhm_menge is
    'LHM = Kleinste Gebindemenge';

comment on column dirkspzm32.s_rcv_artikel.lhm_name is
    'Name des LHM z.B. K600 = Karton 600 aus LVS_LHM_CFG';

comment on column dirkspzm32.s_rcv_artikel.lhm_tara is
    'LHM TARA ist das Taragewicht für die Verwiegung (Übergabe an die Waage)';

comment on column dirkspzm32.s_rcv_artikel.lte_breite_max is
    'Max Breite incl. Überstand';

comment on column dirkspzm32.s_rcv_artikel.lte_ean is
    'EAN für eine Transporteinheit';

comment on column dirkspzm32.s_rcv_artikel.lte_gewicht_kg is
    'Max Gewicht der Transporteinheit (Gilt nur für Artikelreine Ttransporteinheit)';

comment on column dirkspzm32.s_rcv_artikel.lte_hoehe_lage is
    'Höhe einer Lage (LHM''s)';

comment on column dirkspzm32.s_rcv_artikel.lte_hoehe_max is
    'Max Höhe incl. Transporteinheit';

comment on column dirkspzm32.s_rcv_artikel.lte_lhm_lagen is
    'Anzahl Lagen (LHM''s) je LTE';

comment on column dirkspzm32.s_rcv_artikel.lte_lhm_menge is
    'Anzahl LHM je Transporteinheit';

comment on column dirkspzm32.s_rcv_artikel.lte_lhm_pro_lage is
    'Anzahl LHM je Lage';

comment on column dirkspzm32.s_rcv_artikel.lte_menge is
    'Menge je Mengeneinheit pro. Transporteinheit';

comment on column dirkspzm32.s_rcv_artikel.lte_name is
    'EURO = Europalette, INDU = INDU-Palette, CHEPEURO = Chep-Europalette ... aus LVS_LTE_CFG';

comment on column dirkspzm32.s_rcv_artikel.lte_tiefe_max is
    'Max Tiefe incl. Überstand';

comment on column dirkspzm32.s_rcv_artikel.materialart is
    'Material z.B. Zur für findung der Rohdichte aus S_DIAF_RES_ROHSTOFF_MATERIALART';

comment on column dirkspzm32.s_rcv_artikel.max_lager_temp is
    'Maximale Temperatur im Lager';

comment on column dirkspzm32.s_rcv_artikel.mengeneinheit is
    'Mengeneinheit STK = Stück, KG = Kilogramm, L = Liter, M = Meter, M2, M3, PCK = Päckchen';

comment on column dirkspzm32.s_rcv_artikel.mengeneinheit_basis is
    'Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE';

comment on column dirkspzm32.s_rcv_artikel.menge_basis is
    'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';

comment on column dirkspzm32.s_rcv_artikel.mhd_berechnung is
    'TA= Taggenau MA= Monatsanfang ME=Monatsende  WE= Wochen Ende WochenAnfang';

comment on column dirkspzm32.s_rcv_artikel.mhd_festes_datum is
    'Dieser Artikel bekommt immer dieses Datum fest eingestellt als MHD ';

comment on column dirkspzm32.s_rcv_artikel.mhd_tage is
    'Min. Haldbar in Tagen';

comment on column dirkspzm32.s_rcv_artikel.min_lager_temp is
    'Minimale Temperatur im Lager';

comment on column dirkspzm32.s_rcv_artikel.min_mhd_ausl_tage is
    'Minimun an MHD-Tagen für Auslagerungen';

comment on column dirkspzm32.s_rcv_artikel.min_mhd_tage_ausl is
    'Mindest MHD-Tage für Auslagerung';

comment on column dirkspzm32.s_rcv_artikel.min_mhd_tage_ms is
    'Mindest MHD-Tage für die Weiterverarbeitung';

comment on column dirkspzm32.s_rcv_artikel.min_mhd_weitverarb_tage is
    'Minimun an MHD-Tagen für Weiterverarbeitung';

comment on column dirkspzm32.s_rcv_artikel.opt_grp is
    'Rüstgruppe zur optimierung im APS';

comment on column dirkspzm32.s_rcv_artikel.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.s_rcv_artikel.pack_vorschr is
    'Verpackungsvorschrift';

comment on column dirkspzm32.s_rcv_artikel.preis_gleitend is
    'Preis gleitend in EUR';

comment on column dirkspzm32.s_rcv_artikel.preis_standard is
    'Standardpreis in EUR';

comment on column dirkspzm32.s_rcv_artikel.reife_zeit_tage is
    'Reifezeit in Tagen   0,5 = 12 Stunden';

comment on column dirkspzm32.s_rcv_artikel.res_artikel is
    'Reservierung der Lagerplätze über Artikel (Achtung, FW Artikel kann auch HW sein (Arbeitsgang) darum auch FA_AG mit abspeichern'
    ;

comment on column dirkspzm32.s_rcv_artikel.res_charge is
    'Reservierung der Lagerplätze über Charge (Chargenrein)';

comment on column dirkspzm32.s_rcv_artikel.res_fa_auftrag is
    'Reservierung der Lagerplätze über Auftragsnummer';

comment on column dirkspzm32.s_rcv_artikel.res_kunde is
    'Reservierung der Lagerplätze über Kunde';

comment on column dirkspzm32.s_rcv_artikel.res_mhd is
    'Reservierung der Lagerplätze über MHD';

comment on column dirkspzm32.s_rcv_artikel.res_mhd_tage is
    'Reservierung der Lagerplätze über MHD Wie lange werden MHD''s als gleich betrachtet';

comment on column dirkspzm32.s_rcv_artikel.res_serie is
    'Reservierung der Lagerplätze über Seriennummer';

comment on column dirkspzm32.s_rcv_artikel.res_string is
    'Vorgabe für RES_STRING -> Lagerplatzreservierung für Bsp. Artikel, Charge oder FA + FA_AG + Charge etc.';

comment on column dirkspzm32.s_rcv_artikel.stueckzahl_pro_preis is
    'Stückzahl pro EINK- bzw . VERK_PREIS  ';

comment on column dirkspzm32.s_rcv_artikel.volumen is
    'Volumen des Artikels in cm3';

comment on column dirkspzm32.s_rcv_artikel.volumen_cm3 is
    'Volumen in CM3';

comment on column dirkspzm32.s_rcv_artikel.waren_gruppe is
    '1=Ring 2=Ventilteller 3=VT Ring 20=Tech 30=SPÜ 40=FLVT60=Mat';

comment on column dirkspzm32.s_rcv_artikel.waren_typ is
    'RW = Rohware, HW = Teilfertig/Halbfertigware (Zwischenprodukt), FW Fertigware';

comment on column dirkspzm32.s_rcv_artikel.wert_klasse is
    '0 = Klein, 99 = Hoch';

comment on column dirkspzm32.s_rcv_artikel.wieder_besch is
    'Wiederbeschaffungszeit in Tagen';

comment on column dirkspzm32.s_rcv_artikel.zeichnung_index is
    'Zeichnungsindex (quasi Variante des Artikels)';


-- sqlcl_snapshot {"hash":"13ab790a78a84cdfec58f5e492923bb1af7ba8c3","type":"COMMENT","name":"s_rcv_artikel","schemaName":"dirkspzm32","sxml":""}