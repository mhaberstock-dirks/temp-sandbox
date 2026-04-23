comment on table dirkspzm32.wdg_cfg is
    'Watchdog Konfiguration';

comment on column dirkspzm32.wdg_cfg.active is
    'Konfigurationseintrag aktiv/inaktiv (T/F)';

comment on column dirkspzm32.wdg_cfg.app_exename is
    'Name der Anwendung, nicht case sensitiv';

comment on column dirkspzm32.wdg_cfg.check_type is
    'APP_MEM (MIN=freier OS Speicher, MAX=Speicher der Anwendung), HDD (MIN=freier HDD Speicher, MAX=unbenutzt),  DB_INFO (MAX=Anzahl Cursors App, MIN=unbenutzt)'
    ;

comment on column dirkspzm32.wdg_cfg.data_interval_sec is
    'Genereller Intervall in Sekunden für die Datenübertragung vom Agent (Timeout = Intervall * 2)';

comment on column dirkspzm32.wdg_cfg.error_max_value is
    'Fehler beim Überschreiten (Value = Bytes, Pakete, ... kleinste Einheit)';

comment on column dirkspzm32.wdg_cfg.error_min_value is
    'Fehler beim Unterschreiten (Value = Bytes, Pakete, ... kleinste Einheit)';

comment on column dirkspzm32.wdg_cfg.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.wdg_cfg.hdd_root_path is
    'C:\, D:\ für CHECK_TYPE HDD';

comment on column dirkspzm32.wdg_cfg.hostname is
    'Hostname oder TCP/IP Adresse für den die Konfiguration gilt';

comment on column dirkspzm32.wdg_cfg.logger_delta_sec is
    'Delta für Logger in Sekunden für permanente wechsel von Schwellwert Über-/Unterschreitungen';

comment on column dirkspzm32.wdg_cfg.sid is
    'SID';

comment on column dirkspzm32.wdg_cfg.warn_max_value is
    'Warnung beim Überschreiten (Value = Bytes, Pakete, ... kleinste Einheit)';

comment on column dirkspzm32.wdg_cfg.warn_min_value is
    'Warnung beim Unterschreiten (Value = Bytes, Pakete, ... kleinste Einheit)';

comment on column dirkspzm32.wdg_cfg.wdg_cfg_id is
    'UniqueID';


-- sqlcl_snapshot {"hash":"11cdd5ad5738110acaf430d7f3a778f701c98dee","type":"COMMENT","name":"wdg_cfg","schemaName":"dirkspzm32","sxml":""}