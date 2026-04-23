comment on table dirkspzm32.ems_konten_art is
    'Konto Salden und Informationen zu Leergutartikeln';

comment on column dirkspzm32.ems_konten_art.abschluss_datum is
    'Abschlusszeitpunkt';

comment on column dirkspzm32.ems_konten_art.abschluss_login_id is
    'LoginID des Benutzers, der den Abschluss ausführt';

comment on column dirkspzm32.ems_konten_art.abschluss_saldo is
    'Abschlusssaldo';

comment on column dirkspzm32.ems_konten_art.aend_datum is
    'Datum, an dem dieser Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.ems_konten_art.aend_login_id is
    'LoginID des Benutzers, der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.ems_konten_art.buch_einheit is
    'je nach Kontotyp: STK, HH24, DD, EUR, USD';

comment on column dirkspzm32.ems_konten_art.ems_art_name is
    'Referenz auf Leergutartikel (EMS_ARTIKEL)';

comment on column dirkspzm32.ems_konten_art.ems_konto_nr is
    'Referenz auf Kontonummer (EMS_KONTEN)';

comment on column dirkspzm32.ems_konten_art.erz_datum is
    'Datum, an dem dieser Datensatz angelegt wurde';

comment on column dirkspzm32.ems_konten_art.erz_login_id is
    'LoginID des Benutzers, der diesen Datensatz angelegt hat';

comment on column dirkspzm32.ems_konten_art.id is
    'Unique Identifier (PK)';

comment on column dirkspzm32.ems_konten_art.info is
    'freier Text';

comment on column dirkspzm32.ems_konten_art.letzte_buchung is
    'Zeitpunkt der letzten Buchung';

comment on column dirkspzm32.ems_konten_art.max_saldo is
    'ggf. Maximal Kontostand';

comment on column dirkspzm32.ems_konten_art.min_saldo is
    'ggf. Minimal Kontostand';

comment on column dirkspzm32.ems_konten_art.saldo is
    'Kontostand';


-- sqlcl_snapshot {"hash":"d60b412486dca874c8d3adbf2e40892c4d578812","type":"COMMENT","name":"ems_konten_art","schemaName":"dirkspzm32","sxml":""}