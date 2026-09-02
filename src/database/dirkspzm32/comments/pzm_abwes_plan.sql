comment on column PZM_ABWES_PLAN."AA_FARBE" is 'Darstellungsfarbe für Abwesenheitsart (Wird in den Stempelzeiten im ISIPlus-Client R3 verwendet)';
comment on column PZM_ABWES_PLAN."AA_ID" is 'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';
comment on column PZM_ABWES_PLAN."AA_KURZNAME" is 'Kurzname der Abwesenheitsart';
comment on column PZM_ABWES_PLAN."ABWES_PLAN_TAG" is 'Datum an dem der Mitarbeiter abwesend war/ist (Primary-Key)';
comment on column PZM_ABWES_PLAN."KENNZ_FEIERTAG" is 'T = ist Feiertag, F = ist kein Feiertag';
comment on column PZM_ABWES_PLAN."MONAT" is 'Monat des Abwesenheitstag als Date-Wert (01.Monat_von_ABWES_PLAN_TAG.Jahr_von_ABWES_PLAN_TAG)';
comment on column PZM_ABWES_PLAN."PERS_NR" is 'Personal-ID (Primary-Key)';
comment on column PZM_ABWES_PLAN."QUELLE" is '''ZE'' = Zeiterfassung, ''ABWM'' = Abwesenheitsmeldung, ''UA'' = Urlaubsantrag';
comment on column PZM_ABWES_PLAN."WOCHENTAG_KURZ" is 'Abkürzung für den Wochentag';



-- sqlcl_snapshot {"hash":"ff88c7b3c129c62b50370f477ee6f3370f9a9a9a","type":"COMMENT","name":"pzm_abwes_plan","schemaName":"dirkspzm32","sxml":""}