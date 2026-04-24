comment on table dirkspzm32.z_pzm_pers_stempelzeiten is
    'Personlastamm Übernahme Stempelzeitzen';

comment on column dirkspzm32.z_pzm_pers_stempelzeiten.geht is
    'Gehtzeit dd.mm.yyyy hh24:mi:ss';

comment on column dirkspzm32.z_pzm_pers_stempelzeiten.gt_ut is
    'GT=Gleittag UT=Urlaubstag';

comment on column dirkspzm32.z_pzm_pers_stempelzeiten.kommt is
    'Kommtzeit dd.mm.yyyy hh24:mi:ss';

comment on column dirkspzm32.z_pzm_pers_stempelzeiten.pers_nr is
    'Personalnummer des Benutzers (Bei integriertem PZM wir die Personalnumme und die Kontaktdaten von PZM übersteuert (Trigger im PZM)'
    ;


-- sqlcl_snapshot {"hash":"e7f4f94cd971e1e5df0c4ef4af42b0d4fdc1daaa","type":"COMMENT","name":"z_pzm_pers_stempelzeiten","schemaName":"dirkspzm32","sxml":""}