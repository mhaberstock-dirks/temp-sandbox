comment on table dirkspzm32.lvs_packschema_kopf is
    'Packschema Beschreibung Palettenaufbau ';

comment on column dirkspzm32.lvs_packschema_kopf.anz_lagen is
    'Anzahl der Lagen';

comment on column dirkspzm32.lvs_packschema_kopf.aufstapel_kopf_list is
    'Liste(;)  aller Packchemen die auf dieses Packschema aufgestapelt werden dürfen ';

comment on column dirkspzm32.lvs_packschema_kopf.basis_lte_name is
    'Welcher LTE Typ ist für dieses Packschema gültig (LTE_BASISTYP) ';

comment on column dirkspzm32.lvs_packschema_kopf.change_date is
    'Datum letzte Änderung';

comment on column dirkspzm32.lvs_packschema_kopf.change_login_id is
    'Login ID letzte Änderung';

comment on column dirkspzm32.lvs_packschema_kopf.create_date is
    'Datum Datensatz erzeugt';

comment on column dirkspzm32.lvs_packschema_kopf.create_login_id is
    'Login ID Erzeuger';

comment on column dirkspzm32.lvs_packschema_kopf.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_packschema_kopf.gerade_lagen_drehen is
    '"F"= nicht drehen, "T" = Lage 2,4,6,8, ... werden um 180 Grad gedreht ';

comment on column dirkspzm32.lvs_packschema_kopf.lhm_name is
    'Welcher LHM Grundtyp ist erlaubt';

comment on column dirkspzm32.lvs_packschema_kopf.lte_host_anz is
    'Dieses Packschema referenziert diese Anzahl an Paletten im HOST';

comment on column dirkspzm32.lvs_packschema_kopf.lte_name is
    'welcher ausgeprägte Lte_TYp ist für dieses Packschema gültig.';

comment on column dirkspzm32.lvs_packschema_kopf.max_gesamt_hoehe_mm is
    'Maximale Höhe der Palette in MM';

comment on column dirkspzm32.lvs_packschema_kopf.min_anz_lhm is
    'Minimale Anzahl LHM, damit die LTE ausgelagert werden kann';

comment on column dirkspzm32.lvs_packschema_kopf.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.lvs_packschema_kopf.prozess_param is
    'ProzessParameter z.B Oetker wo wird gedoppelt';

comment on column dirkspzm32.lvs_packschema_kopf.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_packschema_kopf.text is
    'Generelle Beschreibung';

comment on column dirkspzm32.lvs_packschema_kopf.wickelprogramm is
    'Wickel Programm Nr.';

comment on column dirkspzm32.lvs_packschema_kopf.x_ueberstand_max is
    'mm Maximaler Überstand in X-Richtung (Gilt für beide Seiten)';

comment on column dirkspzm32.lvs_packschema_kopf.y_ueberstand_max is
    'mm Maximaler Überstand in Y-Richtung (Gilt für beide Seiten)';


-- sqlcl_snapshot {"hash":"ea9eb1325b3a307c7f579d3d1f995933b4fdd251","type":"COMMENT","name":"lvs_packschema_kopf","schemaName":"dirkspzm32","sxml":""}