comment on table DIRKSPZM32.LVS_LHM_CFG is 'Config Daten der Lagerhilfsmittel (Kartons, KLT etc.)';
comment on column DIRKSPZM32.LVS_LHM_CFG."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_LHM_CFG."HOST_REF_ID" is 'Referenznummer des Host, falls vorhanden';
comment on column DIRKSPZM32.LVS_LHM_CFG."ISI_PARAMS" is 'Parameter Handling etc. (Für den Kunden)';
comment on column DIRKSPZM32.LVS_LHM_CFG."LHM_GEOM" is 'Grundform, Geometrie (QUADER, ZYLINDER) ';
comment on column DIRKSPZM32.LVS_LHM_CFG."LHM_GEW_KG" is 'Gewichr des LHM in KG';
comment on column DIRKSPZM32.LVS_LHM_CFG."LHM_ID_GUELTIG_TAGE" is 'Wie lange bleibt eine LHM_ID gültig wenn sie LEER ist, Bzw. nicht auf einer Palette oder Lagerplatz ist';
comment on column DIRKSPZM32.LVS_LHM_CFG."LHM_MENGE" is 'Standardmenge in diesem LHM, Default wenn STD-Menge im Artikel nicht gepflegt';
comment on column DIRKSPZM32.LVS_LHM_CFG."LHM_NAME" is 'Art, Name des LHM''s Bsp.: K600 als Karton 600';
comment on column DIRKSPZM32.LVS_LHM_CFG."LHM_TEXT" is 'Beschreibung / Text des LHM';
comment on column DIRKSPZM32.LVS_LHM_CFG."LHM_VOL_BREITE" is 'Breite des LHM';
comment on column DIRKSPZM32.LVS_LHM_CFG."LHM_VOL_HOEHE" is 'Höhe des LHM';
comment on column DIRKSPZM32.LVS_LHM_CFG."LHM_VOL_TIEFE" is 'Länge des LHM';
comment on column DIRKSPZM32.LVS_LHM_CFG."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.LVS_LHM_CFG."STAPELFAKTOR" is 'Stapelfaktor (wie viele LHM können aufeinander gestapelt werden)';
comment on column DIRKSPZM32.LVS_LHM_CFG."VERWALTET_VON" is 'ISI = von ISIPlus durch Bediener verwaltet, HOST = vom Host verwaltet';



-- sqlcl_snapshot {"hash":"a2424489695d0ea88229b828f1b5077710afa03a","type":"COMMENT","name":"lvs_lhm_cfg","schemaName":"dirkspzm32","sxml":""}