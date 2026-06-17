comment on table DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE is 'Tabelle für die Einträge (Einzel-Stemplungen)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."KORR_ZE_AKTION" is 'Ablage des original Wertes aus dem Terminal. Nutzbar bei manueller Korrektur.';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."PERS_NR" is 'Ermittelte Pers-Nr. zu der gebuchten RFID, wenn verfuegbar.';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."QUELLE" is 'Quelle der Buchung (z.B. ''LIVE'', ''APP'', ''TERMINAL'', ''MANUELL'', ''SYSTEM'')';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_AKTION" is 'Aktion K=Kommen, G=gehen, D=Dienstgang, P=Pause, BDE=BDE (Bookingtype)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_DATUM" is 'Datum des Eintrags';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_FA_AG" is 'Arbeitsgang (Operation)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_FA_AUFTRAG" is 'Fertigungsauftrag erste Scannung (ProdOrder)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_GERAET" is 'Geräte oder Arbeitsplatz-ID (Seriennummer des Terminals)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_GERAET_INFO" is 'Name, optionale Pos. Info des Terminals, wenn verfuegbar';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_ID" is 'Zugeordnete ID aus PZM_ZEITERFASSUNG, wenn die Verbuchung erfolgreich war. Fuer historische Nachverfolgbarkeit';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_RET_CODE" is '0 = OK, sonst Fehlercode';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_RET_MSG" is 'Status/Fehlertext der Übertragung';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_RFID" is 'RF-ID-Chip (Transponder)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_TIMEZONE_NAME" is 'IANA based timezone name';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG_EINTRAEGE."ZE_TRANSFER_STATUS" is 'Transfer-Status N=Neu, U=In Übetragung, UE=Übetragen(Fertig), ERR=Fehler';



-- sqlcl_snapshot {"hash":"c45fe0f985d01f316848ec9a75e6f7ad10143552","type":"COMMENT","name":"pzm_zeiterfassung_eintraege","schemaName":"dirkspzm32","sxml":""}