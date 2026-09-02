comment on column PZM_ABWESENHEITSARTEN."AA_BEANTRAGBAR" is 'T = beantragbare Abwesenheit (z.B. beim Urlaubsantrag), F = nicht beantragbar';
comment on column PZM_ABWESENHEITSARTEN."AA_EINFLUSSFAKTOR" is 'Einflussfaktor in Prozent für die Berechnung Urlaubstagen. z.B.: halber Urlaubstag 50%  auf die Tagesarbeitszeit';
comment on column PZM_ABWESENHEITSARTEN."AA_EINHEIT" is 'DD = Tag, HH24 = Stunden';
comment on column PZM_ABWESENHEITSARTEN."AA_FARBE" is 'Darstellungsfarbe für Abwesenheitsart (Wird in den Stempelzeiten im ISIPlus-Client R3 verwendet)';
comment on column PZM_ABWESENHEITSARTEN."AA_ID" is 'Abwesenheitsart-ID (Primary-Key)';
comment on column PZM_ABWESENHEITSARTEN."AA_KURZNAME" is 'Kurzname der Abwesenheitsart';
comment on column PZM_ABWESENHEITSARTEN."AA_NAME" is 'Name der Abwesenheitsart';
comment on column PZM_ABWESENHEITSARTEN."CREATED_DATE" is 'Datum Erstellt';
comment on column PZM_ABWESENHEITSARTEN."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column PZM_ABWESENHEITSARTEN."KENNZ_URLAUB" is 'Kennzeichen, ob diese Abwesenheit eine Urlaubsabwesenheit ist';
comment on column PZM_ABWESENHEITSARTEN."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column PZM_ABWESENHEITSARTEN."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column PZM_ABWESENHEITSARTEN."LZ_ID" is 'Lohnzulage der Abwesenheitsart (Foreign-Key PZM_LOHNZULAGEN)';



-- sqlcl_snapshot {"hash":"f3bb5b6ca0357bbba8e3d5826a0e9bbbf30ef278","type":"COMMENT","name":"pzm_abwesenheitsarten","schemaName":"dirkspzm32","sxml":""}