comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_ADRESS_ID" is 'Adress-ID der Abteilung (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_ID" is 'Abteilung-ID (Primary Key)';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_INFO" is 'Beschreibung zur Abteilung';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_KST_ID" is 'Kostenstelle der Abteilung (Foreign-Key PZM_LZ_KST)';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_KURZ_NAME" is 'Kurzname der Abteilung';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_NAME" is 'Name der Abteilung';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_PARENT_ABT_ID" is 'Übergeordnete Abteilung';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_PB_ID" is 'Produktionsbereich (Foreign-Key PZM_PRODUKTIONSBEREICHE)';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_PERSONAL_ABT_ID" is 'Zugehörige Personalabteilung';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_PZM_BDE_TYP_CONTINUE" is 'F = Normal mit täglicher Anmeldung des Fertigungs- Serviceauftrags, T = Der angemeldete Auftrag läuft am Folgetag weiter';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_STANDARD_SM_NAME" is 'Standard-Schichtmodellname';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."ABT_TYP" is 'Typ der Organisationseinheit (Abteilung, Team, etc.) - Combobox mit festen Werte - Enum';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_ABTEILUNGEN."TARIF_NAME" is 'Zugeordneter Tarif';



-- sqlcl_snapshot {"hash":"77b62daa71a50c785046975b9d740a596f46da91","type":"COMMENT","name":"pzm_abteilungen","schemaName":"dirkspzm32","sxml":""}