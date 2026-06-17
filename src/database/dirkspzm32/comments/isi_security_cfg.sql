comment on table DIRKSPZM32.ISI_SECURITY_CFG is 'Stell Benutzergruppen bezogene Konfigurationen zur Verfügung';
comment on column DIRKSPZM32.ISI_SECURITY_CFG."GROUP_ID" is 'Die Sicherheitsgruppe, für die dieser Parameter gilt';
comment on column DIRKSPZM32.ISI_SECURITY_CFG."KATEGORIE" is 'Worum geht es';
comment on column DIRKSPZM32.ISI_SECURITY_CFG."KATEGORIE_IX" is 'Kategorie IX z.b Schnittstelle Nr 1 ..n';
comment on column DIRKSPZM32.ISI_SECURITY_CFG."MODULE_NAME" is 'Für welches Modul gilt der Parameter: LVS,Order,... ISI = Allgemein';
comment on column DIRKSPZM32.ISI_SECURITY_CFG."PARAMETER_NAME" is 'z.B. Baudrate';
comment on column DIRKSPZM32.ISI_SECURITY_CFG."PARAMETER_TYP" is 'STRING ,INTEGER, BOOLEAN';
comment on column DIRKSPZM32.ISI_SECURITY_CFG."PARAMETER_WERT" is 'z.B. 9600';
comment on column DIRKSPZM32.ISI_SECURITY_CFG."SECURITY_CFG_ID" is 'Eindeutige Nummer';



-- sqlcl_snapshot {"hash":"b82ee370d1d445d76db3e99b5179c12294454187","type":"COMMENT","name":"isi_security_cfg","schemaName":"dirkspzm32","sxml":""}