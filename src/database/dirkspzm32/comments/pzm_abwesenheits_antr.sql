comment on column dirkspzm32.pzm_abwesenheits_antr.au_abwes_art is
    'Abwesenheitsart-ID (Foreign-Key PZM_ABWESENHEITSARTEN)';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_arbeitstage is
    'Anzahl Arbeitstage';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_beginn is
    'Urlaubsbeginn (Primary-Key)';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_bemerkung is
    'Bemerkung zum Urlaubsantrag';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_datum is
    'Antragsdatum (Primary-Key)';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_email is
    'Email Benachrichtigung';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_ende is
    'Urlaubsende';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_pers_nr is
    'Personal-ID des Antragstellers (Primary-Key & Foreign-Key PZM_PERSONAL)';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_pruef_pers_nr is
    'PersNr des prüfenden Personals (Foreign-Key PZM_PERSONAL)';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_schicht_start is
    'Urlaubsbeginn zur Schicht bzw. Arbeitszeit an einem Tag. NULL = ganzer Tag, 1 = Schichtanfang, 2 = Schichtende';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_status is
    '0 = beantragt, 1 = genehmigt, 2 = abgelehnt, 3 = storniert (Foreign-Key PZM_PRUEF_STATUS_INFO.PSI_ID)';

comment on column dirkspzm32.pzm_abwesenheits_antr.au_utage is
    'Anzahl Urlaubstage';

comment on column dirkspzm32.pzm_abwesenheits_antr.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_abwesenheits_antr.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_abwesenheits_antr.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_abwesenheits_antr.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';


-- sqlcl_snapshot {"hash":"f7d3580e21c9dc687165cf1eda98f8ae384b16cf","type":"COMMENT","name":"pzm_abwesenheits_antr","schemaName":"dirkspzm32","sxml":""}