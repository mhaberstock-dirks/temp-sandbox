comment on column dirkspzm32.isi_purch_kopf.aend_datum is
    'Datum Datensatz geändert ';

comment on column dirkspzm32.isi_purch_kopf.aend_login_id is
    'geändert von';

comment on column dirkspzm32.isi_purch_kopf.ein_lieferant_erlaubt is
    'Bestellung erlaubt mehrere, bzw. nur einen Lieferanten.';

comment on column dirkspzm32.isi_purch_kopf.erz_datum is
    'Datum Datensatz erzeugt';

comment on column dirkspzm32.isi_purch_kopf.erz_login_id is
    'erzeugt von';

comment on column dirkspzm32.isi_purch_kopf.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.isi_purch_kopf.freitext_ab is
    'Freitext pro Auftrag für die Auftragsbestätigung';

comment on column dirkspzm32.isi_purch_kopf.freitext_liefs is
    'Freitext pro Auftrag für den Lieferschein';

comment on column dirkspzm32.isi_purch_kopf.freitext_rechnung is
    'Freitext pro Auftrag für die Rechnung';

comment on column dirkspzm32.isi_purch_kopf.gruss_text_ab is
    'Grußformel / -text für die Auftragsbestätigung (wird auf der ersten Seite vor der Auflistung ausgegeben)';

comment on column dirkspzm32.isi_purch_kopf.id is
    'Unique Identifier';

comment on column dirkspzm32.isi_purch_kopf.info is
    'Auf den Formularen wird erst INFO und dann der TEXT_ANHANG gelistet';

comment on column dirkspzm32.isi_purch_kopf.kunden_auftrags_nr is
    'Kunden-Auftragsnummer dieser Order';

comment on column dirkspzm32.isi_purch_kopf.kunde_contact_id is
    'Kunde Ansprechpartner -> ISI_CONTACT.CONTACT_ID';

comment on column dirkspzm32.isi_purch_kopf.kunde_id is
    'Kunde  isi_adresse.Adress_ID';

comment on column dirkspzm32.isi_purch_kopf.lieferant_id is
    'Lieferant_ID = 0 ist Kopf  -> ISI_ADRESSEN.ADRESS_ID';

comment on column dirkspzm32.isi_purch_kopf.lieferschein_datum is
    'Lieferschein-Datum';

comment on column dirkspzm32.isi_purch_kopf.lieferschein_nr is
    'Lieferschein-Nummer';

comment on column dirkspzm32.isi_purch_kopf.liefer_datum is
    'geplantes Lieferdatum';

comment on column dirkspzm32.isi_purch_kopf.lief_contact_id is
    'Lieferant Login ID  -> ISI_CONTACT.CONTACT_ID';

comment on column dirkspzm32.isi_purch_kopf.login_id is
    'Besteller, Creator -> ISI_USER';

comment on column dirkspzm32.isi_purch_kopf.max_pos_nr is
    'max Pos-Nr. dieses Auftrags bei nicht fortlaufenden Positionsnummern';

comment on column dirkspzm32.isi_purch_kopf.project_nr is
    '-> ISI_PROJECT.PROJECT_NR';

comment on column dirkspzm32.isi_purch_kopf.pro_forma_rech_nr is
    'Pro-forma Rechnungsnummer (auch für Vorkasse verwendet)';

comment on column dirkspzm32.isi_purch_kopf.rechnungs_nr is
    'Rechnungsnummer';

comment on column dirkspzm32.isi_purch_kopf.sid is
    'SID';

comment on column dirkspzm32.isi_purch_kopf.status is
    '''N''=neu angelegt, ''B''=in Bearbeitung , ''G''=gelöscht, ''F''=fertig, ''E''=Abschluss durchgeführt ende';

comment on column dirkspzm32.isi_purch_kopf.text_anhang is
    'Freier Text (z.B. Grußformel) auf der Bestellung, Rechnung , ... Auf den Formularen wird erst INFO und dann der TEXT_ANHANG ausgegeben'
    ;

comment on column dirkspzm32.isi_purch_kopf.vorg_typ is
    '''BE''=Bestellung, ''RE''=Rechnung, ''ANG''=Angebot, ''KALK''=Kalkulation, ''AUFTR''=Auftrag, ''GUTS''=Gutschrift, ''LIEF''=Lieferschein'
    ;


-- sqlcl_snapshot {"hash":"491a346b8cab31457945495e02dcb151b5a1109b","type":"COMMENT","name":"isi_purch_kopf","schemaName":"dirkspzm32","sxml":""}