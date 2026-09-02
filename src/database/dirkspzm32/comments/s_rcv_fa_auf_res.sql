comment on table S_RCV_FA_AUF_RES is 'Vorgang-Maschinen';
comment on column S_RCV_FA_AUF_RES."AUF_ID" is 'eindeutige Sequenz-Nummer';
comment on column S_RCV_FA_AUF_RES."AUFTRAG" is 'Aufragsnummer (PLEIT)';
comment on column S_RCV_FA_AUF_RES."FA_AG" is 'Arbeitsgang / Vorgang zur Leitzahl';
comment on column S_RCV_FA_AUF_RES."FA_UPOS" is 'Unterposition für Gruppenarbeit (Split)';
comment on column S_RCV_FA_AUF_RES."FIRMA_NR" is 'Mandant z.B. 01';
comment on column S_RCV_FA_AUF_RES."LEITZAHL" is 'Leitzahl aus DIAF (KLEIT)';
comment on column S_RCV_FA_AUF_RES."MINUTEN" is 'Zeitbedarf für Auftrag auf dieser Maschine in Minuten';
comment on column S_RCV_FA_AUF_RES."MINUTEN_RUESTEN" is 'Zeitbedarf für Rüsten auf dieser Maschine in Minuten';
comment on column S_RCV_FA_AUF_RES."RES_ID" is 'Maschinen ID aus der Resourcentabelle';
comment on column S_RCV_FA_AUF_RES."SATZART" is '"V" Verrichten, "MA" = Materialanforderung, "VA" = Verrichten Auswäts, "VR" = Verrichten Rüsten
';



-- sqlcl_snapshot {"hash":"a467342d1f0f8792826e46f2e29f9d5068502ca2","type":"COMMENT","name":"s_rcv_fa_auf_res","schemaName":"dirkspzm32","sxml":""}