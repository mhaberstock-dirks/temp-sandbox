comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."AA_ID" is 'Abwesenheitsart-ID (Foreign-Key PZM_ABWESENHEITSARTEN)';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."AEND_DATUM" is 'Änderungsdatum';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."AEND_PERS_NR" is 'Personal-ID Letzte Änderung (Foreign-Key PZM_PERSONAL)';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."ANZ_TAGE" is 'Anzahl der Tage (beginn - ende) + 1 -> 01.01.2000 - 01.01.2000 = 1 Tag';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."BEGINN" is 'Datum Anfang Krankmeldung';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."ENDE" is 'Datum Ende Krankmeldung';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."ERZ_DATUM" is 'Erstelldatum';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."ERZ_PERS_NR" is 'Personal-ID Ersteller (Foreign-Key PZM_PERSONAL)';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."GESAMT_ANZ_TAGE" is 'Gesamtanzahl der Tage incl. Vorerkrankung';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."KM_GRUPPE_ID" is 'Gemeinsame Gruppenkennung für Vorerkrankungen';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."KM_ID" is 'Krankmeldungs-ID (Primary-Key)';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."PERS_NR" is 'Personal-ID (Foreign-Key PZM_PERSONAL)';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."SA_KURZNAME" is 'Kurzname der Schichtart (Foreign-Key PZM_SCHICHTARTEN)';
comment on column DIRKSPZM32.PZM_ABWESENHEITSMELDUNGEN."VORERKRANKUNG" is 'Verweis auf die letzte Krankheitsmeldung (KM_ID)';



-- sqlcl_snapshot {"hash":"96266ca0a91aff37dc1efb0cd195fd9cfdcf226b","type":"COMMENT","name":"pzm_abwesenheitsmeldungen","schemaName":"dirkspzm32","sxml":""}