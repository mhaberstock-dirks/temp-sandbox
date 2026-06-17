comment on column DIRKSPZM32.ISI_PURCH_KOPF."AEND_DATUM" is 'Datum Datensatz geändert ';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."AEND_LOGIN_ID" is 'geändert von';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."EIN_LIEFERANT_ERLAUBT" is 'Bestellung erlaubt mehrere, bzw. nur einen Lieferanten.';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."ERZ_DATUM" is 'Datum Datensatz erzeugt';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."ERZ_LOGIN_ID" is 'erzeugt von';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."FIRMA_NR" is 'Firma Nr.';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."FREITEXT_AB" is 'Freitext pro Auftrag für die Auftragsbestätigung';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."FREITEXT_LIEFS" is 'Freitext pro Auftrag für den Lieferschein';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."FREITEXT_RECHNUNG" is 'Freitext pro Auftrag für die Rechnung';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."GRUSS_TEXT_AB" is 'Grußformel / -text für die Auftragsbestätigung (wird auf der ersten Seite vor der Auflistung ausgegeben)';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."ID" is 'Unique Identifier';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."INFO" is 'Auf den Formularen wird erst INFO und dann der TEXT_ANHANG gelistet';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."KUNDEN_AUFTRAGS_NR" is 'Kunden-Auftragsnummer dieser Order';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."KUNDE_CONTACT_ID" is 'Kunde Ansprechpartner -> ISI_CONTACT.CONTACT_ID';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."KUNDE_ID" is 'Kunde  isi_adresse.Adress_ID';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."LIEFERANT_ID" is 'Lieferant_ID = 0 ist Kopf  -> ISI_ADRESSEN.ADRESS_ID';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."LIEFERSCHEIN_DATUM" is 'Lieferschein-Datum';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."LIEFERSCHEIN_NR" is 'Lieferschein-Nummer';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."LIEFER_DATUM" is 'geplantes Lieferdatum';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."LIEF_CONTACT_ID" is 'Lieferant Login ID  -> ISI_CONTACT.CONTACT_ID';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."LOGIN_ID" is 'Besteller, Creator -> ISI_USER';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."MAX_POS_NR" is 'max Pos-Nr. dieses Auftrags bei nicht fortlaufenden Positionsnummern';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."PROJECT_NR" is '-> ISI_PROJECT.PROJECT_NR';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."PRO_FORMA_RECH_NR" is 'Pro-forma Rechnungsnummer (auch für Vorkasse verwendet)';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."RECHNUNGS_NR" is 'Rechnungsnummer';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."SID" is 'SID';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."STATUS" is '''N''=neu angelegt, ''B''=in Bearbeitung , ''G''=gelöscht, ''F''=fertig, ''E''=Abschluss durchgeführt ende';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."TEXT_ANHANG" is 'Freier Text (z.B. Grußformel) auf der Bestellung, Rechnung , ... Auf den Formularen wird erst INFO und dann der TEXT_ANHANG ausgegeben';
comment on column DIRKSPZM32.ISI_PURCH_KOPF."VORG_TYP" is '''BE''=Bestellung, ''RE''=Rechnung, ''ANG''=Angebot, ''KALK''=Kalkulation, ''AUFTR''=Auftrag, ''GUTS''=Gutschrift, ''LIEF''=Lieferschein';



-- sqlcl_snapshot {"hash":"f5f3db6f9caaa52126de6beeb3b56e4b80c461f8","type":"COMMENT","name":"isi_purch_kopf","schemaName":"dirkspzm32","sxml":""}