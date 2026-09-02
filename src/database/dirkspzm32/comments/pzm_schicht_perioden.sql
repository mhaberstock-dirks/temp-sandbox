comment on table PZM_SCHICHT_PERIODEN is 'Die Schichtperioden stellen die Verbindung von den Schichtmodelle zu den Schichtarten da';
comment on column PZM_SCHICHT_PERIODEN."CREATED_DATE" is 'Datum Erstellt';
comment on column PZM_SCHICHT_PERIODEN."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column PZM_SCHICHT_PERIODEN."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column PZM_SCHICHT_PERIODEN."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column PZM_SCHICHT_PERIODEN."SP_GES_STD_PRO_WO" is 'Gestammtstunden pro Woche';
comment on column PZM_SCHICHT_PERIODEN."SP_SA_WOT_DI" is 'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';
comment on column PZM_SCHICHT_PERIODEN."SP_SA_WOT_DO" is 'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';
comment on column PZM_SCHICHT_PERIODEN."SP_SA_WOT_FR" is 'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';
comment on column PZM_SCHICHT_PERIODEN."SP_SA_WOT_MI" is 'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';
comment on column PZM_SCHICHT_PERIODEN."SP_SA_WOT_MO" is 'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';
comment on column PZM_SCHICHT_PERIODEN."SP_SA_WOT_SA" is 'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';
comment on column PZM_SCHICHT_PERIODEN."SP_SA_WOT_SO" is 'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';
comment on column PZM_SCHICHT_PERIODEN."SP_SM_NAME" is 'Schichtperiode Name (Primary-Key)';
comment on column PZM_SCHICHT_PERIODEN."SP_WOCHE_NR" is 'Schichtperiode-ID (Primary-Key)';



-- sqlcl_snapshot {"hash":"29de61cf3026e31e0cf1bfb14f67d02434560ad3","type":"COMMENT","name":"pzm_schicht_perioden","schemaName":"dirkspzm32","sxml":""}