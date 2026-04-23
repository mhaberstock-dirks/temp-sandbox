comment on column dirkspzm32.pzm_abwes_plan.aa_farbe is
    'Darstellungsfarbe für Abwesenheitsart (Wird in den Stempelzeiten im ISIPlus-Client R3 verwendet)';

comment on column dirkspzm32.pzm_abwes_plan.aa_id is
    'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';

comment on column dirkspzm32.pzm_abwes_plan.aa_kurzname is
    'Kurzname der Abwesenheitsart';

comment on column dirkspzm32.pzm_abwes_plan.abwes_plan_tag is
    'Datum an dem der Mitarbeiter abwesend war/ist (Primary-Key)';

comment on column dirkspzm32.pzm_abwes_plan.kennz_feiertag is
    'T = ist Feiertag, F = ist kein Feiertag';

comment on column dirkspzm32.pzm_abwes_plan.monat is
    'Monat des Abwesenheitstag als Date-Wert (01.Monat_von_ABWES_PLAN_TAG.Jahr_von_ABWES_PLAN_TAG)';

comment on column dirkspzm32.pzm_abwes_plan.pers_nr is
    'Personal-ID (Primary-Key)';

comment on column dirkspzm32.pzm_abwes_plan.quelle is
    '''ZE'' = Zeiterfassung, ''ABWM'' = Abwesenheitsmeldung, ''UA'' = Urlaubsantrag';

comment on column dirkspzm32.pzm_abwes_plan.wochentag_kurz is
    'Abkürzung für den Wochentag';


-- sqlcl_snapshot {"hash":"4b7f270b0588a38eed84a9dfcbc2ef7a7f36c572","type":"COMMENT","name":"pzm_abwes_plan","schemaName":"dirkspzm32","sxml":""}