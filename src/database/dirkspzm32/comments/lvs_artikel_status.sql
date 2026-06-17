comment on table DIRKSPZM32.LVS_ARTIKEL_STATUS is 'Aktueller Stautus der Artikel im Lager (z.B. Letzte Inventur)';
comment on column DIRKSPZM32.LVS_ARTIKEL_STATUS."AKT_INVENTUR_ID" is 'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR_JOB_KOPF';
comment on column DIRKSPZM32.LVS_ARTIKEL_STATUS."ARTIKEL_ID" is 'Artikel auf dem die Inventur durchgeführt wird/wurde';
comment on column DIRKSPZM32.LVS_ARTIKEL_STATUS."FA_AG" is 'Aktueller Arbeitsgang des Artikels, auf dem die Inventur durchgeführt wird/wurde';
comment on column DIRKSPZM32.LVS_ARTIKEL_STATUS."LETZTE_INVENTUR_DATUM" is 'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';
comment on column DIRKSPZM32.LVS_ARTIKEL_STATUS."LETZTE_INVENTUR_ID" is 'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';
comment on column DIRKSPZM32.LVS_ARTIKEL_STATUS."LETZTE_INVENTUR_LOGIN_ID" is 'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die letzte Inventur hier durchgeführt';



-- sqlcl_snapshot {"hash":"6595c6fc0b2068e9882d64755c6a5460a43cdd8f","type":"COMMENT","name":"lvs_artikel_status","schemaName":"dirkspzm32","sxml":""}