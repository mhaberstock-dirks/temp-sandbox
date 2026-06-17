comment on table DIRKSPZM32.LVS_LTE_CFG is 'Config Daten der Transporteinheiten (Paletten)';
comment on column DIRKSPZM32.LVS_LTE_CFG."BASIS_LTE_NAME" is 'Auf welches Grundtyp basiert dieser LTE-Typ (z.B. bei Gitterbox ist BASIS_LTE_NAME = Euro). Dient der Umschaltung eines Segments oder Kanal auf Euro Indu oder DueDo und zur Lagerplatzfindung über Typ';
comment on column DIRKSPZM32.LVS_LTE_CFG."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_LTE_CFG."FLAECHEN_STELLPLATZ_ERF" is 'T = für diese LTE ist ein Flächenstellplatz erforderlich, F = kein Flächenstellplatz erforderlich';
comment on column DIRKSPZM32.LVS_LTE_CFG."GABEL_HOEHEN_OFFSET" is 'RBG, Stapler Gabel Offset in mm  + ';
comment on column DIRKSPZM32.LVS_LTE_CFG."HOST_REF_ID" is 'Referenznummer des Host, falls vorhanden';
comment on column DIRKSPZM32.LVS_LTE_CFG."LTE_GEW_KG" is 'Gewicht des LTE in KG';
comment on column DIRKSPZM32.LVS_LTE_CFG."LTE_ID_GUELTIG_TAGE" is 'Wie lange bleibt einen LTE_ID gültig wenn sie LEER oder den Status KF oder PF hat.';
comment on column DIRKSPZM32.LVS_LTE_CFG."LTE_NAME" is 'Art, Name des LTE''s Bsp.: EURO als Europalette';
comment on column DIRKSPZM32.LVS_LTE_CFG."LTE_TEXT" is 'Beschreibung / Text des LTE';
comment on column DIRKSPZM32.LVS_LTE_CFG."LTE_VOL_BREITE" is 'Breite des LTE in mm';
comment on column DIRKSPZM32.LVS_LTE_CFG."LTE_VOL_HOEHE" is 'Höhe des LTE in mm';
comment on column DIRKSPZM32.LVS_LTE_CFG."LTE_VOL_HOEHE_FEST" is 'T = LTE hat eine feste Mindesthöhe (z.B. Gitterbox, etc)';
comment on column DIRKSPZM32.LVS_LTE_CFG."LTE_VOL_TIEFE" is 'Länge des LTE in mm';
comment on column DIRKSPZM32.LVS_LTE_CFG."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.LVS_LTE_CFG."STAPELFAKTOR" is 'Stapelfaktor der LTE, 1 - 99, 99 => wenn kein Stapelfaktor bekannt';
comment on column DIRKSPZM32.LVS_LTE_CFG."TRANSPORT_EINHEIT" is 'Transportierte Ware ''LTE'' = Alle LTE_CFG, ''LHM'' = Alle LHM_CFG, ''LTE_LTE'' = LTE_CFG vom Transporttyp LTE oder ''LTE_LHM'' = LTE_CFG vom Transporttyp LHM';
comment on column DIRKSPZM32.LVS_LTE_CFG."VERWALTET_VON" is 'ISI = von ISIPlus durch Bediener verwaltet, HOST = vom Host verwaltet';
comment on column DIRKSPZM32.LVS_LTE_CFG."VIRTUELL" is 'NULL = Unbekannt, F = Echte Palette, T = Virtuelle Palette, L = Virtuelle Palette löschen wenn wieder leer';



-- sqlcl_snapshot {"hash":"2e83dec0bb27ac5aee6866c38bd51c538399bd19","type":"COMMENT","name":"lvs_lte_cfg","schemaName":"dirkspzm32","sxml":""}