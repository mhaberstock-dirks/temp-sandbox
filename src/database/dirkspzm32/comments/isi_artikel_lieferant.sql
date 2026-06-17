comment on table DIRKSPZM32.ISI_ARTIKEL_LIEFERANT is 'Lieferantenspezifische Parameter für Rohstoffe und Zukaufartikel';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."ARTIKEL_ID" is 'Schlüssel aus ISI_ARTIKEL';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."ART_EAN_LIEFERANT" is 'Artikel-EAN des Lieferanten';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."ART_NR_HERSTELLER" is 'Artikelnummer des Herstellers (wenn Artikel über eine Distribution bezogen werden)';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."ART_NR_LIEFERANT" is 'Artikelnummer des Liefranten (die Bestellnummer in einem Katalog)';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."ART_TEXT1" is 'Lieferantenspezifische Bezeichnung 1';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."ART_TEXT2" is 'Lieferantenspezifische Bezeichnung 2';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."ART_TEXT3" is 'Lieferantenspezifische Bezeichnung 3';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."EINK_PREIS" is 'Einkauf_Preis ohne Mwst. berechnet LISTEN_PREIS * EINK_RABAT_FAKTOR';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."EINK_RABATT_FAKTOR" is 'Einkauf_Rabatt_Faktor';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."INFO" is 'Weitere (z.B. interne) Informationen zu diesem Artkel bezogen auf diesen Lieferanten';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."LHM_EAN" is 'EAN des LHM';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."LISTEN_PREIS" is 'Listen_preis ohne Mwst.';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."LTE_EAN" is 'EAN der gesamten TE';
comment on column DIRKSPZM32.ISI_ARTIKEL_LIEFERANT."STAND_LIEF" is 'Standard Lieferant (T) = True   F = False';



-- sqlcl_snapshot {"hash":"1c9871857e7cd15220aee7be70380141f9744587","type":"COMMENT","name":"isi_artikel_lieferant","schemaName":"dirkspzm32","sxml":""}