comment on table dirkspzm32.ts_schedule_cfg is
    'Konfiguration der Ausführungszeiten';

comment on column dirkspzm32.ts_schedule_cfg.last_actual_finish is
    'letzter ISI-Ende';

comment on column dirkspzm32.ts_schedule_cfg.last_actual_start is
    'letzter IST-Start';

comment on column dirkspzm32.ts_schedule_cfg.next_start is
    'berechneter Start';

comment on column dirkspzm32.ts_schedule_cfg.recurr_count is
    'Anzahl der Wiederholungen';

comment on column dirkspzm32.ts_schedule_cfg.recurr_day_number is
    'Tagesintervall auf Basis von recurr_day_type';

comment on column dirkspzm32.ts_schedule_cfg.recurr_day_type is
    '0=day, 1=every Day, 2=weekday, 3=weekendday, 4-10 = sunday-saturday';

comment on column dirkspzm32.ts_schedule_cfg.recurr_occur_days is
    '1;2;5;6;  1= Montag, 7 = Sonntag';

comment on column dirkspzm32.ts_schedule_cfg.recurr_periodicity is
    'Wiederholfrequenz basierend auf den Wiederholungstyp';

comment on column dirkspzm32.ts_schedule_cfg.recurr_type is
    '0 = Daily, 1 = Weekly, 2 = Monthly, 3 = Yearly';

comment on column dirkspzm32.ts_schedule_cfg.recurr_year_periodicity is
    'Wiederholfrequenz basierend auf ein Jahr';

comment on column dirkspzm32.ts_schedule_cfg.sched_res_id is
    'Für unterschiedliche Systeme. Default Resource id = 1';

comment on column dirkspzm32.ts_schedule_cfg.time_line_state is
    '0 = Verplanbar, 1 = unter Vorbehalt, 2 = Belegt, 3 = Abwesenheit';

comment on column dirkspzm32.ts_schedule_cfg.ts_job_name is
    'Welcher job wird ausgeführt';


-- sqlcl_snapshot {"hash":"f855e4ab893bc62554945d6259c8d5d4b91cab5e","type":"COMMENT","name":"ts_schedule_cfg","schemaName":"dirkspzm32","sxml":""}