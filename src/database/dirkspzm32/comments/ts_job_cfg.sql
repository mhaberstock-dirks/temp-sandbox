comment on column dirkspzm32.ts_job_cfg.last_exec_duration_sec is
    'Dauer der Ausführungzeit in Sek.';

comment on column dirkspzm32.ts_job_cfg.output_dir is
    'Fester Arbeitsordner für den Job.';

comment on column dirkspzm32.ts_job_cfg.status is
    'new, active, error, ready';

comment on column dirkspzm32.ts_job_cfg.ts_job_name is
    'wird auch für das temp arbeitsverzeichnis für diesen Job/Jobitems benutzt (auto cleanup)';


-- sqlcl_snapshot {"hash":"e7fc1393c1921c78d0166f84d28683072dfd723d","type":"COMMENT","name":"ts_job_cfg","schemaName":"dirkspzm32","sxml":""}