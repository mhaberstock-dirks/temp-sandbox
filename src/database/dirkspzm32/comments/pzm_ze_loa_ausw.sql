comment on column PZM_ZE_LOA_AUSW."AA_ID" is 'Mit welcher Abwesenheitsart wurde diese LOA gebucht';
comment on column PZM_ZE_LOA_AUSW."PASSIV_LOA" is 'T = keine Kontobuchungen ausführen, diese LOA is nur ein "Anhängsel"';
comment on column PZM_ZE_LOA_AUSW."ZEAW_AA_ID_ALT" is 'Alte Abwesenheitsart mit welcher die LOA gebucht wurde';
comment on column PZM_ZE_LOA_AUSW."ZEAW_DATUM" is 'Zeitpunkt der Lohnauswertung (Primary-Key)';
comment on column PZM_ZE_LOA_AUSW."ZEAW_KORR_DATUM" is 'Zeitpunkt der letzten Änderung';
comment on column PZM_ZE_LOA_AUSW."ZEAW_KORR_PERS_NR" is 'Personal-ID der die Änderung vorgenommen hat (Foreign-Key PZM_PERSONAL)';
comment on column PZM_ZE_LOA_AUSW."ZEAW_KST_ID" is 'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';
comment on column PZM_ZE_LOA_AUSW."ZEAW_LZ_ID" is 'ID Der Lohnart. Diese ID ist die referenz in der Lohnbuchhaltung';
comment on column PZM_ZE_LOA_AUSW."ZEAW_LZ_LOA_GRP" is 'Lohnauswertung Gruppe';
comment on column PZM_ZE_LOA_AUSW."ZEAW_LZ_LOA_STD" is 'Anzahl an Stunden';
comment on column PZM_ZE_LOA_AUSW."ZEAW_LZ_LOHNART" is 'Lohnart (Primary-Key)';
comment on column PZM_ZE_LOA_AUSW."ZEAW_PB_ID" is 'Eindeutige ID des Produktionsbereiches (Primary-Key)';
comment on column PZM_ZE_LOA_AUSW."ZEAW_PERS_NR" is 'zeaw = ZE Auswertung (Primary-Key)';



-- sqlcl_snapshot {"hash":"cc5e2b37a5e7f6657e06b1cb62e27d494c86c6c8","type":"COMMENT","name":"pzm_ze_loa_ausw","schemaName":"dirkspzm32","sxml":""}