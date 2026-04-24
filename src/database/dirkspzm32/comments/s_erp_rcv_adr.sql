comment on table dirkspzm32.s_erp_rcv_adr is
    'Adressen von SAP uebergeben';

comment on column dirkspzm32.s_erp_rcv_adr.adress_id_h is
    'Referenz auf den Hersteller der gegenüber dem Warenempfänger auftritt';

comment on column dirkspzm32.s_erp_rcv_adr.adr_art is
    'K = Kunde, L = Lieferant';

comment on column dirkspzm32.s_erp_rcv_adr.adr_liefer is
    'Lieferadresse beim Kunden';

comment on column dirkspzm32.s_erp_rcv_adr.adr_nr is
    'Kunden oder Lieferanten Nr.';

comment on column dirkspzm32.s_erp_rcv_adr.aktiv is
    'T = Adresse ist Aktiv, F = Adresse ist Inaktiv';

comment on column dirkspzm32.s_erp_rcv_adr.anspr is
    'Ansprechpartner';

comment on column dirkspzm32.s_erp_rcv_adr.avis is
    'NULL = Kein AVIS, PDF_EMAIL, TXT_EMAIL, EDI_EMAIL';

comment on column dirkspzm32.s_erp_rcv_adr.charge_lte_id_lief_tausch is
    '''T'' => Bei der Etikettierung mit Scanner muss die LTE_ID und Charge getauscht werden. ';

comment on column dirkspzm32.s_erp_rcv_adr.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz erstellt wurde';

comment on column dirkspzm32.s_erp_rcv_adr.created_login_id is
    '  Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.s_erp_rcv_adr.ecc_hersteller_id is
    'Hersteller ID bei ECC (wird ggf. bei EDI gebraucht)';

comment on column dirkspzm32.s_erp_rcv_adr.edi_gln is
    'EDI: Global Location Number (zur globalen Identifizierung von Herst. Warenemp. etc.)';

comment on column dirkspzm32.s_erp_rcv_adr.edi_gln_b is
    'Referenz auf den Einkäufer der gegenüber dem Warenempfänger auftritt';

comment on column dirkspzm32.s_erp_rcv_adr.edi_gln_r is
    'Referenz auf die Rechnungsadresse für den Warenempfänger';

comment on column dirkspzm32.s_erp_rcv_adr.eink_preis_berechnen is
    'Vorgabe Artikel_Lieferant.EINK_PREIS Berechnen oder Eingeben.!';

comment on column dirkspzm32.s_erp_rcv_adr.email is
    'E-Mail-Adresse';

comment on column dirkspzm32.s_erp_rcv_adr.ext_etiketten_druck is
    '''T'' => für diesen Lieferanten ist die externe Etikettendruck-Funktion freigeschaltet';

comment on column dirkspzm32.s_erp_rcv_adr.fax is
    'Fax Nr.';

comment on column dirkspzm32.s_erp_rcv_adr.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.s_erp_rcv_adr.info_1 is
    'Freier Text zu einem Lieferanten bzw. Kunden';

comment on column dirkspzm32.s_erp_rcv_adr.isiplus_module is
    'Welche ISIPlus Module stehen an dieser Adresse zur Verfügung (z.B. bei Fillialen, ext. Lager-Dienstleistern). Modulnamen mit ; getrennt.'
    ;

comment on column dirkspzm32.s_erp_rcv_adr.kundennrlief is
    'Meine Kundennummer bei Lieferant / meine Lieferantennummer beim Kunden';

comment on column dirkspzm32.s_erp_rcv_adr.land is
    'Land';

comment on column dirkspzm32.s_erp_rcv_adr.land_kurz is
    'Länderkürzel';

comment on column dirkspzm32.s_erp_rcv_adr.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.s_erp_rcv_adr.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.s_erp_rcv_adr.lhm_etiketten_layout is
    'Etikettenlayout für diesen Kunden';

comment on column dirkspzm32.s_erp_rcv_adr.lhm_etiketten_name is
    'Etikettenname für LHM';

comment on column dirkspzm32.s_erp_rcv_adr.lhm_etiketten_spez_barcode is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.s_erp_rcv_adr.lhm_etiketten_typ is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.s_erp_rcv_adr.lieferbedingungen is
    'Lieferbedingungen';

comment on column dirkspzm32.s_erp_rcv_adr.lief_eink_rabatt_faktor is
    'Vorgabe Eink_Rabatt_Faktor für Berechnung Eink_Preis';

comment on column dirkspzm32.s_erp_rcv_adr.lte_etiketten_layout is
    'Etikettenlayout für diesen Kunden';

comment on column dirkspzm32.s_erp_rcv_adr.lte_etiketten_name is
    'Etikettenname für Transpoprteinheiten';

comment on column dirkspzm32.s_erp_rcv_adr.lte_etiketten_spez_barcode is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.s_erp_rcv_adr.lte_etiketten_typ is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.s_erp_rcv_adr.name_1 is
    'Eintrag Name 1';

comment on column dirkspzm32.s_erp_rcv_adr.name_2 is
    'Eintrag Name 2';

comment on column dirkspzm32.s_erp_rcv_adr.name_3 is
    'Eintrag Name 3';

comment on column dirkspzm32.s_erp_rcv_adr.rg_mwst_text is
    'Text für Erklärung der MWST Ausland / Inlanf und Europa';

comment on column dirkspzm32.s_erp_rcv_adr.tel is
    'Telefon Nr.';

comment on column dirkspzm32.s_erp_rcv_adr.ust_id_nummer is
    'Umsatzsteuer ID Nummer';

comment on column dirkspzm32.s_erp_rcv_adr.waehrung is
    'Währung EUR, USD, ...';

comment on column dirkspzm32.s_erp_rcv_adr.zahlungsbedingungen is
    'Zahlungsbedingungen';


-- sqlcl_snapshot {"hash":"e3c00d9d432a67ea82abb7d857bcca2eb3059f2b","type":"COMMENT","name":"s_erp_rcv_adr","schemaName":"dirkspzm32","sxml":""}