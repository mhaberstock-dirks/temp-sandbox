comment on table DIRKSPZM32.LVS_LGR_ORT_UE_PLATZ is 'Übergabeplatze von nach Lagerort';
comment on column DIRKSPZM32.LVS_LGR_ORT_UE_PLATZ."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_LGR_ORT_UE_PLATZ."LGR_ORT_QUELLE" is 'Lagerort der quelle';
comment on column DIRKSPZM32.LVS_LGR_ORT_UE_PLATZ."LGR_ORT_ZIEL" is 'Lagerort des Ziels';
comment on column DIRKSPZM32.LVS_LGR_ORT_UE_PLATZ."LGR_PLATZ" is 'Übergabeplatz (NULL = Keine Mögilchkeit / Keine Weg)';
comment on column DIRKSPZM32.LVS_LGR_ORT_UE_PLATZ."LTE_NAME" is 'LTE-Nmae eingetragen, dann genau für diese LTE-Namen, Wenn NULL, dann für alle LTE-Typen';
comment on column DIRKSPZM32.LVS_LGR_ORT_UE_PLATZ."LTE_NAME_ZIEL" is 'Wenn die LTE in dieses Ziel soll, dann ist dieser LTE-Typ zu verwenden. Fall dieser NULL, dann bleibt der LTE-Name unverändert';
comment on column DIRKSPZM32.LVS_LGR_ORT_UE_PLATZ."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"4e61e65f4151618422965c3d2ec071954471a1e6","type":"COMMENT","name":"lvs_lgr_ort_ue_platz","schemaName":"dirkspzm32","sxml":""}