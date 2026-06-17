comment on table DIRKSPZM32.PZM_SCHICHT_MODELLE is 'Schichtmodelle - Enthalten Basisinformationen des Schichtmodells und die Anzahl der Wochen der Schichtperioden';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."BEGINN_GUTSCHR_MIN" is 'Pauschalgutschrift in Minuten für Kommen am Anfang des Schichttags (z.B. PC starten, etc.)';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."CALC_BASIS" is 'FESTZ = feste Zeiten, GLEITZ = Gleitzeit (std_pro_tag is die Basis)';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."D_ARB_STD_PRO_TAG" is 'Durchschnittliche Arbeitszeit pro Tag in diesem Schichtmodell (erf. für Urlaubsberechnung in Std.)';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."ENDE_GUTSCHR_MIN" is 'Pauschalgutschrift in Minuten für Gehen am Ende des Schichttags (z.B. PC herunterfahren, etc.)';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."FLEX_MAX_STD_PRO_WOCHE" is 'Maximal flexible stunden pro Woche (alles was mehr in der Woche ist, wird als Überstd. gewertet)';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."KAPPUNG_ME_AB_FLX_STD" is 'ME = Monatsende, NULL oder 0 bedeutet, dass keine Kappung durchgefuehrt wird, es sei denn, es ist im Personalstamm hinterlegt';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."KAPPUNG_SCHICHT_ENDE" is 'Darf das Schichtende (Überstunden) gekappt werden (F  = False, T = True)';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."KAPPUNG_TE_AB_FLX_STD" is 'TE = Tagesende';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."RASTERMIN" is 'In diesem raster wird für dies Schichtmodell die Zeit gerechnet.';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."SM_ANZ_WOCHEN" is 'Anzahl an Wochen';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."SM_KURZNAME" is 'Kurzname des Schichtmodels';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."SM_NAME" is 'Name des Schichtmodels (Primary-Key)';
comment on column DIRKSPZM32.PZM_SCHICHT_MODELLE."STANDARD_AA_ID" is 'Standard Abwesenheitsart für dieses Schichtmodell (übersteuert die globale Standard Abweseheitsart)';



-- sqlcl_snapshot {"hash":"0f8eebe5249ba1403023b938650c7524c166e746","type":"COMMENT","name":"pzm_schicht_modelle","schemaName":"dirkspzm32","sxml":""}