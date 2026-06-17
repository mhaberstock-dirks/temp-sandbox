comment on table DIRKSPZM32.PZM_PERSONAL is 'Grunddaten Personal für die Zeiterfassung';
comment on column DIRKSPZM32.PZM_PERSONAL."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_PERSONAL."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_PERSONAL."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_PERSONAL."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_ABT_ID" is 'Abteilungs-ID (Foreign-Key PZM_ABTEILUNGEN)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_ANREDE" is 'Anrede (Herr/Frau)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_AUSTRITTDATUM" is 'Austrittsdatum des Mitarbeiters';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_BEFRISTET_BIS" is 'Befristungsdatum';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_EINTRITTSDATUM" is 'Eintrittsdatum des Mitarbeiters';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_KAPPUNG_ME_AB_FLX_STD" is 'ME = Monatsende';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_KAPPUNG_SCHICHT_ENDE" is 'Darf das Schichtende (Überstunden) gekappt werden (F  = False, T = True)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_KAPPUNG_TE_AB_FLX_STD" is 'TE = Tagesende';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_KENNZ_ZEITERF" is '1 = Stempeln / 0 = Nicht Stempeln (Steuert zukünftig die Fehlzeiterfassung)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_KST_ID" is 'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_LAND" is 'Land  (Zur Findung Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_MAX_FREISTD" is 'Maximale Anzahl an Freistunden';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_NNAME" is 'Nachname';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_NR" is 'Personal-ID (Primay-Key)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_PB_ID" is 'Produktionsbereich-ID (Foreign-Key PZM_PRODUKTIONSBEREICHE)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_PERSONALTEILBER" is 'Personnalteilbereich (Werk, Tätigkeit bei INFOR etc.)
';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_REGION_CODE" is 'Name Bundesland o.ä.  (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_SCHNITTSTELLE" is '1 = Die Daten müssen in die Schnittstelle / 0 = Nicht übertragen';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_SM_BEGINN" is 'Schichtmodell Startdatum';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_SM_BEGINN_WOCHE" is 'Mit dieser Woche beginnt das Schichtmodell (Schichtrhythmus)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_SM_NAME" is 'Schichtmodellname';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_STARTDATUM" is 'Startdatum, Erstes Eintrittsdatum des Mitarbeiters';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_TAETIGKEIT" is 'Beschreibung der Tätigkeit';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_URLAUB_ANSPR_AA_ID" is 'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_URLAUB_ANSPR_WERT" is 'Anzahl Urlaubstage';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_USTD_FREISTD" is 'KF = KONTO_FREIZEIT, AZ = Auszahlung der Überstunden';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_VERFALL_VORJAHR" is 'Verfallsdatum Resturlaub aus Vorjahr';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_VERTRAGSART" is 'Vertragsart-ID (Foreign-Key PZM_VERTRAGSARTEN)';
comment on column DIRKSPZM32.PZM_PERSONAL."PERS_VNAME" is 'Vorname';
comment on column DIRKSPZM32.PZM_PERSONAL."TARIF_NAME" is 'Zugeordneter Tarif';



-- sqlcl_snapshot {"hash":"33886872dc806c927c41ec36a37be2fa0f2df8f3","type":"COMMENT","name":"pzm_personal","schemaName":"dirkspzm32","sxml":""}