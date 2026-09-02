comment on table PZM_ZE_PERS_KST_MONAT_AB is 'Aufteilung der Stunden auf Kostenstellen aus bde_pd_pers_zeit_kst';
comment on column PZM_ZE_PERS_KST_MONAT_AB."DATUM" is 'Datum (Immer letzter Tag des Monats) (Primary-Key)';
comment on column PZM_ZE_PERS_KST_MONAT_AB."FIRMA_NR" is 'Firmennummer in der Datenbank (Primary-Key)';
comment on column PZM_ZE_PERS_KST_MONAT_AB."KST" is 'Kostenstelle (Primary-Key)';
comment on column PZM_ZE_PERS_KST_MONAT_AB."KST_PROZ" is 'Anteil in Prozent';
comment on column PZM_ZE_PERS_KST_MONAT_AB."KST_STD" is 'Stunde für diese Kostenstelle';
comment on column PZM_ZE_PERS_KST_MONAT_AB."KST_STD_U" is 'Stunde für diese Kostenstelle ohne Fehlerbereinigung';
comment on column PZM_ZE_PERS_KST_MONAT_AB."LOHNART" is 'Lohnart (Primary-Key)';
comment on column PZM_ZE_PERS_KST_MONAT_AB."PERS_NR" is 'Personalnummer des Mitarbeiters (Primary-Key)';
comment on column PZM_ZE_PERS_KST_MONAT_AB."SID" is 'Datenbank für Konsolidierung (Primary-Key)';



-- sqlcl_snapshot {"hash":"c81cf47eac5fafa2bf4a5cf38a63846645409c41","type":"COMMENT","name":"pzm_ze_pers_kst_monat_ab","schemaName":"dirkspzm32","sxml":""}