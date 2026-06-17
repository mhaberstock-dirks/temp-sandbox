comment on table DIRKSPZM32.PZM_ZE_LOA_EXP_HOST is 'Stunden/Lohnarten zur Abrechnung - Übertragung zum Host';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."AA_ID" is 'Mit welcher Abwesenheitsart wurde diese LOA gebucht für SAP nicht relevant';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."CREATED_USER" is 'User - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."CYCLE" is 'Anzahl der Versuche der Übertragung  (Versuchszähler)';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."DATUM" is 'Datum
für die Abrechnung';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."ERR_TEXT" is 'Returncode aus Übertragung';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."KONTEN_BH_ID_KORR" is 'Buchungs-ID der Korrektur';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."KONTO_NR_KORR" is 'Konto für Korrekturen z.B. Flex bei Kappung';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."KONTO_VAL_KORR" is 'Konto ist um diesen Wert in der monatsaberechnung korrigiert';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."KST_ID" is 'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."LAST_CHANGE_USER" is 'User - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."LOA_GRP" is 'LOA-Gruppe';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."LOA_UNIT" is 'Konstant ''STD'' bzw. ''TAG''';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."LOA_VALUE" is 'Stunden
/ Tage - LOA-Wert';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."LOHNART" is 'Lohnart
';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."LZ_ID" is 'LZ-ID aus den Lohnarten zum referenz-lesen';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."PB_ID" is 'Mandant z.B. 01
';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."PERS_NR" is 'zeaw = ZE Auswertung';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."RET_CODE" is 'Returncode aus Übertragung';
comment on column DIRKSPZM32.PZM_ZE_LOA_EXP_HOST."STATUS" is 'N = Neu, im HOST noch nicht Übernommen U = Ist in übertragung, UE = HOST hat den Satz übernommen, ERR = Fehler, D = Delete -> ISIPlus kann den Eintrag Löschen';



-- sqlcl_snapshot {"hash":"3b16a1e52f7ff323704d3c01410e198387c27151","type":"COMMENT","name":"pzm_ze_loa_exp_host","schemaName":"dirkspzm32","sxml":""}