comment on table dirkspzm32.pzm_pers_lohn_zulagen is
    'Personal Zeiterfassung Zulagen oder Zuschläge - Lohnarten';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.created_user is
    'User - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.gueltig_datum_bis is
    'Lohnart Gültig bis diesem Datum  (NULL = Immer)';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.gueltig_datum_von is
    'Lohnart Gültig ab diesem Datum (NULL = Immer)';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.last_change_user is
    'User - er hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.lz_id is
    'ID Der Lohnart. Diese ID ist die referenz in der Lohnbuchhaltung ';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.pers_lz_seq is
    'Sequenz als PK (Primay-Key)';

comment on column dirkspzm32.pzm_pers_lohn_zulagen.pers_nr is
    'Personal-ID ';


-- sqlcl_snapshot {"hash":"347abd4ed8b478423b69198619a196d9af186007","type":"COMMENT","name":"pzm_pers_lohn_zulagen","schemaName":"dirkspzm32","sxml":""}