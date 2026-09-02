comment on table PE_JOBS is 'Druckjobs für die Print Engine';
comment on column PE_JOBS."ANZAHL" is 'Anzahl der Ausdrucke';
comment on column PE_JOBS."JOB_DATEN_TYP" is 'PV-LIST (Param-Value [TStrings]); SQL; REP';
comment on column PE_JOBS."STATUS" is 'N (neu); D (am drucken); OK (erledigt); ERR (Fehler);';
comment on column PE_JOBS."STATUS_TEXT" is 'Zusatzinformation zum Status als Klartext';



-- sqlcl_snapshot {"hash":"6d6a23cffb95c444901d9d4e72c66bd1f854fc35","type":"COMMENT","name":"pe_jobs","schemaName":"dirkspzm32","sxml":""}