comment on column dirkspzm32.ts_resources_cfg.app_exename is
    'Name der Anwendung des bearbeitenden Servers';

comment on column dirkspzm32.ts_resources_cfg.enabled is
    'F = Konfigurationseintrag inaktiv, T = Konfigurationseintrag aktiv';

comment on column dirkspzm32.ts_resources_cfg.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.ts_resources_cfg.group_id is
    'Group ID aus SEC_GROUPS';

comment on column dirkspzm32.ts_resources_cfg.hostname is
    'Hostname oder TCP/IP Adresse des bearbeitenden Servers';

comment on column dirkspzm32.ts_resources_cfg.instance_id is
    'Instanznummer des bearbeitenden Servers';

comment on column dirkspzm32.ts_resources_cfg.sched_res_id is
    'Unique ID';

comment on column dirkspzm32.ts_resources_cfg.sched_res_name is
    'Name der Scheduler Ressource; bei Verwendung SCHED_TYPE_DIS Name des Connectors';

comment on column dirkspzm32.ts_resources_cfg.sched_type is
    'SCHED_TYPE_TASK_SERVICE = ISIPlus Task Service, SCHED_TYPE_TOR = ISIPlus Torsteuerung, SCHED_TYPE_DIS = ISIPlus Data Integration Server'
    ;

comment on column dirkspzm32.ts_resources_cfg.sid is
    'SID';


-- sqlcl_snapshot {"hash":"8e465ef99043f031d8c32cfc281be488a645e172","type":"COMMENT","name":"ts_resources_cfg","schemaName":"dirkspzm32","sxml":""}