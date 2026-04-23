comment on table dirkspzm32.pe_drucker_cfg is
    'Alle für ISIPlus installierten Drucker (Print Engine)';

comment on column dirkspzm32.pe_drucker_cfg.created_date is
    'Erstellungsdatum';

comment on column dirkspzm32.pe_drucker_cfg.created_login_id is
    'Ersteller ID';

comment on column dirkspzm32.pe_drucker_cfg.drucker_typ is
    'WIN = Windows-Drucker; ETI = Etkettendrucker';

comment on column dirkspzm32.pe_drucker_cfg.eti_output_type is
    'C = COM-Server; W = Windows Printer';

comment on column dirkspzm32.pe_drucker_cfg.last_change_date is
    'Änderungsdatum';

comment on column dirkspzm32.pe_drucker_cfg.last_change_login_id is
    'Änderungs ID';

comment on column dirkspzm32.pe_drucker_cfg.pause_after_job_ms is
    'Anzahl ms nach einem Druck warten';

comment on column dirkspzm32.pe_drucker_cfg.print_folder_path is
    'Drucker Datei - Ausgabepfad';

comment on column dirkspzm32.pe_drucker_cfg.status is
    'RUN; OFF; ERR';


-- sqlcl_snapshot {"hash":"32f3d4711b786357f180fc28e1ae129e88192ae8","type":"COMMENT","name":"pe_drucker_cfg","schemaName":"dirkspzm32","sxml":""}