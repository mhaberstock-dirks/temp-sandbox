comment on table PZM_ZE_AZK_URLAUB is 'PZM AZK Urlaub Monat Abschluss';
comment on column PZM_ZE_AZK_URLAUB."ARBEITSKONTO_SALDO_STUNDEN" is 'Arbeitskonto Saldo [Stunden] - zum Datum';
comment on column PZM_ZE_AZK_URLAUB."CREATED_DATE" is 'Datum Erstellt';
comment on column PZM_ZE_AZK_URLAUB."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column PZM_ZE_AZK_URLAUB."CREATED_USER" is 'User - Wer hat diesen Eintrag Erstellt';
comment on column PZM_ZE_AZK_URLAUB."CYCLE" is 'Anzahl der Versuche der Übertragung  (Versuchszähler)';
comment on column PZM_ZE_AZK_URLAUB."DATUM" is 'Abschlussdatum (Primay-Key)';
comment on column PZM_ZE_AZK_URLAUB."ERR_TEXT" is 'Returncode aus Übertragung';
comment on column PZM_ZE_AZK_URLAUB."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column PZM_ZE_AZK_URLAUB."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column PZM_ZE_AZK_URLAUB."LAST_CHANGE_USER" is 'User - Wer hat diesen Eintrag zuletzt geändert';
comment on column PZM_ZE_AZK_URLAUB."NNAME" is 'Nachname';
comment on column PZM_ZE_AZK_URLAUB."PB_ID" is 'Produktionsbereich-ID (Foreign-Key PZM_PRODUKTIONSBEREICHE)';
comment on column PZM_ZE_AZK_URLAUB."PERS_KST_ID" is 'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';
comment on column PZM_ZE_AZK_URLAUB."PERS_NR" is 'Personal-ID (Primay-Key)';
comment on column PZM_ZE_AZK_URLAUB."RESTURLAUB_STUNDEN" is 'Resturlaub [Stunden] - zum Datum';
comment on column PZM_ZE_AZK_URLAUB."RET_CODE" is 'Returncode aus Übertragung';
comment on column PZM_ZE_AZK_URLAUB."STATUS" is 'N = Neu, im HOST noch nicht Übernommen U = Ist in übertragung, UE = HOST hat den Satz übernommen, ERR = Fehler, D = Delete -> ISIPlus kann den Eintrag Löschen';
comment on column PZM_ZE_AZK_URLAUB."URLAUBSANSPRUCH_STUNDEN_JAHR" is 'Urlaubsanspruch [Stunden] - Jahr';
comment on column PZM_ZE_AZK_URLAUB."URLAUBSANSPRUCH_TAGE_JAHR" is 'Urlaubsanspruch [Tage] - Jahr';
comment on column PZM_ZE_AZK_URLAUB."VNAME" is 'Vorname';



-- sqlcl_snapshot {"hash":"9d7051aebe2eccecdd250fd62159bb4521f3dd93","type":"COMMENT","name":"pzm_ze_azk_urlaub","schemaName":"dirkspzm32","sxml":""}