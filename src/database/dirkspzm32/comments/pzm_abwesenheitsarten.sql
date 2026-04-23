comment on column dirkspzm32.pzm_abwesenheitsarten.aa_beantragbar is
    'T = beantragbare Abwesenheit (z.B. beim Urlaubsantrag), F = nicht beantragbar';

comment on column dirkspzm32.pzm_abwesenheitsarten.aa_einflussfaktor is
    'Einflussfaktor in Prozent für die Berechnung Urlaubstagen. z.B.: halber Urlaubstag 50%  auf die Tagesarbeitszeit';

comment on column dirkspzm32.pzm_abwesenheitsarten.aa_einheit is
    'DD = Tag, HH24 = Stunden';

comment on column dirkspzm32.pzm_abwesenheitsarten.aa_farbe is
    'Darstellungsfarbe für Abwesenheitsart (Wird in den Stempelzeiten im ISIPlus-Client R3 verwendet)';

comment on column dirkspzm32.pzm_abwesenheitsarten.aa_id is
    'Abwesenheitsart-ID (Primary-Key)';

comment on column dirkspzm32.pzm_abwesenheitsarten.aa_kurzname is
    'Kurzname der Abwesenheitsart';

comment on column dirkspzm32.pzm_abwesenheitsarten.aa_name is
    'Name der Abwesenheitsart';

comment on column dirkspzm32.pzm_abwesenheitsarten.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_abwesenheitsarten.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_abwesenheitsarten.kennz_urlaub is
    'Kennzeichen, ob diese Abwesenheit eine Urlaubsabwesenheit ist';

comment on column dirkspzm32.pzm_abwesenheitsarten.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_abwesenheitsarten.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_abwesenheitsarten.lz_id is
    'Lohnzulage der Abwesenheitsart (Foreign-Key PZM_LOHNZULAGEN)';


-- sqlcl_snapshot {"hash":"3793aaac1542072decbcdab78fcda8162810c7fc","type":"COMMENT","name":"pzm_abwesenheitsarten","schemaName":"dirkspzm32","sxml":""}