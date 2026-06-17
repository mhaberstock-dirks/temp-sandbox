comment on table DIRKSPZM32.PZM_ABWES_LISTE is 'Liste der Abwesenheiten in Tagen (Zusammengefasst)';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."AA_FARBE" is 'Darstellungsfarbe für Abwesenheitsart (Wird in den Stempelzeiten im ISIPlus-Client R3 verwendet)';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."AA_ID" is 'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."AA_KURZNAME" is 'Kurzname der Abwesenheitsart';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."ABWES_LISTE_VON" is 'Datum an dem der Mitarbeiter abwesend war/ist (Primary-Key)';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."CREATED_USER" is 'User - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."KENNZ_FEIERTAG" is 'T = ist Feiertag, F = ist kein Feiertag';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."LAST_CHANGE_USER" is 'User - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."MONAT" is 'Monat des Abwesenheitstag als Date-Wert (01.Monat_von_ABWES_PLAN_TAG.Jahr_von_ABWES_PLAN_TAG)';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."PERS_NR" is 'Personal-ID (Primary-Key)';
comment on column DIRKSPZM32.PZM_ABWES_LISTE."QUELLE" is '''ZE'' = Zeiterfassung, ''ABWM'' = Abwesenheitsmeldung, ''UA'' = Urlaubsantrag';



-- sqlcl_snapshot {"hash":"7f2a4b0040cb323397c2008a1a8ca85466efeeed","type":"COMMENT","name":"pzm_abwes_liste","schemaName":"dirkspzm32","sxml":""}