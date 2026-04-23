comment on table dirkspzm32.pzm_abwes_liste is
    'Liste der Abwesenheiten in Tagen (Zusammengefasst)';

comment on column dirkspzm32.pzm_abwes_liste.aa_farbe is
    'Darstellungsfarbe für Abwesenheitsart (Wird in den Stempelzeiten im ISIPlus-Client R3 verwendet)';

comment on column dirkspzm32.pzm_abwes_liste.aa_id is
    'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';

comment on column dirkspzm32.pzm_abwes_liste.aa_kurzname is
    'Kurzname der Abwesenheitsart';

comment on column dirkspzm32.pzm_abwes_liste.abwes_liste_von is
    'Datum an dem der Mitarbeiter abwesend war/ist (Primary-Key)';

comment on column dirkspzm32.pzm_abwes_liste.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_abwes_liste.created_user is
    'User - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_abwes_liste.kennz_feiertag is
    'T = ist Feiertag, F = ist kein Feiertag';

comment on column dirkspzm32.pzm_abwes_liste.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_abwes_liste.last_change_user is
    'User - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_abwes_liste.monat is
    'Monat des Abwesenheitstag als Date-Wert (01.Monat_von_ABWES_PLAN_TAG.Jahr_von_ABWES_PLAN_TAG)';

comment on column dirkspzm32.pzm_abwes_liste.pers_nr is
    'Personal-ID (Primary-Key)';

comment on column dirkspzm32.pzm_abwes_liste.quelle is
    '''ZE'' = Zeiterfassung, ''ABWM'' = Abwesenheitsmeldung, ''UA'' = Urlaubsantrag';


-- sqlcl_snapshot {"hash":"08d442b5d8d754168789fcf4fddc7d7e9161f85b","type":"COMMENT","name":"pzm_abwes_liste","schemaName":"dirkspzm32","sxml":""}