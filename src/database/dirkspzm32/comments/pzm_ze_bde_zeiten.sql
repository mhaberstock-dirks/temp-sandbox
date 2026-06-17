comment on table DIRKSPZM32.PZM_ZE_BDE_ZEITEN is 'Hier wird der tagessatz für einen Mitarbeiter eingetragen';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_BASIS" is 'Basis der Buchung BDE oder PZM (Primary-Key)';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_DATUM" is 'Datum des Eintrags = Startzeitpunkt initial (Primary-Key)';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_DAY_IST_ENDE" is 'Zeitpunkt des Endes';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_DAY_IST_START" is 'Zeitpunkt des Anfangs';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_DWH_DATUM" is 'Data Warehouse Datum';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_DWH_RET_CODE" is 'Data Warehouse Return Code';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_DWH_STATUS" is 'Transfer Status Data Warehouse: N=Neu, U=In Ubetragung, UE=Uebertragen, ERR=Fehler';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_DWH_STATUS_TEXT" is 'Data Warehouse Status/Fehlertext';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_FA_AG" is 'Kostenstelle (FA)';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_FA_UPOS" is 'Kostenstelle (FA)';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_LEITZAHL" is 'Kostenstelle (FA)';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_PERSONALTEILBER" is 'Personnalteilbereich (Werk, Tätigkeit bei INFOR etc.)
';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_PERS_NR" is 'Personal-ID (Primary-Key)';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_RET_CODE" is '0 = OK, sonst Fehlercode';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_SA_KURZNAME" is 'Kurzname des Schichtart';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_STATUS_TEXT" is 'Status/Fehlertext der Übertragung';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_VERBUCHT_DATUM" is 'Zeitpunkt der Verbuchung';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_VERBUCHT_STATUS" is 'Status des datensatz N=Neu, U=In Übetragung, UE=Übetragen(Fertig), ERR=Fehler';
comment on column DIRKSPZM32.PZM_ZE_BDE_ZEITEN."ZE_BDE_ZEIT_MIN" is 'Aufgelaufene Zeit für den Mitarbeiter in Minuten auf diesem Arbeitsgang';



-- sqlcl_snapshot {"hash":"484872657a543a996755c9e208922f4a30edd52b","type":"COMMENT","name":"pzm_ze_bde_zeiten","schemaName":"dirkspzm32","sxml":""}