comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."AA_ID" is 'Mit welcher Abwesenheitsart wurde diese LOA gebucht';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."PASSIV_LOA" is 'T = keine Kontobuchungen ausführen, diese LOA is nur ein "Anhängsel"';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_AA_ID_ALT" is 'Alte Abwesenheitsart mit welcher die LOA gebucht wurde';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_DATUM" is 'Zeitpunkt der Lohnauswertung (Primary-Key)';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_KORR_DATUM" is 'Zeitpunkt der letzten Änderung';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_KORR_PERS_NR" is 'Personal-ID der die Änderung vorgenommen hat (Foreign-Key PZM_PERSONAL)';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_KST_ID" is 'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_LZ_ID" is 'ID Der Lohnart. Diese ID ist die referenz in der Lohnbuchhaltung';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_LZ_LOA_GRP" is 'Lohnauswertung Gruppe';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_LZ_LOA_STD" is 'Anzahl an Stunden';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_LZ_LOHNART" is 'Lohnart (Primary-Key)';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_PB_ID" is 'Eindeutige ID des Produktionsbereiches (Primary-Key)';
comment on column DIRKSPZM32.PZM_ZE_LOA_AUSW."ZEAW_PERS_NR" is 'zeaw = ZE Auswertung (Primary-Key)';



-- sqlcl_snapshot {"hash":"8556fa907f643ed5536b28b707c454cc4e2d793a","type":"COMMENT","name":"pzm_ze_loa_ausw","schemaName":"dirkspzm32","sxml":""}