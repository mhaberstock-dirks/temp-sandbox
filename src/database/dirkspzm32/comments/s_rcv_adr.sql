comment on table DIRKSPZM32.S_RCV_ADR is 'Adressen von DIAF uebergeben';
comment on column DIRKSPZM32.S_RCV_ADR."ADRESS_ID_H" is 'Referenz auf den Hersteller der gegenüber dem Warenempfänger auftritt';
comment on column DIRKSPZM32.S_RCV_ADR."ADR_ART" is 'K = Kunde, L = Lieferant';
comment on column DIRKSPZM32.S_RCV_ADR."ADR_LIEFER" is 'Lieferadresse beim Kunden';
comment on column DIRKSPZM32.S_RCV_ADR."ADR_NR" is 'Kunden oder Lieferanten Nr.';
comment on column DIRKSPZM32.S_RCV_ADR."AKTIV" is 'T = Adresse ist Aktiv, F = Adresse ist Inaktiv';
comment on column DIRKSPZM32.S_RCV_ADR."ANSPR" is 'Ansprechpatner';
comment on column DIRKSPZM32.S_RCV_ADR."AVIS" is 'NULL = Kein AVIS, PDF_EMAIL, TXT_EMAIL, EDI_EMAIL';
comment on column DIRKSPZM32.S_RCV_ADR."EDI_GLN" is 'EDI: GLN = Global Location Number';
comment on column DIRKSPZM32.S_RCV_ADR."EDI_GLN_B" is 'EDI: GLN = Einkäufer der gegenüber dem Warenempfänger auftritt';
comment on column DIRKSPZM32.S_RCV_ADR."EDI_GLN_R" is 'EDI: GLN = Rechnungsadresse für den Warenempfänger';
comment on column DIRKSPZM32.S_RCV_ADR."EINK_PREIS_BERECHNEN" is 'Vorgabe Artikel_Lieferant.EINK_PREIS Berechnen oder Eingeben.!';
comment on column DIRKSPZM32.S_RCV_ADR."EMAIL" is 'E-Mail-Adresse';
comment on column DIRKSPZM32.S_RCV_ADR."FAX" is 'Fax Nr.';
comment on column DIRKSPZM32.S_RCV_ADR."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.S_RCV_ADR."INFO_1" is 'Freier Text zu einem Lieferanten bzw. Kunden';
comment on column DIRKSPZM32.S_RCV_ADR."KUNDENNRLIEF" is 'Meine Kundennummer bei Lieferant / meine Lieferantennummer beim Kunden';
comment on column DIRKSPZM32.S_RCV_ADR."LAND" is 'Land';
comment on column DIRKSPZM32.S_RCV_ADR."LAND_KURZ" is 'Länderkürzel';
comment on column DIRKSPZM32.S_RCV_ADR."LHM_ETIKETTEN_LAYOUT" is 'Etikettenlayout für diesen Kunden';
comment on column DIRKSPZM32.S_RCV_ADR."LHM_ETIKETTEN_NAME" is 'Etikettenname für LHM';
comment on column DIRKSPZM32.S_RCV_ADR."LHM_ETIKETTEN_TYP" is 'Etikettentyp (CCG, VDA; ...)';
comment on column DIRKSPZM32.S_RCV_ADR."LIEFERBEDINGUNGEN" is 'Lieferbedingungen';
comment on column DIRKSPZM32.S_RCV_ADR."LIEF_EINK_RABATT_FAKTOR" is 'Vorgabe Eink_Rabatt_Faktor für Berechnung Eink_Preis';
comment on column DIRKSPZM32.S_RCV_ADR."LTE_ETIKETTEN_LAYOUT" is 'Etikettenlayout für diesen Kunden';
comment on column DIRKSPZM32.S_RCV_ADR."LTE_ETIKETTEN_NAME" is 'Etikettenname für Transpoprteinheiten';
comment on column DIRKSPZM32.S_RCV_ADR."LTE_ETIKETTEN_TYP" is 'Etikettentyp (CCG, VDA; ...)';
comment on column DIRKSPZM32.S_RCV_ADR."NAME_1" is 'Eintrag Name 1';
comment on column DIRKSPZM32.S_RCV_ADR."NAME_2" is 'Eintrag Name 2';
comment on column DIRKSPZM32.S_RCV_ADR."NAME_3" is 'Eintrag Name 3';
comment on column DIRKSPZM32.S_RCV_ADR."RG_MWST_TEXT" is 'Text für Erklärung der MWST Ausland / Inlanf und Europa';
comment on column DIRKSPZM32.S_RCV_ADR."TEL" is 'Telefon Nr.';
comment on column DIRKSPZM32.S_RCV_ADR."UST_ID_NUMMER" is 'Umsatzsteuer ID Nummer';
comment on column DIRKSPZM32.S_RCV_ADR."WAEHRUNG" is 'Währung EUR, USD, ...';
comment on column DIRKSPZM32.S_RCV_ADR."ZAHLUNGSBEDINGUNGEN" is 'Zahlungsbedingungen';



-- sqlcl_snapshot {"hash":"95f44aa4b90980c14785d7ea352237fc828e0036","type":"COMMENT","name":"s_rcv_adr","schemaName":"dirkspzm32","sxml":""}