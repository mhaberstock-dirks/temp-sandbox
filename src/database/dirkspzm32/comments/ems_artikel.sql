comment on table dirkspzm32.ems_artikel is
    'Leergutartikel';

comment on column dirkspzm32.ems_artikel.aend_datum is
    'Datum, an dem dieser Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.ems_artikel.aend_login_id is
    'LoginID des Benutzers, der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.ems_artikel.aktiv is
    'Kennzeichen, ob der Leergutartikel bei aktiven Buchungen genutzt werden kann';

comment on column dirkspzm32.ems_artikel.artikel_id is
    'ggf. Referenz auf einen Artikel im Artikelstamm';

comment on column dirkspzm32.ems_artikel.beschreibung is
    'freier Text zur Beschreibung der Leergutartikels';

comment on column dirkspzm32.ems_artikel.ems_art_gruppe_id is
    'Referenz auf die Leergutartikelgruppe';

comment on column dirkspzm32.ems_artikel.ems_art_name is
    'Name des Leergutartikels';

comment on column dirkspzm32.ems_artikel.ems_art_text is
    'lange Namensform für den Leergutartikel (Caption)';

comment on column dirkspzm32.ems_artikel.erz_datum is
    'Datum, an dem dieser Datensatz angelegt wurde';

comment on column dirkspzm32.ems_artikel.erz_login_id is
    'LoginID des Benutzers, der diesen Datensatz angelegt hat';

comment on column dirkspzm32.ems_artikel.foto_datei_k is
    'Dateiname eines kleinen Fotos vom Leergutartikel';

comment on column dirkspzm32.ems_artikel.foto_datei_n is
    'Dateiname eines normalen Fotos vom Leergutartikel';

comment on column dirkspzm32.ems_artikel.gewicht_kg is
    'Gewicht des Leergutartikels in kg';

comment on column dirkspzm32.ems_artikel.lhm_name is
    'ggf. Referenz auf den LHM_NAME im LVS';

comment on column dirkspzm32.ems_artikel.lte_name is
    'ggf. Referenz auf den LTE_NAME im LVS';

comment on column dirkspzm32.ems_artikel.mengen_einheit is
    'Mengeneinheit: STK = Stück, ...';


-- sqlcl_snapshot {"hash":"ede160b30d98e35170d6cf83342742dc2b7224ca","type":"COMMENT","name":"ems_artikel","schemaName":"dirkspzm32","sxml":""}