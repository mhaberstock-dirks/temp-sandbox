comment on table DIRKSPZM32.PZM_LOHNARTEN is 'Lohnarten für die Übertragung an die Lohnbuchhaltug';
comment on column DIRKSPZM32.PZM_LOHNARTEN."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_LOHNARTEN."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_ALTERNATIV_LOA_ID" is 'Alternative Lohnart für diese';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_BEMERKUNGEN" is 'Bemerkungen';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_EINHEIT" is 'DD = Tag, HH24 = Stunden';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_FEIERTAG" is 'Ist die Lohnart an einem Ferertag gekoppelt SF = Sonderfeiertag';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_GUELTIG_AB" is 'Lohnart Gültig ab';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_GUELTIG_BIS" is 'Lohnart Gültig bis';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_ID" is 'ID Der Lohnart. Diese ID ist die referenz in der Lohnbuchhaltung';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_IS_ERP_LOA" is 'T = diese LOA in das ERP übertragen, F = keine Übertragung ins ERP';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_KONTO_BUS" is 'Buchungsschlüssel für die Verbuchung in einem Stundenkonto';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_KONTO_NAME_KURZ" is 'Ist die Lohnart für die Verbuchung in einem Stundenkonto. Z.B. Flexistunden';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_LINK_LOA_ID" is 'ggf. verknüpfte Lohnart (z.B. eine in Tagen geführte LOA verknüpft mit einer Std. LOA)';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_LOHNART" is 'Bezeichnung / Beschreibung der Lohnart';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_LOHNART_GRP" is 'Zur Verknüpfung von Lohnarten';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_OPERATOR" is 'Operatur zum Regelwerk Bsp.: Nachtzuschlag 25 % bis max. 10 Stunden <= 10 oder !N = diese LOA darf nicht mit Überstunden verrechnet werden, also Überstunden abziehen, wenn vorhanden';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_RESET_MONATS_ENDE" is 'Reset am Monatsende ja = 1, nein = 0 in im zusammenhang mit VA_RESET_MONATS_ENDE zu betrachten';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_STUNDEN" is 'Stunden für LZ_OPERATOR';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_TYP" is 'ARB_STD = normale Arbeitsstunden, UEB_STD = Überstunden, ZU_STD = Zuschläge, ABW = Abwesenheitsart';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_UHRZ_BIS" is 'Lohnart Gültig bis zu dieser Ujrzeit (Datumsteil wird ignoriert)';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_UHRZ_VON" is 'Lohnart Gültig ab dieser Ujrzeit (Datumsteil wird ignoriert)';
comment on column DIRKSPZM32.PZM_LOHNARTEN."LZ_WOCHENTAG" is 'Ist die Lohnart an einem bestimmten Wochentag gekoppelt z.B. Samstag oder Sonntag';



-- sqlcl_snapshot {"hash":"9ab59879011f7bc859492df161b07608c88925c2","type":"COMMENT","name":"pzm_lohnarten","schemaName":"dirkspzm32","sxml":""}