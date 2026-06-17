comment on table DIRKSPZM32.DB_TRACE is 'do not replicate this table in MasterSalve';
comment on column DIRKSPZM32.DB_TRACE."ACT_COMMAND" is 'command of current action (can be INSERT, UPDATE, DELETE, etc.)';
comment on column DIRKSPZM32.DB_TRACE."ACT_INFO" is 'action information defined by the developer in the trigger etc.';
comment on column DIRKSPZM32.DB_TRACE."ACT_PK_COLS" is 'current action with these primary key columns';
comment on column DIRKSPZM32.DB_TRACE."ACT_PK_VALUES" is 'current action with these primary key values';
comment on column DIRKSPZM32.DB_TRACE."ACT_TABLE" is 'current action on this Table';
comment on column DIRKSPZM32.DB_TRACE."AUDSID" is 'Unique Oracle Session ID';
comment on column DIRKSPZM32.DB_TRACE."BG_JOB_ID" is 'JOB_ID des Jobs, der diese Session instanziert hat';
comment on column DIRKSPZM32.DB_TRACE."CLIENT_ACTION_INFO" is 'ActionInfo defined by the running application';
comment on column DIRKSPZM32.DB_TRACE."CLIENT_HOST" is 'MACHINE name (with domain) of the client';
comment on column DIRKSPZM32.DB_TRACE."CLIENT_IDENTIFIER" is 'An identifier that is set by the application through the DBMS_SESSION.SET_IDENTIFIER';
comment on column DIRKSPZM32.DB_TRACE."CLIENT_INFO" is 'ClientInfo defined by the running application';
comment on column DIRKSPZM32.DB_TRACE."CLIENT_MODULE_INFO" is 'ModuleInfo defined by the running application';
comment on column DIRKSPZM32.DB_TRACE."CLIENT_OS_USER" is 'OS user from the client';
comment on column DIRKSPZM32.DB_TRACE."DB_ACT_LOG_ID" is 'Unique Sequnce Number';
comment on column DIRKSPZM32.DB_TRACE."ISIUSR" is 'current ISIPlus user logged on in the running application';
comment on column DIRKSPZM32.DB_TRACE."LOG_DATE" is 'Date for the log entry';
comment on column DIRKSPZM32.DB_TRACE."PROGRAM" is 'executing programmname (EXE name)';
comment on column DIRKSPZM32.DB_TRACE."TERMINAL" is 'HOSTNAME of the client';
comment on column DIRKSPZM32.DB_TRACE."TRANSACTIONID" is 'Transaktions ID';



-- sqlcl_snapshot {"hash":"6bf6bcd330b13598aefe3557dc152b9b6ac9dfc1","type":"COMMENT","name":"db_trace","schemaName":"dirkspzm32","sxml":""}