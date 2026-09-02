comment on table WDG_CFG is 'Watchdog Konfiguration';
comment on column WDG_CFG."ACTIVE" is 'Konfigurationseintrag aktiv/inaktiv (T/F)';
comment on column WDG_CFG."APP_EXENAME" is 'Name der Anwendung, nicht case sensitiv';
comment on column WDG_CFG."CHECK_TYPE" is 'APP_MEM (MIN=freier OS Speicher, MAX=Speicher der Anwendung), HDD (MIN=freier HDD Speicher, MAX=unbenutzt),  DB_INFO (MAX=Anzahl Cursors App, MIN=unbenutzt)';
comment on column WDG_CFG."DATA_INTERVAL_SEC" is 'Genereller Intervall in Sekunden für die Datenübertragung vom Agent (Timeout = Intervall * 2)';
comment on column WDG_CFG."ERROR_MAX_VALUE" is 'Fehler beim Überschreiten (Value = Bytes, Pakete, ... kleinste Einheit)';
comment on column WDG_CFG."ERROR_MIN_VALUE" is 'Fehler beim Unterschreiten (Value = Bytes, Pakete, ... kleinste Einheit)';
comment on column WDG_CFG."FIRMA_NR" is 'Firma Nr.';
comment on column WDG_CFG."HDD_ROOT_PATH" is 'C:\, D:\ für CHECK_TYPE HDD';
comment on column WDG_CFG."HOSTNAME" is 'Hostname oder TCP/IP Adresse für den die Konfiguration gilt';
comment on column WDG_CFG."LOGGER_DELTA_SEC" is 'Delta für Logger in Sekunden für permanente wechsel von Schwellwert Über-/Unterschreitungen';
comment on column WDG_CFG."SID" is 'SID';
comment on column WDG_CFG."WARN_MAX_VALUE" is 'Warnung beim Überschreiten (Value = Bytes, Pakete, ... kleinste Einheit)';
comment on column WDG_CFG."WARN_MIN_VALUE" is 'Warnung beim Unterschreiten (Value = Bytes, Pakete, ... kleinste Einheit)';
comment on column WDG_CFG."WDG_CFG_ID" is 'UniqueID';



-- sqlcl_snapshot {"hash":"e9225abe2a04a4ed7f97e8c187669b6c2bde5aef","type":"COMMENT","name":"wdg_cfg","schemaName":"dirkspzm32","sxml":""}