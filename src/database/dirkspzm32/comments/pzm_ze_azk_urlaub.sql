comment on table dirkspzm32.pzm_ze_azk_urlaub is
    'PZM AZK Urlaub Monat Abschluss';

comment on column dirkspzm32.pzm_ze_azk_urlaub.arbeitskonto_saldo_stunden is
    'Arbeitskonto Saldo [Stunden] - zum Datum';

comment on column dirkspzm32.pzm_ze_azk_urlaub.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_ze_azk_urlaub.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_azk_urlaub.created_user is
    'User - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_azk_urlaub.cycle is
    'Anzahl der Versuche der Übertragung  (Versuchszähler)';

comment on column dirkspzm32.pzm_ze_azk_urlaub.datum is
    'Abschlussdatum (Primay-Key)';

comment on column dirkspzm32.pzm_ze_azk_urlaub.err_text is
    'Returncode aus Übertragung';

comment on column dirkspzm32.pzm_ze_azk_urlaub.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_ze_azk_urlaub.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_azk_urlaub.last_change_user is
    'User - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_azk_urlaub.nname is
    'Nachname';

comment on column dirkspzm32.pzm_ze_azk_urlaub.pb_id is
    'Produktionsbereich-ID (Foreign-Key PZM_PRODUKTIONSBEREICHE)';

comment on column dirkspzm32.pzm_ze_azk_urlaub.pers_kst_id is
    'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';

comment on column dirkspzm32.pzm_ze_azk_urlaub.pers_nr is
    'Personal-ID (Primay-Key)';

comment on column dirkspzm32.pzm_ze_azk_urlaub.resturlaub_stunden is
    'Resturlaub [Stunden] - zum Datum';

comment on column dirkspzm32.pzm_ze_azk_urlaub.ret_code is
    'Returncode aus Übertragung';

comment on column dirkspzm32.pzm_ze_azk_urlaub.status is
    'N = Neu, im HOST noch nicht Übernommen U = Ist in übertragung, UE = HOST hat den Satz übernommen, ERR = Fehler, D = Delete -> ISIPlus kann den Eintrag Löschen'
    ;

comment on column dirkspzm32.pzm_ze_azk_urlaub.urlaubsanspruch_stunden_jahr is
    'Urlaubsanspruch [Stunden] - Jahr';

comment on column dirkspzm32.pzm_ze_azk_urlaub.urlaubsanspruch_tage_jahr is
    'Urlaubsanspruch [Tage] - Jahr';

comment on column dirkspzm32.pzm_ze_azk_urlaub.vname is
    'Vorname';


-- sqlcl_snapshot {"hash":"311ac542ac62f91c722f8c6bb18211e55541f10c","type":"COMMENT","name":"pzm_ze_azk_urlaub","schemaName":"dirkspzm32","sxml":""}