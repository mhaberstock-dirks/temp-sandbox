comment on table dirkspzm32.pzm_abt_leitung is
    'Relation Abteilung zur PERS_NR der Leitung und deren Funktion';

comment on column dirkspzm32.pzm_abt_leitung.abt_l_abt_id is
    'Abteilung-ID (Primary Key)';

comment on column dirkspzm32.pzm_abt_leitung.abt_l_bis_datum is
    'Leiter/Vertreter Funktion bis zu diesem Datum ';

comment on column dirkspzm32.pzm_abt_leitung.abt_l_funktion is
    'Funktion: G = Geschäftsleitung/Geschäftsführer, L = Leiter, V = Vertreter';

comment on column dirkspzm32.pzm_abt_leitung.abt_l_pers_nr is
    'Personal-ID des Abteilungsleiter (Primary Key) (Foreign-Key PZM_PERSONAL)';

comment on column dirkspzm32.pzm_abt_leitung.abt_l_von_datum is
    'Leiter/Vertreter Funktion ab diesen Datum ';

comment on column dirkspzm32.pzm_abt_leitung.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_abt_leitung.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_abt_leitung.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_abt_leitung.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';


-- sqlcl_snapshot {"hash":"03040062b72d5c32af2018532e4ca7892adb9725","type":"COMMENT","name":"pzm_abt_leitung","schemaName":"dirkspzm32","sxml":""}