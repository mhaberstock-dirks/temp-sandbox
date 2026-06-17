comment on table DIRKSPZM32.PZM_ZE_TAGESSATZ is 'Hier wird der tagessatz für einen Mitarbeiter eingetragen';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_AA_ID" is 'Abwesenheitsart-ID';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_ABSCHLUSS" is 'Personal-ID desjenigen der den Abschluss gemacht hat';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_ABWESENHEIT" is 'Abwesend (0 = anwesend, 1 = abwesend)';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DATUM" is 'Datum des Tagessatz (Primary-Key)';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_ABT_ID" is 'Abteilung';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_ABW_STD" is 'Abwesende Stunden';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_ANW_STD" is 'Gesamt Anwesenheitsstunden (für Auswertung)';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_ARB_STD" is 'Arbeitszeit in Stunden';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_ARB_STD_G_MIN" is 'Gutschrift auf Anwesenheit und Arbeitszeit';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_FLEX_STD" is 'Flexible  Mehrarbeitsstunden !! Nur Mehrarbeit, keine Minusstunden';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_IST_ENDE" is 'Zeitpunkt des Endes';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_IST_START" is 'Zeitpunkt des Anfangs';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_KORR_STD" is 'Korrektur Stunden';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_KST_ID" is 'Kostenstelle';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_PAUSE_STD" is 'Angerechnete (abgezogene) Pausenzeit';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_PB_ID" is 'Produktionsbereich (Foreign-Key PZM_PRODUKTIONSBEREICHE)';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_UEB_STD" is 'Überstunden';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_WERT_ENDE" is 'Endwert für das Ende des Tages';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_DAY_WERT_START" is 'Startwert für den Anfang des Tages';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_PERS_NR" is 'Personal-ID (Primary-Key)';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_SA_KURZNAME" is 'Kurzname des Schichtart';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_UEB_OK_DATUM" is 'Zeitpunkt der letzten Änderung';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_UEB_OK_PERS_NR" is 'Personal-ID der die Änderung vorgenommen hat (Foreign-Key PZM_PERSONAL)
';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_UEB_STORNO_DATUM" is 'Zeitpunkt der letzten Änderung';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_UEB_STORNO_PERS_NR" is 'Personal-ID der die Änderung vorgenommen hat (Foreign-Key PZM_PERSONAL)
';
comment on column DIRKSPZM32.PZM_ZE_TAGESSATZ."TS_VERBUCHT_DATUM" is 'Zeitpunkt der Verbuchung';



-- sqlcl_snapshot {"hash":"0b4d21d95e71f8d7efa821c648fbf815fe9a25c0","type":"COMMENT","name":"pzm_ze_tagessatz","schemaName":"dirkspzm32","sxml":""}