comment on column dirkspzm32.pzm_abwesenheitsmeldungen.aa_id is
    'Abwesenheitsart-ID (Foreign-Key PZM_ABWESENHEITSARTEN)';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.aend_datum is
    'Änderungsdatum';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.aend_pers_nr is
    'Personal-ID Letzte Änderung (Foreign-Key PZM_PERSONAL)';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.anz_tage is
    'Anzahl der Tage (beginn - ende) + 1 -> 01.01.2000 - 01.01.2000 = 1 Tag';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.beginn is
    'Datum Anfang Krankmeldung';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.ende is
    'Datum Ende Krankmeldung';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.erz_datum is
    'Erstelldatum';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.erz_pers_nr is
    'Personal-ID Ersteller (Foreign-Key PZM_PERSONAL)';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.gesamt_anz_tage is
    'Gesamtanzahl der Tage incl. Vorerkrankung';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.km_gruppe_id is
    'Gemeinsame Gruppenkennung für Vorerkrankungen';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.km_id is
    'Krankmeldungs-ID (Primary-Key)';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.pers_nr is
    'Personal-ID (Foreign-Key PZM_PERSONAL)';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.sa_kurzname is
    'Kurzname der Schichtart (Foreign-Key PZM_SCHICHTARTEN)';

comment on column dirkspzm32.pzm_abwesenheitsmeldungen.vorerkrankung is
    'Verweis auf die letzte Krankheitsmeldung (KM_ID)';


-- sqlcl_snapshot {"hash":"1d44b91f0330a1526f8d2dd2d9209fc111c0e0d4","type":"COMMENT","name":"pzm_abwesenheitsmeldungen","schemaName":"dirkspzm32","sxml":""}