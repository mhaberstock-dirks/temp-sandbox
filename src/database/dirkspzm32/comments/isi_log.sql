comment on table dirkspzm32.isi_log is
    'Logtabelle für ISIPlus systemmeldungen';

comment on column dirkspzm32.isi_log.firma_nr is
    'Firmennummer';

comment on column dirkspzm32.isi_log.log_category is
    'Kategorie';

comment on column dirkspzm32.isi_log.log_computer is
    'TCP/IP Adresse des Computers der die Meldung ausgelöst hat';

comment on column dirkspzm32.isi_log.log_details is
    'Fehlermeldung (Exception)';

comment on column dirkspzm32.isi_log.log_error_code is
    'Fehlernummer';

comment on column dirkspzm32.isi_log.log_id is
    'ID des Eintrags';

comment on column dirkspzm32.isi_log.log_level is
    'Loglevel';

comment on column dirkspzm32.isi_log.log_modul is
    'ISIPlus Modulname';

comment on column dirkspzm32.isi_log.log_msg_count is
    'Anzahl LOG''s diese Meldungen in der letzten Minute ';

comment on column dirkspzm32.isi_log.log_programm is
    'Programmname des Programms';

comment on column dirkspzm32.isi_log.log_status is
    'WQ = Warte auf Quittierung, Q = Quittiert';

comment on column dirkspzm32.isi_log.log_time is
    'Log Zeitpunkt';

comment on column dirkspzm32.isi_log.log_typ is
    'I = Info, W = Warning, E = Error/Exception';

comment on column dirkspzm32.isi_log.sid is
    'SID';


-- sqlcl_snapshot {"hash":"61eed892a309d4d4b8c77c14052b326a192cf1b2","type":"COMMENT","name":"isi_log","schemaName":"dirkspzm32","sxml":""}