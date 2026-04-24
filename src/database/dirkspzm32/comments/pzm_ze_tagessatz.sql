comment on table dirkspzm32.pzm_ze_tagessatz is
    'Hier wird der tagessatz für einen Mitarbeiter eingetragen';

comment on column dirkspzm32.pzm_ze_tagessatz.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_ze_tagessatz.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_tagessatz.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_ze_tagessatz.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_aa_id is
    'Abwesenheitsart-ID';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_abschluss is
    'Personal-ID desjenigen der den Abschluss gemacht hat';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_abwesenheit is
    'Abwesend (0 = anwesend, 1 = abwesend)';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_datum is
    'Datum des Tagessatz (Primary-Key)';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_abt_id is
    'Abteilung';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_abw_std is
    'Abwesende Stunden';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_anw_std is
    'Gesamt Anwesenheitsstunden (für Auswertung)';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_arb_std is
    'Arbeitszeit in Stunden';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_arb_std_g_min is
    'Gutschrift auf Anwesenheit und Arbeitszeit';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_flex_std is
    'Flexible  Mehrarbeitsstunden !! Nur Mehrarbeit, keine Minusstunden';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_ist_ende is
    'Zeitpunkt des Endes';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_ist_start is
    'Zeitpunkt des Anfangs';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_korr_std is
    'Korrektur Stunden';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_kst_id is
    'Kostenstelle';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_pause_std is
    'Angerechnete (abgezogene) Pausenzeit';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_pb_id is
    'Produktionsbereich (Foreign-Key PZM_PRODUKTIONSBEREICHE)';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_ueb_std is
    'Überstunden';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_wert_ende is
    'Endwert für das Ende des Tages';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_day_wert_start is
    'Startwert für den Anfang des Tages';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_pers_nr is
    'Personal-ID (Primary-Key)';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_sa_kurzname is
    'Kurzname des Schichtart';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_ueb_ok_datum is
    'Zeitpunkt der letzten Änderung';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_ueb_ok_pers_nr is
    'Personal-ID der die Änderung vorgenommen hat (Foreign-Key PZM_PERSONAL)
';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_ueb_storno_datum is
    'Zeitpunkt der letzten Änderung';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_ueb_storno_pers_nr is
    'Personal-ID der die Änderung vorgenommen hat (Foreign-Key PZM_PERSONAL)
';

comment on column dirkspzm32.pzm_ze_tagessatz.ts_verbucht_datum is
    'Zeitpunkt der Verbuchung';


-- sqlcl_snapshot {"hash":"8d2b99ea428d028bb08303c522cedc6fb4abbdf3","type":"COMMENT","name":"pzm_ze_tagessatz","schemaName":"dirkspzm32","sxml":""}