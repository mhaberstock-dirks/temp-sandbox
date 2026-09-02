comment on table Z_PZM_PERS_SONST_KONTO is 'Personlastamm Übernahme sonstige Konten';
comment on column Z_PZM_PERS_SONST_KONTO."KONTO_KURZ_NAME" is 'Konto Name -- z.B. BK Brückentagszeitkonto';
comment on column Z_PZM_PERS_SONST_KONTO."KONTO_SALDO" is 'Zu buchende Salo auf das Konto';
comment on column Z_PZM_PERS_SONST_KONTO."PERS_NAME" is 'Name des Mitarbeiters (Optional)';
comment on column Z_PZM_PERS_SONST_KONTO."PERS_NR" is 'Personalnummer des Benutzers (Bei integriertem PZM wir die Personalnumme und die Kontaktdaten von PZM übersteuert (Trigger im PZM)';



-- sqlcl_snapshot {"hash":"f964a17eee48a2ab7dc28f2521537a450f367b1b","type":"COMMENT","name":"z_pzm_pers_sonst_konto","schemaName":"dirkspzm32","sxml":""}