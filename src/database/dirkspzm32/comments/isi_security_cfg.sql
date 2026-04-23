comment on table dirkspzm32.isi_security_cfg is
    'Stell Benutzergruppen bezogene Konfigurationen zur Verfügung';

comment on column dirkspzm32.isi_security_cfg.group_id is
    'Die Sicherheitsgruppe, für die dieser Parameter gilt';

comment on column dirkspzm32.isi_security_cfg.kategorie is
    'Worum geht es';

comment on column dirkspzm32.isi_security_cfg.kategorie_ix is
    'Kategorie IX z.b Schnittstelle Nr 1 ..n';

comment on column dirkspzm32.isi_security_cfg.module_name is
    'Für welches Modul gilt der Parameter: LVS,Order,... ISI = Allgemein';

comment on column dirkspzm32.isi_security_cfg.parameter_name is
    'z.B. Baudrate';

comment on column dirkspzm32.isi_security_cfg.parameter_typ is
    'STRING ,INTEGER, BOOLEAN';

comment on column dirkspzm32.isi_security_cfg.parameter_wert is
    'z.B. 9600';

comment on column dirkspzm32.isi_security_cfg.security_cfg_id is
    'Eindeutige Nummer';


-- sqlcl_snapshot {"hash":"7ddc8203c7d58319f00deed74564a3656dea78a5","type":"COMMENT","name":"isi_security_cfg","schemaName":"dirkspzm32","sxml":""}