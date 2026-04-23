comment on table dirkspzm32.pzm_log is
    'Log-Tabelle fuer das PZM (Personal-Zeit-Management) Modul';

comment on column dirkspzm32.pzm_log.aktion is
    'Buchungs-Aktion: K=Kommen, G=Gehen, P=Pause, D=Dienstgang';

comment on column dirkspzm32.pzm_log.client_host is
    'Client Hostname';

comment on column dirkspzm32.pzm_log.client_identifier is
    'Client Identifier (App-spezifisch)';

comment on column dirkspzm32.pzm_log.client_info is
    'Client Info (provided by executing application)';

comment on column dirkspzm32.pzm_log.log_category is
    'Kategorie: Zeiterfassung, Terminal, Tagessatz, Lohnauswertung';

comment on column dirkspzm32.pzm_log.log_error_code is
    'Oracle SQLCODE bei Exceptions';

comment on column dirkspzm32.pzm_log.log_id is
    'Eindeutige Log-ID (Sequenz)';

comment on column dirkspzm32.pzm_log.log_level is
    'Log-Level: 0=Trace, 1=Debug, 2=Info, 3=Warning, 4=Error, 5=Fatal';

comment on column dirkspzm32.pzm_log.log_message is
    'Log-Nachricht';

comment on column dirkspzm32.pzm_log.log_module is
    'Modul/Prozedur die den Log-Eintrag erzeugt hat';

comment on column dirkspzm32.pzm_log.log_stacktrace is
    'Oracle Error Backtrace bei Exceptions';

comment on column dirkspzm32.pzm_log.log_timestamp is
    'Zeitstempel des Log-Eintrags (Millisekunden-Precision)';

comment on column dirkspzm32.pzm_log.os_user is
    'Client OS User (connected to current Oracle Session)';

comment on column dirkspzm32.pzm_log.pers_nr is
    'Betroffene Personalnummer (PZM-Kontext)';

comment on column dirkspzm32.pzm_log.quelle is
    'Buchungs-Quelle: LIVE, TERMINAL, MANUELL, SYSTEM';

comment on column dirkspzm32.pzm_log.schicht_tag is
    'Betroffener Schichttag (PZM-Kontext)';

comment on column dirkspzm32.pzm_log.terminal_id is
    'Terminal-ID bei Terminal-Buchungen';

comment on column dirkspzm32.pzm_log.ze_id is
    'Betroffene Zeiterfassungs-ID (PZM-Kontext)';

comment on column dirkspzm32.pzm_log.ze_rfid is
    'Verwendete RFID/Transponder (PZM-Kontext)';


-- sqlcl_snapshot {"hash":"c7fa061c362d011a9fc6f370eb7fcaac37580e77","type":"COMMENT","name":"pzm_log","schemaName":"dirkspzm32","sxml":""}