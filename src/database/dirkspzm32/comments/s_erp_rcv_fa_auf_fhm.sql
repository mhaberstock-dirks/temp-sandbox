comment on table DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM is 'Vorgang-Maschinen Liste der möglichen maschinen mit Zeitbedarf';
comment on column DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM."AUFTRAG" is 'Aufragsnummer (PLEIT)';
comment on column DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM."AUF_ID" is 'eindeutige Sequenz-Nummer';
comment on column DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM."FA_AG" is 'Arbeitsgang / Vorgang zur Leitzahl';
comment on column DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM."FA_UPOS" is 'Unterposition für Gruppenarbeit';
comment on column DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM."FHM_GRP" is 'Gruppe (Ein FHM aus leitzahl/fa_ag/fa_upos muss auf der maschine verfügbar sein)';
comment on column DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM."LEITZAHL" is 'Leitzahl aus DIAF (KLEIT)';
comment on column DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM."PROD_FHM" is 'Benötigtes FHM';
comment on column DIRKSPZM32.S_ERP_RCV_FA_AUF_FHM."RUEST_ZEIT" is 'Rüstzeit für den Einbau und Ausbau';



-- sqlcl_snapshot {"hash":"bf71e2b12e0b1118d35c749ee95bf2927221e723","type":"COMMENT","name":"s_erp_rcv_fa_auf_fhm","schemaName":"dirkspzm32","sxml":""}