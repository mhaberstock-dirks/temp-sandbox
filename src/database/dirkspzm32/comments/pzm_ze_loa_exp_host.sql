comment on table dirkspzm32.pzm_ze_loa_exp_host is
    'Stunden/Lohnarten zur Abrechnung - Übertragung zum Host';

comment on column dirkspzm32.pzm_ze_loa_exp_host.aa_id is
    'Mit welcher Abwesenheitsart wurde diese LOA gebucht für SAP nicht relevant';

comment on column dirkspzm32.pzm_ze_loa_exp_host.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_ze_loa_exp_host.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_loa_exp_host.created_user is
    'User - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_loa_exp_host.cycle is
    'Anzahl der Versuche der Übertragung  (Versuchszähler)';

comment on column dirkspzm32.pzm_ze_loa_exp_host.datum is
    'Datum
für die Abrechnung';

comment on column dirkspzm32.pzm_ze_loa_exp_host.err_text is
    'Returncode aus Übertragung';

comment on column dirkspzm32.pzm_ze_loa_exp_host.konten_bh_id_korr is
    'Buchungs-ID der Korrektur';

comment on column dirkspzm32.pzm_ze_loa_exp_host.konto_nr_korr is
    'Konto für Korrekturen z.B. Flex bei Kappung';

comment on column dirkspzm32.pzm_ze_loa_exp_host.konto_val_korr is
    'Konto ist um diesen Wert in der monatsaberechnung korrigiert';

comment on column dirkspzm32.pzm_ze_loa_exp_host.kst_id is
    'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';

comment on column dirkspzm32.pzm_ze_loa_exp_host.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_ze_loa_exp_host.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_loa_exp_host.last_change_user is
    'User - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_loa_exp_host.loa_grp is
    'LOA-Gruppe';

comment on column dirkspzm32.pzm_ze_loa_exp_host.loa_unit is
    'Konstant ''STD'' bzw. ''TAG''';

comment on column dirkspzm32.pzm_ze_loa_exp_host.loa_value is
    'Stunden
/ Tage - LOA-Wert';

comment on column dirkspzm32.pzm_ze_loa_exp_host.lohnart is
    'Lohnart
';

comment on column dirkspzm32.pzm_ze_loa_exp_host.lz_id is
    'LZ-ID aus den Lohnarten zum referenz-lesen';

comment on column dirkspzm32.pzm_ze_loa_exp_host.pb_id is
    'Mandant z.B. 01
';

comment on column dirkspzm32.pzm_ze_loa_exp_host.pers_nr is
    'zeaw = ZE Auswertung';

comment on column dirkspzm32.pzm_ze_loa_exp_host.ret_code is
    'Returncode aus Übertragung';

comment on column dirkspzm32.pzm_ze_loa_exp_host.status is
    'N = Neu, im HOST noch nicht Übernommen U = Ist in übertragung, UE = HOST hat den Satz übernommen, ERR = Fehler, D = Delete -> ISIPlus kann den Eintrag Löschen'
    ;


-- sqlcl_snapshot {"hash":"397ceb726c173678ba7623624dce6c855a75cf74","type":"COMMENT","name":"pzm_ze_loa_exp_host","schemaName":"dirkspzm32","sxml":""}