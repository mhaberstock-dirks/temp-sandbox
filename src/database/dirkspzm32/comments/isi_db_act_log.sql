comment on table ISI_DB_ACT_LOG is 'do not replicate this table in MasterSalve';
comment on column ISI_DB_ACT_LOG."ACT_COMMAND" is 'command of current action (can be INSERT, UPDATE, DELETE, etc.)';
comment on column ISI_DB_ACT_LOG."ACT_INFO" is 'action information defined by the developer in the trigger etc.';
comment on column ISI_DB_ACT_LOG."ACT_PK_COLS" is 'current action with these primary key columns';
comment on column ISI_DB_ACT_LOG."ACT_PK_VALUES" is 'current action with these primary key values';
comment on column ISI_DB_ACT_LOG."ACT_TABLE" is 'current action on this Table';
comment on column ISI_DB_ACT_LOG."AUDSID" is 'Unique Oracle Session ID';
comment on column ISI_DB_ACT_LOG."BG_JOB_ID" is 'JOB_ID des Jobs, der diese Session instanziert hat';
comment on column ISI_DB_ACT_LOG."CLIENT_ACTION_INFO" is 'ActionInfo defined by the running application';
comment on column ISI_DB_ACT_LOG."CLIENT_HOST" is 'MACHINE name (with domain) of the client';
comment on column ISI_DB_ACT_LOG."CLIENT_IDENTIFIER" is 'An identifier that is set by the application through the DBMS_SESSION.SET_IDENTIFIER';
comment on column ISI_DB_ACT_LOG."CLIENT_INFO" is 'ClientInfo defined by the running application';
comment on column ISI_DB_ACT_LOG."CLIENT_MODULE_INFO" is 'ModuleInfo defined by the running application';
comment on column ISI_DB_ACT_LOG."CLIENT_OS_USER" is 'OS user from the client';
comment on column ISI_DB_ACT_LOG."DB_ACT_LOG_ID" is 'Unique Sequnce Number';
comment on column ISI_DB_ACT_LOG."ISIUSR" is 'current ISIPlus user logged on in the running application';
comment on column ISI_DB_ACT_LOG."LOG_DATE" is 'Date for the log entry';
comment on column ISI_DB_ACT_LOG."PROGRAM" is 'executing programmname (EXE name)';
comment on column ISI_DB_ACT_LOG."TERMINAL" is 'HOSTNAME of the client';



-- sqlcl_snapshot {"hash":"3033aefc5d0310d28c45a52b65be063cd67e3124","type":"COMMENT","name":"isi_db_act_log","schemaName":"dirkspzm32","sxml":""}