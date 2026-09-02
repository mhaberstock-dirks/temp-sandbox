comment on table PZM_ALLG_PARAMETER is 'Algemeine Parameter PZM - Generische (globale) Konfigurationen zur Steuerung der Zeiterfassung';
comment on column PZM_ALLG_PARAMETER."AP_INFO" is 'Beschreibung des Allgemeinen Parameters';
comment on column PZM_ALLG_PARAMETER."AP_NAME" is 'Name des Allgemeinen Parameters (Primary-Key)';
comment on column PZM_ALLG_PARAMETER."AP_PB_ID" is 'Produktionsbereich (Foreign-Key PZM_PRODUKTIONSBEREICHE)';
comment on column PZM_ALLG_PARAMETER."AP_TYPE" is 'Typ des Allgemeinen Parameters (Ganze Zahl = Integer, etc...)';
comment on column PZM_ALLG_PARAMETER."AP_VALUE" is 'Wert des Allgemeinen Parameters';
comment on column PZM_ALLG_PARAMETER."CREATED_DATE" is 'Datum Erstellt';
comment on column PZM_ALLG_PARAMETER."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column PZM_ALLG_PARAMETER."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column PZM_ALLG_PARAMETER."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';



-- sqlcl_snapshot {"hash":"2797498ad1fcb622a3f312ae2a7ea2172fbfdee0","type":"COMMENT","name":"pzm_allg_parameter","schemaName":"dirkspzm32","sxml":""}