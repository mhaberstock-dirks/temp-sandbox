comment on table dirkspzm32.s_rcv_adr is
    'Adressen von DIAF uebergeben';

comment on column dirkspzm32.s_rcv_adr.adress_id_h is
    'Referenz auf den Hersteller der gegenüber dem Warenempfänger auftritt';

comment on column dirkspzm32.s_rcv_adr.adr_art is
    'K = Kunde, L = Lieferant';

comment on column dirkspzm32.s_rcv_adr.adr_liefer is
    'Lieferadresse beim Kunden';

comment on column dirkspzm32.s_rcv_adr.adr_nr is
    'Kunden oder Lieferanten Nr.';

comment on column dirkspzm32.s_rcv_adr.aktiv is
    'T = Adresse ist Aktiv, F = Adresse ist Inaktiv';

comment on column dirkspzm32.s_rcv_adr.anspr is
    'Ansprechpatner';

comment on column dirkspzm32.s_rcv_adr.avis is
    'NULL = Kein AVIS, PDF_EMAIL, TXT_EMAIL, EDI_EMAIL';

comment on column dirkspzm32.s_rcv_adr.edi_gln is
    'EDI: GLN = Global Location Number';

comment on column dirkspzm32.s_rcv_adr.edi_gln_b is
    'EDI: GLN = Einkäufer der gegenüber dem Warenempfänger auftritt';

comment on column dirkspzm32.s_rcv_adr.edi_gln_r is
    'EDI: GLN = Rechnungsadresse für den Warenempfänger';

comment on column dirkspzm32.s_rcv_adr.eink_preis_berechnen is
    'Vorgabe Artikel_Lieferant.EINK_PREIS Berechnen oder Eingeben.!';

comment on column dirkspzm32.s_rcv_adr.email is
    'E-Mail-Adresse';

comment on column dirkspzm32.s_rcv_adr.fax is
    'Fax Nr.';

comment on column dirkspzm32.s_rcv_adr.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.s_rcv_adr.info_1 is
    'Freier Text zu einem Lieferanten bzw. Kunden';

comment on column dirkspzm32.s_rcv_adr.kundennrlief is
    'Meine Kundennummer bei Lieferant / meine Lieferantennummer beim Kunden';

comment on column dirkspzm32.s_rcv_adr.land is
    'Land';

comment on column dirkspzm32.s_rcv_adr.land_kurz is
    'Länderkürzel';

comment on column dirkspzm32.s_rcv_adr.lhm_etiketten_layout is
    'Etikettenlayout für diesen Kunden';

comment on column dirkspzm32.s_rcv_adr.lhm_etiketten_name is
    'Etikettenname für LHM';

comment on column dirkspzm32.s_rcv_adr.lhm_etiketten_typ is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.s_rcv_adr.lieferbedingungen is
    'Lieferbedingungen';

comment on column dirkspzm32.s_rcv_adr.lief_eink_rabatt_faktor is
    'Vorgabe Eink_Rabatt_Faktor für Berechnung Eink_Preis';

comment on column dirkspzm32.s_rcv_adr.lte_etiketten_layout is
    'Etikettenlayout für diesen Kunden';

comment on column dirkspzm32.s_rcv_adr.lte_etiketten_name is
    'Etikettenname für Transpoprteinheiten';

comment on column dirkspzm32.s_rcv_adr.lte_etiketten_typ is
    'Etikettentyp (CCG, VDA; ...)';

comment on column dirkspzm32.s_rcv_adr.name_1 is
    'Eintrag Name 1';

comment on column dirkspzm32.s_rcv_adr.name_2 is
    'Eintrag Name 2';

comment on column dirkspzm32.s_rcv_adr.name_3 is
    'Eintrag Name 3';

comment on column dirkspzm32.s_rcv_adr.rg_mwst_text is
    'Text für Erklärung der MWST Ausland / Inlanf und Europa';

comment on column dirkspzm32.s_rcv_adr.tel is
    'Telefon Nr.';

comment on column dirkspzm32.s_rcv_adr.ust_id_nummer is
    'Umsatzsteuer ID Nummer';

comment on column dirkspzm32.s_rcv_adr.waehrung is
    'Währung EUR, USD, ...';

comment on column dirkspzm32.s_rcv_adr.zahlungsbedingungen is
    'Zahlungsbedingungen';


-- sqlcl_snapshot {"hash":"a92d60fc8a9e4690c6661dd2123bfa33d3423464","type":"COMMENT","name":"s_rcv_adr","schemaName":"dirkspzm32","sxml":""}