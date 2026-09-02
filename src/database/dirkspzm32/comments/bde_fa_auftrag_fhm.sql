comment on table BDE_FA_AUFTRAG_FHM is 'Fertigungshilfsmittel-Liste für diesen AG im Planauftrag';
comment on column BDE_FA_AUFTRAG_FHM."ABNR" is 'Eindeutige Nummer aus SEQ';
comment on column BDE_FA_AUFTRAG_FHM."ANZ_BENOETIGT" is 'wieviele FHMs belegt dieser Vorgang auf einem Fertigungshilfsmittel [Gantt rechnet hier in %] - Die tatsächliche Belegung wird auf ganze Zahlen abgerundet';
comment on column BDE_FA_AUFTRAG_FHM."FA_AG" is 'FA Arbeitsgang, für den dieses FHM benötigt wird';
comment on column BDE_FA_AUFTRAG_FHM."FA_UPOS" is 'FA Unterposition bzw Arbeitsgang';
comment on column BDE_FA_AUFTRAG_FHM."FHM_GRP" is 'Gruppe (Ein FHM aus leitzahl/fa_ag/fa_upos muss auf der maschine verfügbar sein)';
comment on column BDE_FA_AUFTRAG_FHM."FIRMA_NR" is 'Firma Nr.';
comment on column BDE_FA_AUFTRAG_FHM."LEITZAHL" is 'Auftragsnummer aus PPS_PLAN_AUFTRAG';
comment on column BDE_FA_AUFTRAG_FHM."PROD_FHM" is 'Benötigtes FHM / Alternative im Arbeitsgang';
comment on column BDE_FA_AUFTRAG_FHM."SID" is 'SID';



-- sqlcl_snapshot {"hash":"677068fcb2e5e9ec9c684c4a3ff412ff9ba3826c","type":"COMMENT","name":"bde_fa_auftrag_fhm","schemaName":"dirkspzm32","sxml":""}