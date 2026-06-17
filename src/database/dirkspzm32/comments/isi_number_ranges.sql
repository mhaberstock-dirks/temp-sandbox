comment on table DIRKSPZM32.ISI_NUMBER_RANGES is 'Nummernkreise für Rechnungen, Lieferscheine, Gutschriften, Vorkasse etc.';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."CREATED_BY_LOGIN_ID" is 'Login ID des Benutzers der den Nummernkreis erstellt hat';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."CREATED_DATE" is 'Datum der Erstellung';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."LAST_MODIFIED_BY_LOGIN_ID" is 'Login ID des Benutzers der die letzte Änderung durchgeführt hat';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."LAST_MODIFIED_DATE" is 'Datum der letzen Änderung';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."LAST_NUMBER" is 'Letzte verwendete Nummer aus dem Nummernkreis';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."NUM_RANGE_ID" is 'Unique ID (GUID/UUID) des Nummernkreises';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."NUM_RANGE_NAME" is 'Individuelle Bezeichnung des Nummernkreises';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."NUM_RANGE_TYPE" is 'Typ des Nummernkreises (ARTNR=Artikelnummer, RECH=Rechnung, PROFR=pro-forma Rechnung, GUTS=Gutschrift, LIEF=Lieferschein, ANG=Angebot, PROJ=Projekt)';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."PREFIX" is 'Optionaler Präfix bei Verwendung der nächsten Nummer aus dem Nummernkreis';
comment on column DIRKSPZM32.ISI_NUMBER_RANGES."SUFFIX" is 'Optionaler Suffix bei Verwendung der nächsten Nummer aus dem Nummernkreis';



-- sqlcl_snapshot {"hash":"ca39d9a2049c2679b497a9d3427e8aa6247c4ee5","type":"COMMENT","name":"isi_number_ranges","schemaName":"dirkspzm32","sxml":""}