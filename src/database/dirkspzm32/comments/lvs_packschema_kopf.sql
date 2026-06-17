comment on table DIRKSPZM32.LVS_PACKSCHEMA_KOPF is 'Packschema Beschreibung Palettenaufbau ';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."ANZ_LAGEN" is 'Anzahl der Lagen';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."AUFSTAPEL_KOPF_LIST" is 'Liste(;)  aller Packchemen die auf dieses Packschema aufgestapelt werden dürfen ';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."BASIS_LTE_NAME" is 'Welcher LTE Typ ist für dieses Packschema gültig (LTE_BASISTYP) ';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."CHANGE_DATE" is 'Datum letzte Änderung';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."CHANGE_LOGIN_ID" is 'Login ID letzte Änderung';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."CREATE_DATE" is 'Datum Datensatz erzeugt';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."CREATE_LOGIN_ID" is 'Login ID Erzeuger';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."GERADE_LAGEN_DREHEN" is '"F"= nicht drehen, "T" = Lage 2,4,6,8, ... werden um 180 Grad gedreht ';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."LHM_NAME" is 'Welcher LHM Grundtyp ist erlaubt';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."LTE_HOST_ANZ" is 'Dieses Packschema referenziert diese Anzahl an Paletten im HOST';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."LTE_NAME" is 'welcher ausgeprägte Lte_TYp ist für dieses Packschema gültig.';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."MAX_GESAMT_HOEHE_MM" is 'Maximale Höhe der Palette in MM';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."MIN_ANZ_LHM" is 'Minimale Anzahl LHM, damit die LTE ausgelagert werden kann';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."PACKSCHEMA_KOPF_ID" is 'ID / Name des Packschemas';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."PROZESS_PARAM" is 'ProzessParameter z.B Oetker wo wird gedoppelt';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."TEXT" is 'Generelle Beschreibung';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."WICKELPROGRAMM" is 'Wickel Programm Nr.';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."X_UEBERSTAND_MAX" is 'mm Maximaler Überstand in X-Richtung (Gilt für beide Seiten)';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_KOPF."Y_UEBERSTAND_MAX" is 'mm Maximaler Überstand in Y-Richtung (Gilt für beide Seiten)';



-- sqlcl_snapshot {"hash":"d8192392c48ca608a03cfaaa0551df8ec39180fd","type":"COMMENT","name":"lvs_packschema_kopf","schemaName":"dirkspzm32","sxml":""}