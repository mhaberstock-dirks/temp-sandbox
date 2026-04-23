comment on table dirkspzm32.lvs_lhm_cfg is
    'Config Daten der Lagerhilfsmittel (Kartons, KLT etc.)';

comment on column dirkspzm32.lvs_lhm_cfg.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lhm_cfg.host_ref_id is
    'Referenznummer des Host, falls vorhanden';

comment on column dirkspzm32.lvs_lhm_cfg.isi_params is
    'Parameter Handling etc. (Für den Kunden)';

comment on column dirkspzm32.lvs_lhm_cfg.lhm_geom is
    'Grundform, Geometrie (QUADER, ZYLINDER) ';

comment on column dirkspzm32.lvs_lhm_cfg.lhm_gew_kg is
    'Gewichr des LHM in KG';

comment on column dirkspzm32.lvs_lhm_cfg.lhm_id_gueltig_tage is
    'Wie lange bleibt eine LHM_ID gültig wenn sie LEER ist, Bzw. nicht auf einer Palette oder Lagerplatz ist';

comment on column dirkspzm32.lvs_lhm_cfg.lhm_menge is
    'Standardmenge in diesem LHM, Default wenn STD-Menge im Artikel nicht gepflegt';

comment on column dirkspzm32.lvs_lhm_cfg.lhm_name is
    'Art, Name des LHM''s Bsp.: K600 als Karton 600';

comment on column dirkspzm32.lvs_lhm_cfg.lhm_text is
    'Beschreibung / Text des LHM';

comment on column dirkspzm32.lvs_lhm_cfg.lhm_vol_breite is
    'Breite des LHM';

comment on column dirkspzm32.lvs_lhm_cfg.lhm_vol_hoehe is
    'Höhe des LHM';

comment on column dirkspzm32.lvs_lhm_cfg.lhm_vol_tiefe is
    'Länge des LHM';

comment on column dirkspzm32.lvs_lhm_cfg.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lhm_cfg.stapelfaktor is
    'Stapelfaktor (wie viele LHM können aufeinander gestapelt werden)';

comment on column dirkspzm32.lvs_lhm_cfg.verwaltet_von is
    'ISI = von ISIPlus durch Bediener verwaltet, HOST = vom Host verwaltet';


-- sqlcl_snapshot {"hash":"1dba958a499e87487a6763ee574a6fde533c72a3","type":"COMMENT","name":"lvs_lhm_cfg","schemaName":"dirkspzm32","sxml":""}