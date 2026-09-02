comment on table PZM_PERSONAL_HIST is 'Grunddaten Personal für die Zeiterfassung';
comment on column PZM_PERSONAL_HIST."CREATED_DATE" is 'Datum Erstellt';
comment on column PZM_PERSONAL_HIST."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column PZM_PERSONAL_HIST."OLD_ABT_ID" is 'Abteilungs-ID (Foreign-Key PZM_ABTEILUNGEN)';
comment on column PZM_PERSONAL_HIST."OLD_AUSTRITTDATUM" is 'Austrittsdatum des Mitarbeiters';
comment on column PZM_PERSONAL_HIST."OLD_BEFRISTET_BIS" is 'Befristungsdatum';
comment on column PZM_PERSONAL_HIST."OLD_EINTRITTSDATUM" is 'Eintrittsdatum des Mitarbeiters';
comment on column PZM_PERSONAL_HIST."OLD_KST_ID" is 'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';
comment on column PZM_PERSONAL_HIST."OLD_LAND" is 'Land  (Zur Findung Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column PZM_PERSONAL_HIST."OLD_PB_ID" is 'Produktionsbereich-ID (Foreign-Key PZM_PRODUKTIONSBEREICHE)';
comment on column PZM_PERSONAL_HIST."OLD_REGION_CODE" is 'Name Bundesland o.ä.  (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column PZM_PERSONAL_HIST."OLD_SM_NAME" is 'Schichtmodellname';
comment on column PZM_PERSONAL_HIST."OLD_STARTDATUM" is 'Startdatum, Erstes Eintrittsdatum des Mitarbeiters';
comment on column PZM_PERSONAL_HIST."OLD_TARIF_NAME" is 'Zugeordneter Tarif';
comment on column PZM_PERSONAL_HIST."OLD_URLAUB_ANSPR_AA_ID" is 'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';
comment on column PZM_PERSONAL_HIST."OLD_URLAUB_ANSPR_WERT" is 'Anzahl Urlaubstage';
comment on column PZM_PERSONAL_HIST."PERS_ABT_ID" is 'Abteilungs-ID (Foreign-Key PZM_ABTEILUNGEN)';
comment on column PZM_PERSONAL_HIST."PERS_AUSTRITTDATUM" is 'Austrittsdatum des Mitarbeiters';
comment on column PZM_PERSONAL_HIST."PERS_BEFRISTET_BIS" is 'Befristungsdatum';
comment on column PZM_PERSONAL_HIST."PERS_EINTRITTSDATUM" is 'Eintrittsdatum des Mitarbeiters';
comment on column PZM_PERSONAL_HIST."PERS_KST_ID" is 'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';
comment on column PZM_PERSONAL_HIST."PERS_LAND" is 'Land  (Zur Findung Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column PZM_PERSONAL_HIST."PERS_NR" is 'Personal-ID (Primay-Key)';
comment on column PZM_PERSONAL_HIST."PERS_PB_ID" is 'Produktionsbereich-ID (Foreign-Key PZM_PRODUKTIONSBEREICHE)';
comment on column PZM_PERSONAL_HIST."PERS_REGION_CODE" is 'Name Bundesland o.ä.  (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column PZM_PERSONAL_HIST."PERS_SM_NAME" is 'Schichtmodellname';
comment on column PZM_PERSONAL_HIST."PERS_STARTDATUM" is 'Startdatum, Erstes Eintrittsdatum des Mitarbeiters';
comment on column PZM_PERSONAL_HIST."PERS_URLAUB_ANSPR_AA_ID" is 'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';
comment on column PZM_PERSONAL_HIST."PERS_URLAUB_ANSPR_WERT" is 'Anzahl Urlaubstage';
comment on column PZM_PERSONAL_HIST."TARIF_NAME" is 'Zugeordneter Tarif';



-- sqlcl_snapshot {"hash":"9c78d319ac5d4db8b613694d2170c27b16193308","type":"COMMENT","name":"pzm_personal_hist","schemaName":"dirkspzm32","sxml":""}