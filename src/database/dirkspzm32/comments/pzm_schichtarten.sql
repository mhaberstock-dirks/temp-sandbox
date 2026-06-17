comment on table DIRKSPZM32.PZM_SCHICHTARTEN is 'Schichtarten beschreibt den Tageszeitplan incl. der Pausen und an welchen Wochentagen diese Konfiguration gilt';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."CALC_BASIS" is 'FESTZ = feste Zeiten, GLEITZ = Gleitzeit (std_pro_tag is die Basis)';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."FLEX_MAX_STD_PRO_TAG" is 'Maximal flexible stunden pro tag (alles was mehr ist, wird als überstd gewertet)';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE1_ARB_STD" is 'Arbeitsstunden: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE1_DAUER_MIN" is 'Pausendauer in Minuten: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE1_UNBEZ" is 'T = Pausendauer für mehrstufige Pausenzeiten unbezahlt, F = bezahlt';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE2_ARB_STD" is 'Arbeitsstunden: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE2_DAUER_MIN" is 'Pausendauer in Minuten: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE2_UNBEZ" is 'T = Pausendauer für mehrstufige Pausenzeiten unbezahlt, F = bezahlt';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE3_ARB_STD" is 'Arbeitsstunden: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE3_DAUER_MIN" is 'Pausendauer in Minuten: für mehrstufige Pausenzeiten bei Gleitarbeitszeit';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE3_UNBEZ" is 'T = Pausendauer für mehrstufige Pausenzeiten unbezahlt, F = bezahlt';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE_DAUER_MIN" is 'Pausendauer in Minuten für die Regelarbeitszeit';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."GLEITZ_PAUSE_UNBEZ" is 'T = Pausendauer für die Regelarbeitszeit unbezahlt, F = bezahlt';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_BEGINN" is 'Schichtbeginn';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_BEMERKUNG" is 'Bemerkung zur Schichtart';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_BEWERTUNG_BEGINN" is 'Die Bewertung der Schichtart zum Anfang oder zum Ende der Schicht. 0 = Schichtanfang, 1 = Schichtende';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_ENDE" is 'Schichtende';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_ENDE_NACHLAUF_MIN" is 'Nachlaufzeit in der bei Ende der Schicht nicht Minutengenau sonder auf das Schichtende kalkuliert wird (Feierabendzeit)';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_KURZNAME" is 'Schichtart Kurzname (wird als Referenz in der Zeiterfassung verwendet) (Unique-Key)';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_NAME" is 'Name der Schichtart (Primary-Key)';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_PAUSE1_BEGINN" is 'Erste Pause Anfang';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_PAUSE1_DAUER" is 'Erste Pause Dauer in Minuten';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_PAUSE1_ENDE" is 'Erste Pause Ende';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_PAUSE1_UNBEZ" is '0 = Nein, 1 = Ja';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_PAUSE2_BEGINN" is 'Zweite Pause Anfang';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_PAUSE2_DAUER" is 'Zweite Pause Dauer in Minuten';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_PAUSE2_ENDE" is 'Zweite Pause Ende';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_PAUSE2_UNBEZ" is '0 = Nein, 1 = Ja';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_STANDARD" is 'Standardschicht (wenn keine zutreffende Schicht gefunden wurde)';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_STD_PRO_TAG" is 'Stunden pro Tag';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_WOT_DI" is '0 = Nein, 1 = Ja';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_WOT_DO" is '0 = Nein, 1 = Ja';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_WOT_FR" is '0 = Nein, 1 = Ja';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_WOT_MI" is '0 = Nein, 1 = Ja';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_WOT_MO" is '0 = Nein, 1 = Ja';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_WOT_SA" is '0 = Nein, 1 = Ja';
comment on column DIRKSPZM32.PZM_SCHICHTARTEN."SA_WOT_SO" is '0 = Nein, 1 = Ja';



-- sqlcl_snapshot {"hash":"99e2c6301ca9838f69ccba573a22df7f29a319b9","type":"COMMENT","name":"pzm_schichtarten","schemaName":"dirkspzm32","sxml":""}