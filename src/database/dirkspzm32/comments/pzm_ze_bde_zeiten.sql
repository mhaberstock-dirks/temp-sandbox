comment on table PZM_ZE_BDE_ZEITEN is 'Hier wird der tagessatz für einen Mitarbeiter eingetragen';
comment on column PZM_ZE_BDE_ZEITEN."CREATED_DATE" is 'Datum Erstellt';
comment on column PZM_ZE_BDE_ZEITEN."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column PZM_ZE_BDE_ZEITEN."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column PZM_ZE_BDE_ZEITEN."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_BASIS" is 'Basis der Buchung BDE oder PZM (Primary-Key)';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_DATUM" is 'Datum des Eintrags = Startzeitpunkt initial (Primary-Key)';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_DAY_IST_ENDE" is 'Zeitpunkt des Endes';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_DAY_IST_START" is 'Zeitpunkt des Anfangs';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_DWH_DATUM" is 'Data Warehouse Datum';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_DWH_RET_CODE" is 'Data Warehouse Return Code';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_DWH_STATUS" is 'Transfer Status Data Warehouse: N=Neu, U=In Ubetragung, UE=Uebertragen, ERR=Fehler';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_DWH_STATUS_TEXT" is 'Data Warehouse Status/Fehlertext';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_FA_AG" is 'Kostenstelle (FA)';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_FA_UPOS" is 'Kostenstelle (FA)';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_LEITZAHL" is 'Kostenstelle (FA)';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_PERS_NR" is 'Personal-ID (Primary-Key)';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_PERSONALTEILBER" is 'Personnalteilbereich (Werk, Tätigkeit bei INFOR etc.)
';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_RET_CODE" is '0 = OK, sonst Fehlercode';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_SA_KURZNAME" is 'Kurzname des Schichtart';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_STATUS_TEXT" is 'Status/Fehlertext der Übertragung';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_VERBUCHT_DATUM" is 'Zeitpunkt der Verbuchung';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_VERBUCHT_STATUS" is 'Status des datensatz N=Neu, U=In Übetragung, UE=Übetragen(Fertig), ERR=Fehler';
comment on column PZM_ZE_BDE_ZEITEN."ZE_BDE_ZEIT_MIN" is 'Aufgelaufene Zeit für den Mitarbeiter in Minuten auf diesem Arbeitsgang';



-- sqlcl_snapshot {"hash":"79eb08e5e847f0e4a06ee8e04f96c2a1cece1e40","type":"COMMENT","name":"pzm_ze_bde_zeiten","schemaName":"dirkspzm32","sxml":""}