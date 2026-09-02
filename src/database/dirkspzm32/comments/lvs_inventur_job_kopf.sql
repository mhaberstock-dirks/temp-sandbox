comment on table LVS_INVENTUR_JOB_KOPF is 'Inventur Kopf Tabelle';
comment on column LVS_INVENTUR_JOB_KOPF."ERSTELLT_DATUM" is 'Wann wurde dieser Inventur-Job erstellt';
comment on column LVS_INVENTUR_JOB_KOPF."ERSTELLT_LOGIN_ID" is 'Von wem wurde dieser Inventur-Job erstellt';
comment on column LVS_INVENTUR_JOB_KOPF."INFO" is 'Beschreibung für den Inventur-Job';
comment on column LVS_INVENTUR_JOB_KOPF."INV_STATUS" is '''N''eu, ''V''orbereitet, ''I''nventur läuft, ''F''ertig, ''A''bgebrochen';
comment on column LVS_INVENTUR_JOB_KOPF."INV_TYPE" is 'KOMPL_LGR_ORT, LGR_PLATZ, ARTIKEL, ...';
comment on column LVS_INVENTUR_JOB_KOPF."IST_ENDE_DATUM" is 'Wann wurde dieser Inventur-Job beendet';
comment on column LVS_INVENTUR_JOB_KOPF."IST_ENDE_LOGIN_ID" is 'Von wem wurde dieser Inventur-Job beendet';
comment on column LVS_INVENTUR_JOB_KOPF."IST_START_DATUM" is 'Wann wurde dieser Inventur-Job gestartet';
comment on column LVS_INVENTUR_JOB_KOPF."IST_START_LOGIN_ID" is 'Von wem wurde dieser Inventur-Job gestartet';
comment on column LVS_INVENTUR_JOB_KOPF."LGR_ORT" is 'Lagerort, in dem die Inventur gemacht wird';
comment on column LVS_INVENTUR_JOB_KOPF."SOLL_START_DATUM" is 'Wann soll dieser Inventur-Job starten';



-- sqlcl_snapshot {"hash":"bf481e0835d96c5e640b2b80de70a4487b301c3d","type":"COMMENT","name":"lvs_inventur_job_kopf","schemaName":"dirkspzm32","sxml":""}