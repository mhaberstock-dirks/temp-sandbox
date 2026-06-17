comment on table DIRKSPZM32.PZM_KONTEN_BH is 'Buchungshistorie der PZM Konten';
comment on column DIRKSPZM32.PZM_KONTEN_BH."ABT_ID" is 'ID der Abteilung';
comment on column DIRKSPZM32.PZM_KONTEN_BH."BUCH_DATUM" is 'Datum der Buchung';
comment on column DIRKSPZM32.PZM_KONTEN_BH."BUS" is 'Buchungsschlüssel (1 = Zugang [haben], 2 = Abgang [soll], 3 = Zugang storniert, 4 = Abgang storniert)';
comment on column DIRKSPZM32.PZM_KONTEN_BH."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_KONTEN_BH."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_KONTEN_BH."CREATED_USER" is 'User - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_KONTEN_BH."EINHEIT" is 'Einheit der Buchung (HH24 =Stunden , DD= Tage)';
comment on column DIRKSPZM32.PZM_KONTEN_BH."FIRMA_NR" is 'Firmennummer standortsbezogen z.B. Standort1 = 1, Standort2 = 2 (Primary-Key)';
comment on column DIRKSPZM32.PZM_KONTEN_BH."INFO" is 'Infotext';
comment on column DIRKSPZM32.PZM_KONTEN_BH."KONTEN_BH_ID" is 'Buchungs-ID';
comment on column DIRKSPZM32.PZM_KONTEN_BH."KONTO_NR" is 'Kontonummer für künftige Referenzen (Primary-Key)';
comment on column DIRKSPZM32.PZM_KONTEN_BH."KST_ID" is 'Kostenstelle';
comment on column DIRKSPZM32.PZM_KONTEN_BH."PERS_NR" is 'Personal-ID (PZM_PERSONAL !!! Nicht als Foreign-Key definiert !!!)';
comment on column DIRKSPZM32.PZM_KONTEN_BH."SID" is 'ID (Primary-Key)';
comment on column DIRKSPZM32.PZM_KONTEN_BH."STORNO_KONTEN_BH_ID" is 'Buchungs ID, die Storniert wurde';
comment on column DIRKSPZM32.PZM_KONTEN_BH."TYP" is 'B = normale Buchung, S = Stornobuchung (Buchung rückgängig), G = manuelle Gutschrift, K = Korrektur';
comment on column DIRKSPZM32.PZM_KONTEN_BH."WERT" is 'Wert dessen Einheit sich auf EINHEIT bezieht';
comment on column DIRKSPZM32.PZM_KONTEN_BH."ZK_AA_ID" is 'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';
comment on column DIRKSPZM32.PZM_KONTEN_BH."ZK_START" is 'Start der Abwesenheit im Bezug auf die Abwesenheitsart';



-- sqlcl_snapshot {"hash":"4baf1f855137e222276989ec7976ab7a0e93837d","type":"COMMENT","name":"pzm_konten_bh","schemaName":"dirkspzm32","sxml":""}