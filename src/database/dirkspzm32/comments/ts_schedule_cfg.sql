comment on table TS_SCHEDULE_CFG is 'Konfiguration der Ausführungszeiten';
comment on column TS_SCHEDULE_CFG."LAST_ACTUAL_FINISH" is 'letzter ISI-Ende';
comment on column TS_SCHEDULE_CFG."LAST_ACTUAL_START" is 'letzter IST-Start';
comment on column TS_SCHEDULE_CFG."NEXT_START" is 'berechneter Start';
comment on column TS_SCHEDULE_CFG."RECURR_COUNT" is 'Anzahl der Wiederholungen';
comment on column TS_SCHEDULE_CFG."RECURR_DAY_NUMBER" is 'Tagesintervall auf Basis von recurr_day_type';
comment on column TS_SCHEDULE_CFG."RECURR_DAY_TYPE" is '0=day, 1=every Day, 2=weekday, 3=weekendday, 4-10 = sunday-saturday';
comment on column TS_SCHEDULE_CFG."RECURR_OCCUR_DAYS" is '1;2;5;6;  1= Montag, 7 = Sonntag';
comment on column TS_SCHEDULE_CFG."RECURR_PERIODICITY" is 'Wiederholfrequenz basierend auf den Wiederholungstyp';
comment on column TS_SCHEDULE_CFG."RECURR_TYPE" is '0 = Daily, 1 = Weekly, 2 = Monthly, 3 = Yearly';
comment on column TS_SCHEDULE_CFG."RECURR_YEAR_PERIODICITY" is 'Wiederholfrequenz basierend auf ein Jahr';
comment on column TS_SCHEDULE_CFG."SCHED_RES_ID" is 'Für unterschiedliche Systeme. Default Resource id = 1';
comment on column TS_SCHEDULE_CFG."TIME_LINE_STATE" is '0 = Verplanbar, 1 = unter Vorbehalt, 2 = Belegt, 3 = Abwesenheit';
comment on column TS_SCHEDULE_CFG."TS_JOB_NAME" is 'Welcher job wird ausgeführt';



-- sqlcl_snapshot {"hash":"068d5557c248d74ff09e89033302ff3d0ac02928","type":"COMMENT","name":"ts_schedule_cfg","schemaName":"dirkspzm32","sxml":""}