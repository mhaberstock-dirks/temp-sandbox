comment on table S_ERP_RCV_FA_AUF_FHM is 'Vorgang-Maschinen Liste der möglichen maschinen mit Zeitbedarf';
comment on column S_ERP_RCV_FA_AUF_FHM."AUF_ID" is 'eindeutige Sequenz-Nummer';
comment on column S_ERP_RCV_FA_AUF_FHM."AUFTRAG" is 'Aufragsnummer (PLEIT)';
comment on column S_ERP_RCV_FA_AUF_FHM."FA_AG" is 'Arbeitsgang / Vorgang zur Leitzahl';
comment on column S_ERP_RCV_FA_AUF_FHM."FA_UPOS" is 'Unterposition für Gruppenarbeit';
comment on column S_ERP_RCV_FA_AUF_FHM."FHM_GRP" is 'Gruppe (Ein FHM aus leitzahl/fa_ag/fa_upos muss auf der maschine verfügbar sein)';
comment on column S_ERP_RCV_FA_AUF_FHM."FIRMA_NR" is 'Mandant z.B. 01';
comment on column S_ERP_RCV_FA_AUF_FHM."LEITZAHL" is 'Leitzahl aus DIAF (KLEIT)';
comment on column S_ERP_RCV_FA_AUF_FHM."PROD_FHM" is 'Benötigtes FHM';
comment on column S_ERP_RCV_FA_AUF_FHM."RUEST_ZEIT" is 'Rüstzeit für den Einbau und Ausbau';



-- sqlcl_snapshot {"hash":"639bf6fee93743f20e90b815498553377241d203","type":"COMMENT","name":"s_erp_rcv_fa_auf_fhm","schemaName":"dirkspzm32","sxml":""}