comment on table Z_PZM_PERSONAL_IMPORT is 'Grunddaten Personal für die Zeiterfassung';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_ABT_ID" is 'Abteilungs-ID (Foreign-Key PZM_ABTEILUNGEN)';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_ANREDE" is 'Anrede (Herr/Frau)';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_AUSTRITTDATUM" is 'Austrittsdatum des Mitarbeiters';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_BEFRISTET_BIS" is 'Befristungsdatum';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_EINTRITTSDATUM" is 'Eintrittsdatum des Mitarbeiters';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_KST_ID" is 'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_LAND" is 'Land  (Zur Findung Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_MAX_FREISTD" is 'Maximale Anzahl an Freistunden';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_NNAME" is 'Nachname';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_NR" is 'Personal-ID (Primay-Key)';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_PB_ID" is 'Produktionsbereich-ID (Foreign-Key PZM_PRODUKTIONSBEREICHE)';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_REGION_CODE" is 'Name Bundesland o.ä.  (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_SM_BEGINN" is 'Schichtmodell Startdatum';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_SM_NAME" is 'Schichtmodellname';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_TAETIGKEIT" is 'Beschreibung der Tätigkeit';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_USTD_FREISTD" is 'KF = KONTO_FREIZEIT, AZ = Auszahlung der Überstunden';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_VERTRAGSART" is 'Vertragsart-ID (Foreign-Key PZM_VERTRAGSARTEN)';
comment on column Z_PZM_PERSONAL_IMPORT."PERS_VNAME" is 'Vorname';



-- sqlcl_snapshot {"hash":"a551966dde522f4eb7392d50461af00b06a7b5c6","type":"COMMENT","name":"z_pzm_personal_import","schemaName":"dirkspzm32","sxml":""}