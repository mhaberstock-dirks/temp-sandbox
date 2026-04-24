comment on table dirkspzm32.lvs_inventur_job_kopf is
    'Inventur Kopf Tabelle';

comment on column dirkspzm32.lvs_inventur_job_kopf.erstellt_datum is
    'Wann wurde dieser Inventur-Job erstellt';

comment on column dirkspzm32.lvs_inventur_job_kopf.erstellt_login_id is
    'Von wem wurde dieser Inventur-Job erstellt';

comment on column dirkspzm32.lvs_inventur_job_kopf.info is
    'Beschreibung für den Inventur-Job';

comment on column dirkspzm32.lvs_inventur_job_kopf.inv_status is
    '''N''eu, ''V''orbereitet, ''I''nventur läuft, ''F''ertig, ''A''bgebrochen';

comment on column dirkspzm32.lvs_inventur_job_kopf.inv_type is
    'KOMPL_LGR_ORT, LGR_PLATZ, ARTIKEL, ...';

comment on column dirkspzm32.lvs_inventur_job_kopf.ist_ende_datum is
    'Wann wurde dieser Inventur-Job beendet';

comment on column dirkspzm32.lvs_inventur_job_kopf.ist_ende_login_id is
    'Von wem wurde dieser Inventur-Job beendet';

comment on column dirkspzm32.lvs_inventur_job_kopf.ist_start_datum is
    'Wann wurde dieser Inventur-Job gestartet';

comment on column dirkspzm32.lvs_inventur_job_kopf.ist_start_login_id is
    'Von wem wurde dieser Inventur-Job gestartet';

comment on column dirkspzm32.lvs_inventur_job_kopf.lgr_ort is
    'Lagerort, in dem die Inventur gemacht wird';

comment on column dirkspzm32.lvs_inventur_job_kopf.soll_start_datum is
    'Wann soll dieser Inventur-Job starten';


-- sqlcl_snapshot {"hash":"b431061c00eeef2fb7927a8e214faf81366aef2e","type":"COMMENT","name":"lvs_inventur_job_kopf","schemaName":"dirkspzm32","sxml":""}