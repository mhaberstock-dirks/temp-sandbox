comment on table dirkspzm32.isi_adressen is
    'Adressen';

comment on column dirkspzm32.isi_adressen.adress_id_h is
    'Referenz auf den Hersteller der gegenüber dem Warenempfänger auftritt';

comment on column dirkspzm32.isi_adressen.adr_art is
    'E = Eigene (z.B. Firma),  K = Kunde/Warenempfänger (W = Ref. Warenempfänger), L = Lieferant, S = Spedition, B = Buyer/Käufer, H = Hersteller, R = Rechnungsadresse'
    ;

comment on column dirkspzm32.isi_adressen.adr_liefer is
    'ID: Ziel-Filliale, Standort, Lieferadresse (Kunden; Gruppenmerkmal ist die Kundenummer)';

comment on column dirkspzm32.isi_adressen.adr_nr is
    'Kunden oder Lieferanten Nr.';

comment on column dirkspzm32.isi_adressen.aktiv is
    'T = Adresse ist Aktiv, F = Adresse ist Inaktiv';

comment on column dirkspzm32.isi_adressen.anspr is
    'Ansprechpartner';

comment on column dirkspzm32.isi_adressen.avis is
    'NULL = Kein AVIS, PDF_EMAIL, TXT_EMAIL, EDI_EMAIL';

comment on column dirkspzm32.isi_adressen.charge_lte_id_lief_tausch is
    '''T'' => Bei der Etikettierung mit Scanner muss die LTE_ID und Charge getauscht werden. ';

comment on column dirkspzm32.isi_adressen.ecc_hersteller_id is
    'Hersteller ID bei ECC (wird ggf. bei EDI gebraucht)';

comment on column dirkspzm32.isi_adressen.edi_gln is
    'EDI: Global Location Number (zur globalen Identifizierung von Herst. Warenemp. etc.) ODETTE_ID';

comment on column dirkspzm32.isi_adressen.edi_gln_b is
    'Referenz auf den Einkäufer der gegenüber dem Warenempfänger auftritt';

comment on column dirkspzm32.isi_adressen.edi_gln_r is
    'Referenz auf die Rechnungsadresse für den Warenempfänger';

comment on column dirkspzm32.isi_adressen.eink_preis_berechnen is
    'Vorgabe Artikel_Lieferant.EINK_PREIS Berechnen oder Eingeben.!';

comment on column dirkspzm32.isi_adressen.email is
    'E-Mail-Adresse';

comment on column dirkspzm32.isi_adressen.ext_etiketten_druck is
    '''T'' => für diesen Lieferanten ist die externe Etikettendruck-Funktion freigeschaltet';

comment on column dirkspzm32.isi_adressen.fax is
    'Fax Nr.';

comment on column dirkspzm32.isi_adressen.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_adressen.info_1 is
    'Freier Text zu einem Lieferanten bzw. Kunden';

comment on column dirkspzm32.isi_adressen.isiplus_module is
    'Welche ISIPlus Module stehen an dieser Adresse zur Verfügung (z.B. bei Fillialen, ext. Lager-Dienstleistern). Modulnamen mit ; getrennt.'
    ;

comment on column dirkspzm32.isi_adressen.kundennrlief is
    'Meine Kundennummer bei Lieferant / meine Lieferantennummer beim Kunden (EDI DUNS Nummer)';

comment on column dirkspzm32.isi_adressen.land is
    'Land';

comment on column dirkspzm32.isi_adressen.land_kurz is
    'Länderkürzel';

comment on column dirkspzm32.isi_adressen.lhm_barcode_kopf is
    'Basisnummer für den Karton';

comment on column dirkspzm32.isi_adressen.lhm_barcode_laenge is
    'Länge des Barcodes für den Karton inkl. Kopf  (Basisnummer , SID, etc.)';

comment on column dirkspzm32.isi_adressen.lhm_barcode_type is
    'Typ des Barcodes für den Karton (CCG, VDA, NVE...)';

