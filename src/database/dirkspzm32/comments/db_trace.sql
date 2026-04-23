comment on table dirkspzm32.db_trace is
    'do not replicate this table in MasterSalve';

comment on column dirkspzm32.db_trace.act_command is
    'command of current action (can be INSERT, UPDATE, DELETE, etc.)';

comment on column dirkspzm32.db_trace.act_info is
    'action information defined by the developer in the trigger etc.';

comment on column dirkspzm32.db_trace.act_pk_cols is
    'current action with these primary key columns';

comment on column dirkspzm32.db_trace.act_pk_values is
    'current action with these primary key values';

comment on column dirkspzm32.db_trace.act_table is
    'current action on this Table';

comment on column dirkspzm32.db_trace.audsid is
    'Unique Oracle Session ID';

comment on column dirkspzm32.db_trace.bg_job_id is
    'JOB_ID des Jobs, der diese Session instanziert hat';

comment on column dirkspzm32.db_trace.client_action_info is
    'ActionInfo defined by the running application';

comment on column dirkspzm32.db_trace.client_host is
    'MACHINE name (with domain) of the client';

comment on column dirkspzm32.db_trace.client_identifier is
    'An identifier that is set by the application through the DBMS_SESSION.SET_IDENTIFIER';

comment on column dirkspzm32.db_trace.client_info is
    'ClientInfo defined by the running application';

comment on column dirkspzm32.db_trace.client_module_info is
    'ModuleInfo defined by the running application';

comment on column dirkspzm32.db_trace.client_os_user is
    'OS user from the client';

comment on column dirkspzm32.db_trace.db_act_log_id is
    'Unique Sequnce Number';

comment on column dirkspzm32.db_trace.isiusr is
    'current ISIPlus user logged on in the running application';

comment on column dirkspzm32.db_trace.log_date is
    'Date for the log entry';

comment on column dirkspzm32.db_trace.program is
    'executing programmname (EXE name)';

comment on column dirkspzm32.db_trace.terminal is
    'HOSTNAME of the client';

comment on column dirkspzm32.db_trace.transactionid is
    'Transaktions ID';


-- sqlcl_snapshot {"hash":"6dc01627473147d2be9af3842662de1b8f060985","type":"COMMENT","name":"db_trace","schemaName":"dirkspzm32","sxml":""}