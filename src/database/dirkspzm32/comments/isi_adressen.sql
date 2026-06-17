comment on table DIRKSPZM32.ISI_ADRESSEN is 'Adressen';
comment on column DIRKSPZM32.ISI_ADRESSEN."ADRESS_ID_H" is 'Referenz auf den Hersteller der gegenüber dem Warenempfänger auftritt';
comment on column DIRKSPZM32.ISI_ADRESSEN."ADR_ART" is 'E = Eigene (z.B. Firma),  K = Kunde/Warenempfänger (W = Ref. Warenempfänger), L = Lieferant, S = Spedition, B = Buyer/Käufer, H = Hersteller, R = Rechnungsadresse';
comment on column DIRKSPZM32.ISI_ADRESSEN."ADR_LIEFER" is 'ID: Ziel-Filliale, Standort, Lieferadresse (Kunden; Gruppenmerkmal ist die Kundenummer)';
comment on column DIRKSPZM32.ISI_ADRESSEN."ADR_NR" is 'Kunden oder Lieferanten Nr.';
comment on column DIRKSPZM32.ISI_ADRESSEN."AKTIV" is 'T = Adresse ist Aktiv, F = Adresse ist Inaktiv';
comment on column DIRKSPZM32.ISI_ADRESSEN."ANSPR" is 'Ansprechpartner';
comment on column DIRKSPZM32.ISI_ADRESSEN."AVIS" is 'NULL = Kein AVIS, PDF_EMAIL, TXT_EMAIL, EDI_EMAIL';
comment on column DIRKSPZM32.ISI_ADRESSEN."CHARGE_LTE_ID_LIEF_TAUSCH" is '''T'' => Bei der Etikettierung mit Scanner muss die LTE_ID und Charge getauscht werden. ';
comment on column DIRKSPZM32.ISI_ADRESSEN."ECC_HERSTELLER_ID" is 'Hersteller ID bei ECC (wird ggf. bei EDI gebraucht)';
comment on column DIRKSPZM32.ISI_ADRESSEN."EDI_GLN" is 'EDI: Global Location Number (zur globalen Identifizierung von Herst. Warenemp. etc.) ODETTE_ID';
comment on column DIRKSPZM32.ISI_ADRESSEN."EDI_GLN_B" is 'Referenz auf den Einkäufer der gegenüber dem Warenempfänger auftritt';
comment on column DIRKSPZM32.ISI_ADRESSEN."EDI_GLN_R" is 'Referenz auf die Rechnungsadresse für den Warenempfänger';
comment on column DIRKSPZM32.ISI_ADRESSEN."EINK_PREIS_BERECHNEN" is 'Vorgabe Artikel_Lieferant.EINK_PREIS Berechnen oder Eingeben.!';
comment on column DIRKSPZM32.ISI_ADRESSEN."EMAIL" is 'E-Mail-Adresse';
comment on column DIRKSPZM32.ISI_ADRESSEN."EXT_ETIKETTEN_DRUCK" is '''T'' => für diesen Lieferanten ist die externe Etikettendruck-Funktion freigeschaltet';
comment on column DIRKSPZM32.ISI_ADRESSEN."FAX" is 'Fax Nr.';
comment on column DIRKSPZM32.ISI_ADRESSEN."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_ADRESSEN."INFO_1" is 'Freier Text zu einem Lieferanten bzw. Kunden';
comment on column DIRKSPZM32.ISI_ADRESSEN."ISIPLUS_MODULE" is 'Welche ISIPlus Module stehen an dieser Adresse zur Verfügung (z.B. bei Fillialen, ext. Lager-Dienstleistern). Modulnamen mit ; getrennt.';
comment on column DIRKSPZM32.ISI_ADRESSEN."KUNDENNRLIEF" is 'Meine Kundennummer bei Lieferant / meine Lieferantennummer beim Kunden (EDI DUNS Nummer)';
comment on column DIRKSPZM32.ISI_ADRESSEN."LAND" is 'Land';
comment on column DIRKSPZM32.ISI_ADRESSEN."LAND_KURZ" is 'Länderkürzel';
comment on column DIRKSPZM32.ISI_ADRESSEN."LHM_BARCODE_KOPF" is 'Basisnummer für den Karton';
comment on column DIRKSPZM32.ISI_ADRESSEN."LHM_BARCODE_LAENGE" is 'Länge des Barcodes für den Karton inkl. Kopf  (Basisnummer , SID, etc.)';
comment on column DIRKSPZM32.ISI_ADRESSEN."LHM_BARCODE_TYPE" is 'Typ des Barcodes für den Karton (CCG, VDA, NVE...)';
comment on column DIRKSPZM32.ISI_ADRESSEN."LHM_EIGENER_NR_KREIS" is '''T'' => bedeutet Kunde hat eigenen Nummernkreis, sonst ''F''';
comment on column DIRKSPZM32.ISI_ADRESSEN."LHM_ETIKETTEN_LAYOUT" is 'Etikettenlayout für diesen Kunden';
comment on column DIRKSPZM32.ISI_ADRESSEN."LHM_ETIKETTEN_NAME" is 'Etikettenname für LHM';
comment on column DIRKSPZM32.ISI_ADRESSEN."LHM_ETIKETTEN_SPEZ_BARCODE" is 'Etikettentyp (CCG, VDA; ...)';
comment on column DIRKSPZM32.ISI_ADRESSEN."LHM_ETIKETTEN_TYP" is 'Etikettentyp (CCG, VDA; ...)';
comment on column DIRKSPZM32.ISI_ADRESSEN."LIEFERBEDINGUNGEN" is 'Lieferbedingungen';
comment on column DIRKSPZM32.ISI_ADRESSEN."LIEF_EINK_RABATT_FAKTOR" is 'Vorgabe Eink_Rabatt_Faktor für Berechnung Eink_Preis';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_BARCODE_KOPF" is 'Basisnummer bei Cerealia 34027453 oder SID';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_BARCODE_LAENGE" is 'Länge des Barcodes inkl. Kopf (Basisnummer, SID etc.)';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_BARCODE_TYPE" is 'Typ des Barcodes (CCG, VDA, NVE...)';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_EIGENER_NR_KREIS" is '''T'' => bedeutet Kunde hat eigenen Nummernkreis, sonst ''F''';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_ETIKETTEN_LAYOUT" is 'Etikettenlayout für diesen Kunden';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_ETIKETTEN_NAME" is 'Etikettenname für Transpoprteinheiten';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_ETIKETTEN_SPEZ_BARCODE" is 'Etikettentyp (CCG, VDA; ...)';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_ETIKETTEN_TYP" is 'Etikettentyp (CCG, VDA; ...)';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_LHM_NUMMERNKREIS_AKTUELL" is 'Aktuelle Nummer innerhalb des Nummernkreises';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_LHM_NUMMERNKREIS_BIS" is 'Ende des Nummernkreises';
comment on column DIRKSPZM32.ISI_ADRESSEN."LTE_LHM_NUMMERNKREIS_VON" is 'Beginn des Nummernkreises';
comment on column DIRKSPZM32.ISI_ADRESSEN."NAME_1" is 'Eintrag Name 1';
comment on column DIRKSPZM32.ISI_ADRESSEN."NAME_2" is 'Eintrag Name 2';
comment on column DIRKSPZM32.ISI_ADRESSEN."NAME_3" is 'Eintrag Name 3';
comment on column DIRKSPZM32.ISI_ADRESSEN."REGION_CODE" is 'Bundesland / Region - Zur Feiertagsfindung z.B.: 
DE-NRW Nordrhein-Westfalen
DE-NI Niedersachsen 
DE-BY Bayern
DE-BY-AU Augsburg in Bayern
Die Feiertagd-Kürzel sind dan z.B.:
DE Alle in Deuschland
DE-NI Feiertage in Niedersachsen 
zu finden where region_code like ISI_FEIERTAGE.f_laender || ''%''';
comment on column DIRKSPZM32.ISI_ADRESSEN."RG_MWST_TEXT" is 'Text für Erklärung der MWST Ausland / Inlanf und Europa';
comment on column DIRKSPZM32.ISI_ADRESSEN."TEL" is 'Telefon Nr.';
comment on column DIRKSPZM32.ISI_ADRESSEN."UST_ID_NUMMER" is 'Umsatzsteuer ID Nummer';
comment on column DIRKSPZM32.ISI_ADRESSEN."WAEHRUNG" is 'Währung EUR, USD, ...';
comment on column DIRKSPZM32.ISI_ADRESSEN."ZAHLUNGSBEDINGUNGEN" is 'Zahlungsbedingungen';
comment on column DIRKSPZM32.ISI_ADRESSEN."ZOLLPFLICHT" is 'Ist der Kunde oder Lieferant Zollpflichtig (z.B. muss eine Zollplbe oder Zollpapiere ausgestellt werden)';



-- sqlcl_snapshot {"hash":"5681ce406d0b91993df3fcf5a049e336f4982968","type":"COMMENT","name":"isi_adressen","schemaName":"dirkspzm32","sxml":""}