comment on table dirkspzm32.isi_purch_lief_plan_abruf is
    'Lieferplanabruf zu einem Rahmenvertrags';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.artikel_id is
    'Zu liefernder Artikel';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.geliefert_menge is
    'Bereits gelieferte Menge';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.kunde_zeichen is
    'Textfeld für "Unser Zeichen"';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.lief_plan_abruf_id is
    'Unique ID (GUID/UUID) des Lieferplanabrufs';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.lief_plan_abruf_pos is
    'Positionsnummer des Lieferplanabrufs';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.lief_plan_rv_id is
    'Zuordnung zum Rahmenvertrag';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.material_freig_bis is
    'Materialfreigabe bis';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.menge_pro_preis is
    'Die Verkaufs-Menge für die der Preis gilt. Bei NULL wird der Wert aus dem Artikelstamm geholt';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.plan_menge is
    'Bereits geplante Menge im Lieferkalender';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.prod_freig_bis is
    'Produktionsfreigabe bis';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.transmission_nr is
    'Übermittlungs- bzw. Transmissions-Nr.';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.transmission_zeitpunkt is
    'Übermittlungs- bzw. Transmissionszeitpunkt';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.verk_preis is
    'Aktueller Preis für den Artikel im Rahmen des Lieferplan-Rahmenvertrags. Bei NULL wird der Wert aus dem Artikelstamm geholt';

comment on column dirkspzm32.isi_purch_lief_plan_abruf.ziel_menge is
    'Gesamt-Zielmenge des Lieferplans';


-- sqlcl_snapshot {"hash":"1189525b8a095e9a3a25a3f6bae24e536c7ee59a","type":"COMMENT","name":"isi_purch_lief_plan_abruf","schemaName":"dirkspzm32","sxml":""}