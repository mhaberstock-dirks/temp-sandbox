comment on table DIRKSPZM32.LVS_SERIE_ID_KOPF is 'Header Tabelle für die generierung von Serien';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."ABNR" is 'Auftrag Bestätigungsnummer (PLEIT) oder Batch';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."LEITZAHL" is 'Leitzahl des Fertigungsauftrags (KLEIT)';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."SERIE_EXTERN_MASKE" is 'Maske der externen Seriennummer aus Kopf. @@@ Wird mit LFDN ersetzt';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."SERIE_EXTERN_START_ID" is 'Erste ID in der Serie';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."SERIE_GEN_RICHTUNG" is 'Vorgabe ob die Serie Absteigend (AB) oder Aufsteigend (AU) generiert werden soll';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."SERIE_ID" is 'ID Der Serie';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."SERIE_MASKE" is 'Format Vorlage nach der die ID generiert wird. @ Zeichen werden durch die laufende Nummer ersetzt';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."SERIE_MENGE" is 'Menge des Artikels die in den Fertigungsauftrag produziert werden muss';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."SERIE_START_ID" is 'Erste ID in der Serie';
comment on column DIRKSPZM32.LVS_SERIE_ID_KOPF."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"73b3549c8abef27779c193488fb2e48e33bbecc0","type":"COMMENT","name":"lvs_serie_id_kopf","schemaName":"dirkspzm32","sxml":""}