comment on table ISI_SECURITY_CFG is 'Stell Benutzergruppen bezogene Konfigurationen zur Verfügung';
comment on column ISI_SECURITY_CFG."GROUP_ID" is 'Die Sicherheitsgruppe, für die dieser Parameter gilt';
comment on column ISI_SECURITY_CFG."KATEGORIE" is 'Worum geht es';
comment on column ISI_SECURITY_CFG."KATEGORIE_IX" is 'Kategorie IX z.b Schnittstelle Nr 1 ..n';
comment on column ISI_SECURITY_CFG."MODULE_NAME" is 'Für welches Modul gilt der Parameter: LVS,Order,... ISI = Allgemein';
comment on column ISI_SECURITY_CFG."PARAMETER_NAME" is 'z.B. Baudrate';
comment on column ISI_SECURITY_CFG."PARAMETER_TYP" is 'STRING ,INTEGER, BOOLEAN';
comment on column ISI_SECURITY_CFG."PARAMETER_WERT" is 'z.B. 9600';
comment on column ISI_SECURITY_CFG."SECURITY_CFG_ID" is 'Eindeutige Nummer';



-- sqlcl_snapshot {"hash":"e5fd1d38754d20fb15f031588536f6a0092e3c19","type":"COMMENT","name":"isi_security_cfg","schemaName":"dirkspzm32","sxml":""}