comment on column dirkspzm32.isi_adressen.lhm_eigener_nr_kreis is
    '''T'' => bedeutet Kunde hat eigenen Nummernkreis, sonst ''F''';

comment on column dirkspzm32.isi_adressen.lhm_etiketten_layout is
    'Etikettenlayout für diesen Kunden';

comment on column dirkspzm32.isi_adressen.lhm_etiketten_name is
    'Etikettenname für LHM';

comment on column dirkspzm32.isi_adressen.lhm_etiketten_spez_barcode is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.isi_adressen.lhm_etiketten_typ is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.isi_adressen.lieferbedingungen is
    'Lieferbedingungen';

comment on column dirkspzm32.isi_adressen.lief_eink_rabatt_faktor is
    'Vorgabe Eink_Rabatt_Faktor für Berechnung Eink_Preis';

comment on column dirkspzm32.isi_adressen.lte_barcode_kopf is
    'Basisnummer bei Cerealia 34027453 oder SID';

comment on column dirkspzm32.isi_adressen.lte_barcode_laenge is
    'Länge des Barcodes inkl. Kopf (Basisnummer, SID etc.)';

comment on column dirkspzm32.isi_adressen.lte_barcode_type is
    'Typ des Barcodes (CCG, VDA, NVE...)';

comment on column dirkspzm32.isi_adressen.lte_eigener_nr_kreis is
    '''T'' => bedeutet Kunde hat eigenen Nummernkreis, sonst ''F''';

comment on column dirkspzm32.isi_adressen.lte_etiketten_layout is
    'Etikettenlayout für diesen Kunden';

comment on column dirkspzm32.isi_adressen.lte_etiketten_name is
    'Etikettenname für Transpoprteinheiten';

comment on column dirkspzm32.isi_adressen.lte_etiketten_spez_barcode is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.isi_adressen.lte_etiketten_typ is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.isi_adressen.lte_lhm_nummernkreis_aktuell is
    'Aktuelle Nummer innerhalb des Nummernkreises';

comment on column dirkspzm32.isi_adressen.lte_lhm_nummernkreis_bis is
    'Ende des Nummernkreises';

comment on column dirkspzm32.isi_adressen.lte_lhm_nummernkreis_von is
    'Beginn des Nummernkreises';

comment on column dirkspzm32.isi_adressen.name_1 is
    'Eintrag Name 1';

comment on column dirkspzm32.isi_adressen.name_2 is
    'Eintrag Name 2';

comment on column dirkspzm32.isi_adressen.name_3 is
    'Eintrag Name 3';

comment on column dirkspzm32.isi_adressen.region_code is
    'Bundesland / Region - Zur Feiertagsfindung z.B.: 
DE-NRW Nordrhein-Westfalen
DE-NI Niedersachsen 
DE-BY Bayern
DE-BY-AU Augsburg in Bayern
Die Feiertagd-Kürzel sind dan z.B.:
DE Alle in Deuschland
DE-NI Feiertage in Niedersachsen 
zu finden where region_code like ISI_FEIERTAGE.f_laender || ''%''';

comment on column dirkspzm32.isi_adressen.rg_mwst_text is
    'Text für Erklärung der MWST Ausland / Inlanf und Europa';

comment on column dirkspzm32.isi_adressen.tel is
    'Telefon Nr.';

comment on column dirkspzm32.isi_adressen.ust_id_nummer is
    'Umsatzsteuer ID Nummer';

comment on column dirkspzm32.isi_adressen.waehrung is
    'Währung EUR, USD, ...';

comment on column dirkspzm32.isi_adressen.zahlungsbedingungen is
    'Zahlungsbedingungen';

comment on column dirkspzm32.isi_adressen.zollpflicht is
    'Ist der Kunde oder Lieferant Zollpflichtig (z.B. muss eine Zollplbe oder Zollpapiere ausgestellt werden)';


-- sqlcl_snapshot {"hash":"1bb841f484d649f57955462dc079d3c849ce0d51","type":"COMMENT","name":"isi_adressen","schemaName":"dirkspzm32","sxml":""}