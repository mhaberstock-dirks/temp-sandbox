comment on table DIRKSPZM32.BDE_PD_SCHICHT_LOG is 'Schicht-Logbuch';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."ACKNOWLEDGED_BY_LOGIN_ID" is 'Login ID des Benutzers der den Log-Eintrag quittiert hat';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."CREATED_BY_HOSTNAME" is 'Name des Computers über den der Log-Eintrag erfasst wurde';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."CREATED_BY_LOGIC" is 'Name der Logik über der Log-Eintrag erfasst wurde';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."CREATED_BY_LOGIN_ID" is 'Login ID des Benutzers der den Log-Eintrag erzeugt hat';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."FA_AG" is 'Arbeitsgang des Fertigungsauftrags zu der der Log-Eintrag zugeordnet ist';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."FA_AG_IST_MENGE" is 'IST-Menge des Arbeitsgangs zum Zeitpunkt  des Log-Eintrags';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."FA_NR" is 'Fertigungsauftrag Nr. zu der der Log-Eintrag zugeordnet ist';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."FA_UPOS" is 'Production Step';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."LOG_DATA" is 'Log-Daten (freier Text)';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."LOG_STATUS" is 'N = Neu, R=Gelesen, A=Quittiert/Fertig/Bearbeitet (Acknowledged)';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."LOG_TIME" is 'Zeitstempel des Log-Eintrags';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."LOG_TYP" is 'I = Info, W = Warning, E = Error';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."READ_BY_LOGIN_ID" is 'Login ID des Benutzers der den Log-Eintrag als erster gelesen hat';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."RES_ID" is 'Resource/Maschine zu der ein Log-Eintrag zugeordnet ist';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."SA_KURZNAME" is 'Kurzname der Schicht, in der der Log-Eintrag erfasst wurde';
comment on column DIRKSPZM32.BDE_PD_SCHICHT_LOG."SCHICHT_LOG_ID" is 'Eindeutige ID des Log-Eintrags';



-- sqlcl_snapshot {"hash":"8d280849da6e576d37529faad194e72a7dda93f7","type":"COMMENT","name":"bde_pd_schicht_log","schemaName":"dirkspzm32","sxml":""}