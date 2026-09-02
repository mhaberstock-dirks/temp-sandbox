comment on column TS_JOB_ITEMS."ENABLED" is '''T'' = Aktivierbar, ''F'' = nicht ausführen (überspringen)';
comment on column TS_JOB_ITEMS."EXPORT_TYPE" is 'EXCEL, PDF, CSV';
comment on column TS_JOB_ITEMS."JOB_ITEM_POS" is '10, 20, 11 (am besten in 10er schritten)';
comment on column TS_JOB_ITEMS."JOB_ITEM_TYPE" is 'REP_EXP, REP_PRINT, PDF_MERGE, ZIP_MERGE, SND_MAIL, SHELL_CMD, DB_SCRIPT';
comment on column TS_JOB_ITEMS."LAST_EXEC_DURATION_SEC" is 'Ausführungsdauer in Sek.';
comment on column TS_JOB_ITEMS."STATUS" is 'new, active, error, ready';



-- sqlcl_snapshot {"hash":"22736a34aca7817fecf3559c92c83837ca5da679","type":"COMMENT","name":"ts_job_items","schemaName":"dirkspzm32","sxml":""}