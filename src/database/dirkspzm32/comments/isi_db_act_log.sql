comment on table dirkspzm32.isi_db_act_log is
    'do not replicate this table in MasterSalve';

comment on column dirkspzm32.isi_db_act_log.act_command is
    'command of current action (can be INSERT, UPDATE, DELETE, etc.)';

comment on column dirkspzm32.isi_db_act_log.act_info is
    'action information defined by the developer in the trigger etc.';

comment on column dirkspzm32.isi_db_act_log.act_pk_cols is
    'current action with these primary key columns';

comment on column dirkspzm32.isi_db_act_log.act_pk_values is
    'current action with these primary key values';

comment on column dirkspzm32.isi_db_act_log.act_table is
    'current action on this Table';

comment on column dirkspzm32.isi_db_act_log.audsid is
    'Unique Oracle Session ID';

comment on column dirkspzm32.isi_db_act_log.bg_job_id is
    'JOB_ID des Jobs, der diese Session instanziert hat';

comment on column dirkspzm32.isi_db_act_log.client_action_info is
    'ActionInfo defined by the running application';

comment on column dirkspzm32.isi_db_act_log.client_host is
    'MACHINE name (with domain) of the client';

comment on column dirkspzm32.isi_db_act_log.client_identifier is
    'An identifier that is set by the application through the DBMS_SESSION.SET_IDENTIFIER';

comment on column dirkspzm32.isi_db_act_log.client_info is
    'ClientInfo defined by the running application';

comment on column dirkspzm32.isi_db_act_log.client_module_info is
    'ModuleInfo defined by the running application';

comment on column dirkspzm32.isi_db_act_log.client_os_user is
    'OS user from the client';

comment on column dirkspzm32.isi_db_act_log.db_act_log_id is
    'Unique Sequnce Number';

comment on column dirkspzm32.isi_db_act_log.isiusr is
    'current ISIPlus user logged on in the running application';

comment on column dirkspzm32.isi_db_act_log.log_date is
    'Date for the log entry';

comment on column dirkspzm32.isi_db_act_log.program is
    'executing programmname (EXE name)';

comment on column dirkspzm32.isi_db_act_log.terminal is
    'HOSTNAME of the client';


-- sqlcl_snapshot {"hash":"9016e313cf9eaf148b1c5ec5eca84ebef02f3f25","type":"COMMENT","name":"isi_db_act_log","schemaName":"dirkspzm32","sxml":""}