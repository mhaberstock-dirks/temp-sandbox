comment on table dirkspzm32.z_pzm_pers_urlaub_flexkonto is
    'Personlastamm Übernahme Resturlaub uns Flex-Stunden';

comment on column dirkspzm32.z_pzm_pers_urlaub_flexkonto.pers_name is
    'Name des Mitarbeiters';

comment on column dirkspzm32.z_pzm_pers_urlaub_flexkonto.pers_nr is
    'Personalnummer des Benutzers (Bei integriertem PZM wir die Personalnumme und die Kontaktdaten von PZM übersteuert (Trigger im PZM)'
    ;

comment on column dirkspzm32.z_pzm_pers_urlaub_flexkonto.zk_flex_std is
    'Flexstunden in hh:mi';

comment on column dirkspzm32.z_pzm_pers_urlaub_flexkonto.zk_urlaub_tage is
    'Resturlaub';


-- sqlcl_snapshot {"hash":"9b84531e4a6a5e76de02e3e4407f18f4bbf8881d","type":"COMMENT","name":"z_pzm_pers_urlaub_flexkonto","schemaName":"dirkspzm32","sxml":""}