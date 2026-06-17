comment on column DIRKSPZM32.ISI_PURCH_POS."AEND_DATUM" is 'Änderungsdatum';
comment on column DIRKSPZM32.ISI_PURCH_POS."AEND_LOGIN_ID" is 'geändert von ->isi_USER.USER_ID';
comment on column DIRKSPZM32.ISI_PURCH_POS."ARTIKEL_ID" is '-> ISI_ARTIKEL.ARTIKEL_ID';
comment on column DIRKSPZM32.ISI_PURCH_POS."BESTELL_DATUM" is 'Bestelldatum';
comment on column DIRKSPZM32.ISI_PURCH_POS."EINK_PREIS" is 'Einkaufspreis';
comment on column DIRKSPZM32.ISI_PURCH_POS."EINK_RABATT_FAKTOR" is 'Einkauspreis Rabatt-Faktor';
comment on column DIRKSPZM32.ISI_PURCH_POS."ERZ_DATUM" is 'Erzeugungsdatum';
comment on column DIRKSPZM32.ISI_PURCH_POS."ERZ_LOGIN_ID" is 'angelegt von  -> isi_USER.USER_ID';
comment on column DIRKSPZM32.ISI_PURCH_POS."FIRMA_NR" is 'Firma Nr.';
comment on column DIRKSPZM32.ISI_PURCH_POS."FREITEXT" is 'Freitext pro Position für alle (Druck-)Ausgaben gleichzeitig';
comment on column DIRKSPZM32.ISI_PURCH_POS."FREITEXT_AB" is 'Freitext pro Position für die Auftragsbestätigung';
comment on column DIRKSPZM32.ISI_PURCH_POS."FREITEXT_LIEFS" is 'Freitext pro Position für den Lieferschein';
comment on column DIRKSPZM32.ISI_PURCH_POS."FREITEXT_RECHNUNG" is 'Freitext pro Position für die Rechnung';
comment on column DIRKSPZM32.ISI_PURCH_POS."ID" is 'Unique Identifier';
comment on column DIRKSPZM32.ISI_PURCH_POS."KOPF_ID" is '-> ISI_PURCH_KOPF.ID';
comment on column DIRKSPZM32.ISI_PURCH_POS."LIEFERANT_ID" is '-> ISI_ADRESSEN.AD:RESS_ID ';
comment on column DIRKSPZM32.ISI_PURCH_POS."LIEFERANT_NR" is '-> ISI_ADRESSEN.ADR_NR';
comment on column DIRKSPZM32.ISI_PURCH_POS."LIEFER_MENGE" is 'gelieferte Menge';
comment on column DIRKSPZM32.ISI_PURCH_POS."LIEF_PLAN_ABR_KAL_ID" is 'Unique ID (GUID/UUID) des Lieferplanabruf-Kalendereintrags aus dem diese Auftragsposition generiert wurde';
comment on column DIRKSPZM32.ISI_PURCH_POS."MENGE" is 'Bestell- / Liefermenge';
comment on column DIRKSPZM32.ISI_PURCH_POS."MENGENEINHEIT" is 'Mengeneinheit ';
comment on column DIRKSPZM32.ISI_PURCH_POS."MWST" is 'Mehrwertsteuer';
comment on column DIRKSPZM32.ISI_PURCH_POS."PARENT_POS" is 'Vorgänger Positionsnummer -> dann ist dies eine Unterposition';
comment on column DIRKSPZM32.ISI_PURCH_POS."POS" is 'Positionsnummer ';
comment on column DIRKSPZM32.ISI_PURCH_POS."SID" is 'SID';
comment on column DIRKSPZM32.ISI_PURCH_POS."STATUS" is '''N''=neu angelegt, ''B''=bestellt , ''G''=gelöscht, ''F''=fertig, ''E''=Abschluss durchgeführt ende. ALLE UNBENUTZT! ZUR ZEIT IST STATUS IMMER NULL';
comment on column DIRKSPZM32.ISI_PURCH_POS."STUECKZAHL_PRO_PREIS" is 'Anzahl Stück pro Eink.- bzw. Verk.-Preis';
comment on column DIRKSPZM32.ISI_PURCH_POS."VERK_PREIS" is 'Verkaufspreis';
comment on column DIRKSPZM32.ISI_PURCH_POS."VERK_RABATT_FAKTOR" is 'Verkaufspreis Rabatt-Faktor';
comment on column DIRKSPZM32.ISI_PURCH_POS."VORG_TYP" is '''BE''=Bestellung, ''RE''=Rechnung, ''ANG''=Angebot, ''KALK''=Kalkulation, ''AUFTR''=Auftrag';
comment on column DIRKSPZM32.ISI_PURCH_POS."WAEHRUNG" is 'Währung';
comment on column DIRKSPZM32.ISI_PURCH_POS."WEK_DATUM" is 'WE Kontrolle Datum';
comment on column DIRKSPZM32.ISI_PURCH_POS."WEK_LOGIN_ID" is 'WE Kontrolle durch Person';
comment on column DIRKSPZM32.ISI_PURCH_POS."WEK_OK" is '''T''=OK, ''F''=Wareneingangskontrolle fehlgeschlagen';



-- sqlcl_snapshot {"hash":"34206a02163731181a9faee4685e5cdf3b688e5a","type":"COMMENT","name":"isi_purch_pos","schemaName":"dirkspzm32","sxml":""}