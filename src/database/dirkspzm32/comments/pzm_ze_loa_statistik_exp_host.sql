comment on table dirkspzm32.pzm_ze_loa_statistik_exp_host is
    'Stunden/Lohnarten zur Abrechnung - Übertragung zum Host';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.created_user is
    'User - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.cycle is
    'Anzahl der Versuche der Übertragung  (Versuchszähler)';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.datum is
    'Datum
für die Abrechnung';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.err_text is
    'Returncode aus Übertragung';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.kst_id is
    'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.last_change_user is
    'User - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.pb_id is
    'Mandant z.B. 01
';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.pers_nr is
    'zeaw = ZE Auswertung';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.ret_code is
    'Returncode aus Übertragung';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.status is
    'N = Neu, im HOST noch nicht Übernommen U = Ist in übertragung, UE = HOST hat den Satz übernommen, ERR = Fehler, D = Delete -> ISIPlus kann den Eintrag Löschen'
    ;

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.stat_unit is
    'Einheit für den Statistikwert';

comment on column dirkspzm32.pzm_ze_loa_statistik_exp_host.stat_value is
    'Stunden
/ Tage - STAT-Wert';


-- sqlcl_snapshot {"hash":"bfbb0263b01d4addb599d2dfed85e6e36aad26fa","type":"COMMENT","name":"pzm_ze_loa_statistik_exp_host","schemaName":"dirkspzm32","sxml":""}