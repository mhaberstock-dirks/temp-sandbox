comment on table DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG is 'KPI Persistierung für Reportind oder historische Betrachtung ';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."BUFFER_ANZAHL_WERTE" is 'Wie viele KPI-Werte sollen im Ring-Buffer gehalten werden. 0 = unendlich oder nur durch zeitliche Begrenzung';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."BUFFER_MAX_ZEIT_TAGE" is 'Wie viele Zeit in Tagen sollen im Ring-Buffer gehalten werden. 0 = unendlich oder nur max Anzahl Werte';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."CREATED_DATE" is 'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."CREATED_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz erstellt hat';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."ISI_KPI_ID" is 'Identifier Referenz zu ISI_KPI R4-DAL';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."KPI_NAME" is 'Name als Refenz zur Anzeigeposition im Dashboard ';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."KPI_SEL_PARAM" is 'Selektionsparameter um eine KPI für bestimmte Filggf. Kundenspezifisch einzutragen';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.ISI_KPI_RING_BUFFER_CFG."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"8accf8e08e71d4ba6be59217339ecd507ef735fb","type":"COMMENT","name":"isi_kpi_ring_buffer_cfg","schemaName":"dirkspzm32","sxml":""}