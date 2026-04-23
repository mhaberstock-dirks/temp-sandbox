comment on table dirkspzm32.pe_jobs is
    'Druckjobs für die Print Engine';

comment on column dirkspzm32.pe_jobs.anzahl is
    'Anzahl der Ausdrucke';

comment on column dirkspzm32.pe_jobs.job_daten_typ is
    'PV-LIST (Param-Value [TStrings]); SQL; REP';

comment on column dirkspzm32.pe_jobs.status is
    'N (neu); D (am drucken); OK (erledigt); ERR (Fehler);';

comment on column dirkspzm32.pe_jobs.status_text is
    'Zusatzinformation zum Status als Klartext';


-- sqlcl_snapshot {"hash":"a9036b6a94986ceb95e23c3f528825c621499039","type":"COMMENT","name":"pe_jobs","schemaName":"dirkspzm32","sxml":""}