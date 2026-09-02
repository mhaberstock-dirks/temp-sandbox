comment on table EMS_KONTEN_ART is 'Konto Salden und Informationen zu Leergutartikeln';
comment on column EMS_KONTEN_ART."ABSCHLUSS_DATUM" is 'Abschlusszeitpunkt';
comment on column EMS_KONTEN_ART."ABSCHLUSS_LOGIN_ID" is 'LoginID des Benutzers, der den Abschluss ausführt';
comment on column EMS_KONTEN_ART."ABSCHLUSS_SALDO" is 'Abschlusssaldo';
comment on column EMS_KONTEN_ART."AEND_DATUM" is 'Datum, an dem dieser Datensatz zuletzt geändert wurde';
comment on column EMS_KONTEN_ART."AEND_LOGIN_ID" is 'LoginID des Benutzers, der diesen Datensatz zuletzt geändert hat';
comment on column EMS_KONTEN_ART."BUCH_EINHEIT" is 'je nach Kontotyp: STK, HH24, DD, EUR, USD';
comment on column EMS_KONTEN_ART."EMS_ART_NAME" is 'Referenz auf Leergutartikel (EMS_ARTIKEL)';
comment on column EMS_KONTEN_ART."EMS_KONTO_NR" is 'Referenz auf Kontonummer (EMS_KONTEN)';
comment on column EMS_KONTEN_ART."ERZ_DATUM" is 'Datum, an dem dieser Datensatz angelegt wurde';
comment on column EMS_KONTEN_ART."ERZ_LOGIN_ID" is 'LoginID des Benutzers, der diesen Datensatz angelegt hat';
comment on column EMS_KONTEN_ART."ID" is 'Unique Identifier (PK)';
comment on column EMS_KONTEN_ART."INFO" is 'freier Text';
comment on column EMS_KONTEN_ART."LETZTE_BUCHUNG" is 'Zeitpunkt der letzten Buchung';
comment on column EMS_KONTEN_ART."MAX_SALDO" is 'ggf. Maximal Kontostand';
comment on column EMS_KONTEN_ART."MIN_SALDO" is 'ggf. Minimal Kontostand';
comment on column EMS_KONTEN_ART."SALDO" is 'Kontostand';



-- sqlcl_snapshot {"hash":"7e09b93bdb4a1230801fc5f53d05fb3efe94c513","type":"COMMENT","name":"ems_konten_art","schemaName":"dirkspzm32","sxml":""}