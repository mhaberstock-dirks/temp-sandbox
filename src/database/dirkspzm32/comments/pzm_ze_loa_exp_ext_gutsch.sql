comment on table dirkspzm32.pzm_ze_loa_exp_ext_gutsch is
    'Stunden/Lohnarten zur Abrechnung - Gutschriften Personaldienstleister';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.created_user is
    'User - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.datum is
    'Datum
für die Abrechnung';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.err_text is
    'Returncode aus Übertragung';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.konten_bh_id_korr is
    'Buchungs-ID der Korrektur';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.konto_nr_korr is
    'Konto für Korrekturen z.B. Flex bei Kappung';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.konto_val_korr is
    'Konto ist um diesen Wert in der monatsaberechnung korrigiert';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.last_change_user is
    'User - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.loa_value is
    'Stunden
/ Tage - LOA-Wert';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.lohnart is
    'Lohnart
';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.pb_id is
    'Mandant z.B. 01
';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.pers_nr is
    'zeaw = ZE Auswertung';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.ret_code is
    'Returncode aus Übertragung';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.status is
    'N = Neu, im HOST noch nicht Übernommen U = Ist in übertragung, UE = HOST hat den Satz übernommen, ERR = Fehler, D = Delete -> ISIPlus kann den Eintrag Löschen'
    ;

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.ts_ende_zeit is
    'Endezeit Tagessatz';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.ts_pause_zeit is
    'Pausenzeit in Stunden';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.ts_start_zeit is
    'Startzeit Tagessatz';

comment on column dirkspzm32.pzm_ze_loa_exp_ext_gutsch.ze_stempelzeiten is
    'Alle Stempelzeiten aus der Zeiterfassung';


-- sqlcl_snapshot {"hash":"a07b0602a90bda5c53e839c63fd225e6aff8de23","type":"COMMENT","name":"pzm_ze_loa_exp_ext_gutsch","schemaName":"dirkspzm32","sxml":""}