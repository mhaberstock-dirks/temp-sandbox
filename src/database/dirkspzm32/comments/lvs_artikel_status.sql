comment on table LVS_ARTIKEL_STATUS is 'Aktueller Stautus der Artikel im Lager (z.B. Letzte Inventur)';
comment on column LVS_ARTIKEL_STATUS."AKT_INVENTUR_ID" is 'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR_JOB_KOPF';
comment on column LVS_ARTIKEL_STATUS."ARTIKEL_ID" is 'Artikel auf dem die Inventur durchgeführt wird/wurde';
comment on column LVS_ARTIKEL_STATUS."FA_AG" is 'Aktueller Arbeitsgang des Artikels, auf dem die Inventur durchgeführt wird/wurde';
comment on column LVS_ARTIKEL_STATUS."LETZTE_INVENTUR_DATUM" is 'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';
comment on column LVS_ARTIKEL_STATUS."LETZTE_INVENTUR_ID" is 'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';
comment on column LVS_ARTIKEL_STATUS."LETZTE_INVENTUR_LOGIN_ID" is 'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die letzte Inventur hier durchgeführt';



-- sqlcl_snapshot {"hash":"7e338d341d1ec3bb7bd81517c1596480d60946ef","type":"COMMENT","name":"lvs_artikel_status","schemaName":"dirkspzm32","sxml":""}