comment on table DIRKSPZM32.PZM_ABT_LEITUNG is 'Relation Abteilung zur PERS_NR der Leitung und deren Funktion';
comment on column DIRKSPZM32.PZM_ABT_LEITUNG."ABT_L_ABT_ID" is 'Abteilung-ID (Primary Key)';
comment on column DIRKSPZM32.PZM_ABT_LEITUNG."ABT_L_BIS_DATUM" is 'Leiter/Vertreter Funktion bis zu diesem Datum ';
comment on column DIRKSPZM32.PZM_ABT_LEITUNG."ABT_L_FUNKTION" is 'Funktion: G = Geschäftsleitung/Geschäftsführer, L = Leiter, V = Vertreter';
comment on column DIRKSPZM32.PZM_ABT_LEITUNG."ABT_L_PERS_NR" is 'Personal-ID des Abteilungsleiter (Primary Key) (Foreign-Key PZM_PERSONAL)';
comment on column DIRKSPZM32.PZM_ABT_LEITUNG."ABT_L_VON_DATUM" is 'Leiter/Vertreter Funktion ab diesen Datum ';
comment on column DIRKSPZM32.PZM_ABT_LEITUNG."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_ABT_LEITUNG."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_ABT_LEITUNG."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_ABT_LEITUNG."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';



-- sqlcl_snapshot {"hash":"b77a604fdd206726707d671ac3a161f0ff8e86be","type":"COMMENT","name":"pzm_abt_leitung","schemaName":"dirkspzm32","sxml":""}