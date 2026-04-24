comment on column dirkspzm32.ts_job_items.enabled is
    '''T'' = Aktivierbar, ''F'' = nicht ausführen (überspringen)';

comment on column dirkspzm32.ts_job_items.export_type is
    'EXCEL, PDF, CSV';

comment on column dirkspzm32.ts_job_items.job_item_pos is
    '10, 20, 11 (am besten in 10er schritten)';

comment on column dirkspzm32.ts_job_items.job_item_type is
    'REP_EXP, REP_PRINT, PDF_MERGE, ZIP_MERGE, SND_MAIL, SHELL_CMD, DB_SCRIPT';

comment on column dirkspzm32.ts_job_items.last_exec_duration_sec is
    'Ausführungsdauer in Sek.';

comment on column dirkspzm32.ts_job_items.status is
    'new, active, error, ready';


-- sqlcl_snapshot {"hash":"705984132a769aaa9a00aa1cf6a2d453d5feab51","type":"COMMENT","name":"ts_job_items","schemaName":"dirkspzm32","sxml":""}