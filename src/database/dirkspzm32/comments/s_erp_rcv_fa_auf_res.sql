comment on table S_ERP_RCV_FA_AUF_RES is 'Vorgang-Maschinen Liste der möglichen maschinen mit Zeitbedarf';
comment on column S_ERP_RCV_FA_AUF_RES."AUF_ID" is 'eindeutige Sequenz-Nummer';
comment on column S_ERP_RCV_FA_AUF_RES."AUFTRAG" is 'Aufragsnummer (PLEIT)';
comment on column S_ERP_RCV_FA_AUF_RES."FA_AG" is 'Arbeitsgang / Vorgang zur Leitzahl';
comment on column S_ERP_RCV_FA_AUF_RES."FA_UPOS" is 'Unterposition für Gruppenarbeit (Split)';
comment on column S_ERP_RCV_FA_AUF_RES."FIRMA_NR" is 'Mandant z.B. 01';
comment on column S_ERP_RCV_FA_AUF_RES."LEITZAHL" is 'Leitzahl aus DIAF (KLEIT)';
comment on column S_ERP_RCV_FA_AUF_RES."MASCHINE" is 'Eindeutiger Maschinen ID Z.B. M36';
comment on column S_ERP_RCV_FA_AUF_RES."MINUTEN" is 'Zeitbedarf für Auftrag auf dieser Maschine in Minuten';
comment on column S_ERP_RCV_FA_AUF_RES."MINUTEN_RUESTEN" is 'Zeitbedarf für Rüsten auf dieser Maschine in Minuten';
comment on column S_ERP_RCV_FA_AUF_RES."SATZART" is '"V" Verrichten, "MA" = Materialanforderung, "VA" = Verrichten Auswäts, "VR" = Verrichten Rüsten';



-- sqlcl_snapshot {"hash":"167f0eda5b1aad53103c3aedfa10adc34eba397f","type":"COMMENT","name":"s_erp_rcv_fa_auf_res","schemaName":"dirkspzm32","sxml":""}