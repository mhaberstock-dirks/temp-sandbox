comment on table dirkspzm32.lvs_artikel_status is
    'Aktueller Stautus der Artikel im Lager (z.B. Letzte Inventur)';

comment on column dirkspzm32.lvs_artikel_status.akt_inventur_id is
    'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR_JOB_KOPF';

comment on column dirkspzm32.lvs_artikel_status.artikel_id is
    'Artikel auf dem die Inventur durchgeführt wird/wurde';

comment on column dirkspzm32.lvs_artikel_status.fa_ag is
    'Aktueller Arbeitsgang des Artikels, auf dem die Inventur durchgeführt wird/wurde';

comment on column dirkspzm32.lvs_artikel_status.letzte_inventur_datum is
    'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';

comment on column dirkspzm32.lvs_artikel_status.letzte_inventur_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';

comment on column dirkspzm32.lvs_artikel_status.letzte_inventur_login_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die letzte Inventur hier durchgeführt';


-- sqlcl_snapshot {"hash":"46f3d12341d73d09b04b74c9d3199020a5c546a9","type":"COMMENT","name":"lvs_artikel_status","schemaName":"dirkspzm32","sxml":""}