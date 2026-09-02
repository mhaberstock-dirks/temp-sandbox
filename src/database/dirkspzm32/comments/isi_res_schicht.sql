comment on table ISI_RES_SCHICHT is 'Schicht einer Produktionslinie';
comment on column ISI_RES_SCHICHT."ABZUG_PRODUKTIONS_ZEIT_SEK" is 'Anzahl Sekunden, die von der Produktionszeit abgezogen werden.';
comment on column ISI_RES_SCHICHT."CREATED_DATE" is 'creation date+time of this dataset';
comment on column ISI_RES_SCHICHT."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column ISI_RES_SCHICHT."ENDE_DATE_TIME" is 'Ende der  Schicht, Pause';
comment on column ISI_RES_SCHICHT."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column ISI_RES_SCHICHT."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column ISI_RES_SCHICHT."PARENT_ID" is 'Bei Schicht_type ''P'' mit Schicht_id der Schicht besetzt. Bei ''S'' mit  Schicht_id besetzt';
comment on column ISI_RES_SCHICHT."PROD_TAKT_ID" is '->ISI_RES_PROD_TAKT.PROD_TAKT_ID verweiss auf die Taktvariante';
comment on column ISI_RES_SCHICHT."RES_ID" is '[->ISI_RESOURCE.RES_ID] Schicht gilt für Produktionslinie ';
comment on column ISI_RES_SCHICHT."SCHICHT_ENDE_VARIABEL" is '(T) )= Schichtende kann überzogen werden, wenn keine Folgeschicht folgt. (F''= Letzte Takt muss in Schicht passen.!';
comment on column ISI_RES_SCHICHT."SCHICHT_ID" is '[PK]';
comment on column ISI_RES_SCHICHT."SCHICHT_NAME" is 'Name der Schicht, Pause';
comment on column ISI_RES_SCHICHT."SCHICHT_TYPE" is '(''S'' = Schicht , ''P'' = Pause';
comment on column ISI_RES_SCHICHT."SOLL_TAKTE_PRO_SCHICHT" is 'Takte einer Schicht nach Abzug aller Pausen und ABZUG_PRODUKTIONS_ZEIT_SEK';
comment on column ISI_RES_SCHICHT."START_DATE_TIME" is 'Begin der  Schicht, Pause';
comment on column ISI_RES_SCHICHT."STATUS" is '''N''eu , ''U''  Ubertragen in SPS , ''B''egonnen. ''F'' ertig';
comment on column ISI_RES_SCHICHT."TAKT_ZEIT_SEK" is 'TaktZeit in  Sekunden <> 0';



-- sqlcl_snapshot {"hash":"b9a6372018b5c0f7737c14d920d8c655d8c2a319","type":"COMMENT","name":"isi_res_schicht","schemaName":"dirkspzm32","sxml":""}