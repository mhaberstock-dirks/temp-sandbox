comment on table dirkspzm32.pzm_bereitschaft_cfg is
    'ID Der Bereitschafttskonfiguration. Diese ID ist die referenz für die erzeugung der LOAs';

comment on column dirkspzm32.pzm_bereitschaft_cfg.bereitschaft_cfg is
    'ID Der Bereitschafttskonfiguration. Diese ID ist die referenz für die erzeugung der LOAs';

comment on column dirkspzm32.pzm_bereitschaft_cfg.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_bereitschaft_cfg.created_user is
    'User - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_bereitschaft_cfg.einheit is
    'Einheit (HH24, DD, ..)  für Wochentag (Wenn FE, SO, SA = NULL, dann für alle Tage)';

comment on column dirkspzm32.pzm_bereitschaft_cfg.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_bereitschaft_cfg.last_change_user is
    'User - er hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_bereitschaft_cfg.loa_einheit is
    'Einhet für die LOA für die Übergabe an die Lohnbuchhaltung';

comment on column dirkspzm32.pzm_bereitschaft_cfg.loa_id is
    'LOA für Wochentag (Wenn FE, SO, SA = NULL, dann für alle Tage)';

comment on column dirkspzm32.pzm_bereitschaft_cfg.loa_id_fe is
    'LOA für Feiertage';

comment on column dirkspzm32.pzm_bereitschaft_cfg.loa_id_sa is
    'LOA für Samstag';

comment on column dirkspzm32.pzm_bereitschaft_cfg.loa_id_so is
    'LOA für Sonntag';

comment on column dirkspzm32.pzm_bereitschaft_cfg.value is
    'Multiplikator für Wochentag von EINHEIT zu LOA_EINHEIT (Wenn FE, SO, SA = NULL, dann für alle Tage) ';

comment on column dirkspzm32.pzm_bereitschaft_cfg.value_fe is
    'Multiplikator für Feiertag von EINHEIT zu LOA_EINHEIT';

comment on column dirkspzm32.pzm_bereitschaft_cfg.value_sa is
    'Multiplikator für Samstag von EINHEIT zu LOA_EINHEIT';

comment on column dirkspzm32.pzm_bereitschaft_cfg.value_so is
    'Multiplikator für Sonntag von EINHEIT zu LOA_EINHEIT';


-- sqlcl_snapshot {"hash":"d2eab7b00576cc309fe80fae5e036de1827aa894","type":"COMMENT","name":"pzm_bereitschaft_cfg","schemaName":"dirkspzm32","sxml":""}