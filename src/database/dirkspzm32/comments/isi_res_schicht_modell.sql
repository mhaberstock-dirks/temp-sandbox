comment on table ISI_RES_SCHICHT_MODELL is 'Schicht Modell für Prod. Linien';
comment on column ISI_RES_SCHICHT_MODELL."ABZUG_PRODUKTIONS_ZEIT_SEK" is 'Anzahl Sekunden, die von der Produktionszeit abgezogen werden.';
comment on column ISI_RES_SCHICHT_MODELL."CREATED_DATE" is 'creation date+time of this dataset';
comment on column ISI_RES_SCHICHT_MODELL."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column ISI_RES_SCHICHT_MODELL."ENDE_TIME" is 'Uhrzeit Ende Schicht, Pause nur der Zeitwert ist relevant';
comment on column ISI_RES_SCHICHT_MODELL."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column ISI_RES_SCHICHT_MODELL."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column ISI_RES_SCHICHT_MODELL."PARENT_ID" is 'Bei Schicht_modell_type ''P'' mit Schicht_modell_id der Schicht besetzt. Bei ''S'' mit  Schicht_modell_id besetzt';
comment on column ISI_RES_SCHICHT_MODELL."PROD_TAKT_ID" is '->ISI_RES_PROD_TAKT.PROD_TAKT_ID verweiss auf die Taktvariante';
comment on column ISI_RES_SCHICHT_MODELL."SCHICHT_ENDE_VARIABEL" is '(T) )= Schichtende kann überzogen werden, wenn keine Folgeschicht folgt. (F''= Letzte Takt muss in Schicht passen.!';
comment on column ISI_RES_SCHICHT_MODELL."SCHICHT_MODELL_ID" is '[PK]';
comment on column ISI_RES_SCHICHT_MODELL."SCHICHT_MODELL_NAME" is '[UK] Name der Schicht, Pause';
comment on column ISI_RES_SCHICHT_MODELL."SCHICHT_MODELL_TYPE" is '(''S'' = Schicht , ''P'' = Pause';
comment on column ISI_RES_SCHICHT_MODELL."START_TIME" is 'Uhrzeit Beginn Schicht, Pause nur der Zeitwert ist relevant';
comment on column ISI_RES_SCHICHT_MODELL."STK_PRO_SCHICHT" is 'Plan Anzahl Stück Pro Schicht';
comment on column ISI_RES_SCHICHT_MODELL."TAKTE_PRO_SCHICHT" is 'Takte einer Schicht nach Abzug aller Pausen und ABZUG_PRODUKTIONS_ZEIT_SEK';
comment on column ISI_RES_SCHICHT_MODELL."TAKT_ZEIT_SEK" is 'TaktZeit in  Sekunden <> 0';
comment on column ISI_RES_SCHICHT_MODELL."WOCHEN_TAGE" is 'Wochentage mit Prod. (Mo;Di;Mi;Do;Fr;Sa;So;)';



-- sqlcl_snapshot {"hash":"d59dd5fb2ec9e01d8f9307188a011a19873da04a","type":"COMMENT","name":"isi_res_schicht_modell","schemaName":"dirkspzm32","sxml":""}