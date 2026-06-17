comment on table DIRKSPZM32.LVS_LGR_ORT_FUELLG_CHECK is 'CFG der Lagerorte zur Steuerung der Einlagerung über Füllgrad (Prüfung obmöglich)';
comment on column DIRKSPZM32.LVS_LGR_ORT_FUELLG_CHECK."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_LGR_ORT_FUELLG_CHECK."LGR_GRUPPE_ID" is 'ID Der Gruppe (Gruppe für die Zuordnung von Fahrzeugen) NULL = über alle prüfen';
comment on column DIRKSPZM32.LVS_LGR_ORT_FUELLG_CHECK."LGR_ORT" is 'Kurzname oder Nummer des Lagerorts';
comment on column DIRKSPZM32.LVS_LGR_ORT_FUELLG_CHECK."LGR_ORT_FUELLG_CHECK_ID" is 'für PKey';
comment on column DIRKSPZM32.LVS_LGR_ORT_FUELLG_CHECK."LGR_ORT_FUELLG_MAX_PROZ" is 'Max Prozent Befüllung für alle Einlagerungen (z.B. das Umlagerungen unf Freifahren möglich bleibt)';
comment on column DIRKSPZM32.LVS_LGR_ORT_FUELLG_CHECK."LGR_ORT_FUELLG_WEE_MAX_P" is 'Max Prozent Befüllung für Externe Anliferung ';
comment on column DIRKSPZM32.LVS_LGR_ORT_FUELLG_CHECK."LTE_NAME" is 'Name der LTE, die geprüft werden soll.  Generell wenn Leer dann über alle Typen prüfen';
comment on column DIRKSPZM32.LVS_LGR_ORT_FUELLG_CHECK."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"6aa292b6778bbea760997ee865dadbc8cbcb13c9","type":"COMMENT","name":"lvs_lgr_ort_fuellg_check","schemaName":"dirkspzm32","sxml":""}