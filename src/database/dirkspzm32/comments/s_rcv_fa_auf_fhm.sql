comment on table DIRKSPZM32.S_RCV_FA_AUF_FHM is 'Vorgang-Maschinen';
comment on column DIRKSPZM32.S_RCV_FA_AUF_FHM."ANZ_BENOETIGT" is 'wieviele FHMs belegt dieser Vorgang auf einem Fertigungshilfsmittel [Gantt rechnet hier in %] - Die tatsächliche Belegung wird auf ganze Zahlen abgerundet';
comment on column DIRKSPZM32.S_RCV_FA_AUF_FHM."AUFTRAG" is 'Aufragsnummer (PLEIT)';
comment on column DIRKSPZM32.S_RCV_FA_AUF_FHM."AUF_ID" is 'eindeutige Sequenz-Nummer';
comment on column DIRKSPZM32.S_RCV_FA_AUF_FHM."FA_AG" is 'Arbeitsgang / Vorgang zur Leitzahl';
comment on column DIRKSPZM32.S_RCV_FA_AUF_FHM."FA_UPOS" is 'Unterposition für Gruppenarbeit Split';
comment on column DIRKSPZM32.S_RCV_FA_AUF_FHM."FHM_GRP" is 'Gruppe (Ein FHM aus leitzahl/fa_ag/fa_upos muss auf der maschine verfügbar sein)';
comment on column DIRKSPZM32.S_RCV_FA_AUF_FHM."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.S_RCV_FA_AUF_FHM."LEITZAHL" is 'Leitzahl aus DIAF (KLEIT)';
comment on column DIRKSPZM32.S_RCV_FA_AUF_FHM."PROD_FHM" is 'Benötigtes FHM';



-- sqlcl_snapshot {"hash":"a96e419735510872a7e41664fc62dc95f3a02e78","type":"COMMENT","name":"s_rcv_fa_auf_fhm","schemaName":"dirkspzm32","sxml":""}