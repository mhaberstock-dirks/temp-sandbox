comment on table DIRKSPZM32.PZM_BEREITSCHAFT_CFG is 'ID Der Bereitschafttskonfiguration. Diese ID ist die referenz für die erzeugung der LOAs';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."BEREITSCHAFT_CFG" is 'ID Der Bereitschafttskonfiguration. Diese ID ist die referenz für die erzeugung der LOAs';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."CREATED_USER" is 'User - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."EINHEIT" is 'Einheit (HH24, DD, ..)  für Wochentag (Wenn FE, SO, SA = NULL, dann für alle Tage)';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."LAST_CHANGE_USER" is 'User - er hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."LOA_EINHEIT" is 'Einhet für die LOA für die Übergabe an die Lohnbuchhaltung';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."LOA_ID" is 'LOA für Wochentag (Wenn FE, SO, SA = NULL, dann für alle Tage)';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."LOA_ID_FE" is 'LOA für Feiertage';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."LOA_ID_SA" is 'LOA für Samstag';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."LOA_ID_SO" is 'LOA für Sonntag';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."VALUE" is 'Multiplikator für Wochentag von EINHEIT zu LOA_EINHEIT (Wenn FE, SO, SA = NULL, dann für alle Tage) ';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."VALUE_FE" is 'Multiplikator für Feiertag von EINHEIT zu LOA_EINHEIT';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."VALUE_SA" is 'Multiplikator für Samstag von EINHEIT zu LOA_EINHEIT';
comment on column DIRKSPZM32.PZM_BEREITSCHAFT_CFG."VALUE_SO" is 'Multiplikator für Sonntag von EINHEIT zu LOA_EINHEIT';



-- sqlcl_snapshot {"hash":"463a3703c0612c9aaa23149498a8949a735f13e1","type":"COMMENT","name":"pzm_bereitschaft_cfg","schemaName":"dirkspzm32","sxml":""}