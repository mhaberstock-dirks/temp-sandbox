comment on table dirkspzm32.isi_artikel_lieferant is
    'Lieferantenspezifische Parameter für Rohstoffe und Zukaufartikel';

comment on column dirkspzm32.isi_artikel_lieferant.artikel_id is
    'Schlüssel aus ISI_ARTIKEL';

comment on column dirkspzm32.isi_artikel_lieferant.art_ean_lieferant is
    'Artikel-EAN des Lieferanten';

comment on column dirkspzm32.isi_artikel_lieferant.art_nr_hersteller is
    'Artikelnummer des Herstellers (wenn Artikel über eine Distribution bezogen werden)';

comment on column dirkspzm32.isi_artikel_lieferant.art_nr_lieferant is
    'Artikelnummer des Liefranten (die Bestellnummer in einem Katalog)';

comment on column dirkspzm32.isi_artikel_lieferant.art_text1 is
    'Lieferantenspezifische Bezeichnung 1';

comment on column dirkspzm32.isi_artikel_lieferant.art_text2 is
    'Lieferantenspezifische Bezeichnung 2';

comment on column dirkspzm32.isi_artikel_lieferant.art_text3 is
    'Lieferantenspezifische Bezeichnung 3';

comment on column dirkspzm32.isi_artikel_lieferant.eink_preis is
    'Einkauf_Preis ohne Mwst. berechnet LISTEN_PREIS * EINK_RABAT_FAKTOR';

comment on column dirkspzm32.isi_artikel_lieferant.eink_rabatt_faktor is
    'Einkauf_Rabatt_Faktor';

comment on column dirkspzm32.isi_artikel_lieferant.info is
    'Weitere (z.B. interne) Informationen zu diesem Artkel bezogen auf diesen Lieferanten';

comment on column dirkspzm32.isi_artikel_lieferant.lhm_ean is
    'EAN des LHM';

comment on column dirkspzm32.isi_artikel_lieferant.listen_preis is
    'Listen_preis ohne Mwst.';

comment on column dirkspzm32.isi_artikel_lieferant.lte_ean is
    'EAN der gesamten TE';

comment on column dirkspzm32.isi_artikel_lieferant.stand_lief is
    'Standard Lieferant (T) = True   F = False';


-- sqlcl_snapshot {"hash":"e08b3f8121bf127fbadd5a671f6822f5bfecb137","type":"COMMENT","name":"isi_artikel_lieferant","schemaName":"dirkspzm32","sxml":""}