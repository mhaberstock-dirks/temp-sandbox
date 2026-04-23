comment on column dirkspzm32.isi_purch_pos.aend_datum is
    'Änderungsdatum';

comment on column dirkspzm32.isi_purch_pos.aend_login_id is
    'geändert von ->isi_USER.USER_ID';

comment on column dirkspzm32.isi_purch_pos.artikel_id is
    '-> ISI_ARTIKEL.ARTIKEL_ID';

comment on column dirkspzm32.isi_purch_pos.bestell_datum is
    'Bestelldatum';

comment on column dirkspzm32.isi_purch_pos.eink_preis is
    'Einkaufspreis';

comment on column dirkspzm32.isi_purch_pos.eink_rabatt_faktor is
    'Einkauspreis Rabatt-Faktor';

comment on column dirkspzm32.isi_purch_pos.erz_datum is
    'Erzeugungsdatum';

comment on column dirkspzm32.isi_purch_pos.erz_login_id is
    'angelegt von  -> isi_USER.USER_ID';

comment on column dirkspzm32.isi_purch_pos.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.isi_purch_pos.freitext is
    'Freitext pro Position für alle (Druck-)Ausgaben gleichzeitig';

comment on column dirkspzm32.isi_purch_pos.freitext_ab is
    'Freitext pro Position für die Auftragsbestätigung';

comment on column dirkspzm32.isi_purch_pos.freitext_liefs is
    'Freitext pro Position für den Lieferschein';

comment on column dirkspzm32.isi_purch_pos.freitext_rechnung is
    'Freitext pro Position für die Rechnung';

comment on column dirkspzm32.isi_purch_pos.id is
    'Unique Identifier';

comment on column dirkspzm32.isi_purch_pos.kopf_id is
    '-> ISI_PURCH_KOPF.ID';

comment on column dirkspzm32.isi_purch_pos.lieferant_id is
    '-> ISI_ADRESSEN.AD:RESS_ID ';

comment on column dirkspzm32.isi_purch_pos.lieferant_nr is
    '-> ISI_ADRESSEN.ADR_NR';

comment on column dirkspzm32.isi_purch_pos.liefer_menge is
    'gelieferte Menge';

comment on column dirkspzm32.isi_purch_pos.lief_plan_abr_kal_id is
    'Unique ID (GUID/UUID) des Lieferplanabruf-Kalendereintrags aus dem diese Auftragsposition generiert wurde';

comment on column dirkspzm32.isi_purch_pos.menge is
    'Bestell- / Liefermenge';

comment on column dirkspzm32.isi_purch_pos.mengeneinheit is
    'Mengeneinheit ';

comment on column dirkspzm32.isi_purch_pos.mwst is
    'Mehrwertsteuer';

comment on column dirkspzm32.isi_purch_pos.parent_pos is
    'Vorgänger Positionsnummer -> dann ist dies eine Unterposition';

comment on column dirkspzm32.isi_purch_pos.pos is
    'Positionsnummer ';

comment on column dirkspzm32.isi_purch_pos.sid is
    'SID';

comment on column dirkspzm32.isi_purch_pos.status is
    '''N''=neu angelegt, ''B''=bestellt , ''G''=gelöscht, ''F''=fertig, ''E''=Abschluss durchgeführt ende. ALLE UNBENUTZT! ZUR ZEIT IST STATUS IMMER NULL'
    ;

comment on column dirkspzm32.isi_purch_pos.stueckzahl_pro_preis is
    'Anzahl Stück pro Eink.- bzw. Verk.-Preis';

comment on column dirkspzm32.isi_purch_pos.verk_preis is
    'Verkaufspreis';

comment on column dirkspzm32.isi_purch_pos.verk_rabatt_faktor is
    'Verkaufspreis Rabatt-Faktor';

comment on column dirkspzm32.isi_purch_pos.vorg_typ is
    '''BE''=Bestellung, ''RE''=Rechnung, ''ANG''=Angebot, ''KALK''=Kalkulation, ''AUFTR''=Auftrag';

comment on column dirkspzm32.isi_purch_pos.waehrung is
    'Währung';

comment on column dirkspzm32.isi_purch_pos.wek_datum is
    'WE Kontrolle Datum';

comment on column dirkspzm32.isi_purch_pos.wek_login_id is
    'WE Kontrolle durch Person';

comment on column dirkspzm32.isi_purch_pos.wek_ok is
    '''T''=OK, ''F''=Wareneingangskontrolle fehlgeschlagen';


-- sqlcl_snapshot {"hash":"18e188d7a3a985d13b97a2e3869a2d095299fba2","type":"COMMENT","name":"isi_purch_pos","schemaName":"dirkspzm32","sxml":""}