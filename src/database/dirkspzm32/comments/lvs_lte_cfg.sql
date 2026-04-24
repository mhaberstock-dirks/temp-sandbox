comment on table dirkspzm32.lvs_lte_cfg is
    'Config Daten der Transporteinheiten (Paletten)';

comment on column dirkspzm32.lvs_lte_cfg.basis_lte_name is
    'Auf welches Grundtyp basiert dieser LTE-Typ (z.B. bei Gitterbox ist BASIS_LTE_NAME = Euro). Dient der Umschaltung eines Segments oder Kanal auf Euro Indu oder DueDo und zur Lagerplatzfindung über Typ'
    ;

comment on column dirkspzm32.lvs_lte_cfg.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lte_cfg.flaechen_stellplatz_erf is
    'T = für diese LTE ist ein Flächenstellplatz erforderlich, F = kein Flächenstellplatz erforderlich';

comment on column dirkspzm32.lvs_lte_cfg.gabel_hoehen_offset is
    'RBG, Stapler Gabel Offset in mm  + ';

comment on column dirkspzm32.lvs_lte_cfg.host_ref_id is
    'Referenznummer des Host, falls vorhanden';

comment on column dirkspzm32.lvs_lte_cfg.lte_gew_kg is
    'Gewicht des LTE in KG';

comment on column dirkspzm32.lvs_lte_cfg.lte_id_gueltig_tage is
    'Wie lange bleibt einen LTE_ID gültig wenn sie LEER oder den Status KF oder PF hat.';

comment on column dirkspzm32.lvs_lte_cfg.lte_name is
    'Art, Name des LTE''s Bsp.: EURO als Europalette';

comment on column dirkspzm32.lvs_lte_cfg.lte_text is
    'Beschreibung / Text des LTE';

comment on column dirkspzm32.lvs_lte_cfg.lte_vol_breite is
    'Breite des LTE in mm';

comment on column dirkspzm32.lvs_lte_cfg.lte_vol_hoehe is
    'Höhe des LTE in mm';

comment on column dirkspzm32.lvs_lte_cfg.lte_vol_hoehe_fest is
    'T = LTE hat eine feste Mindesthöhe (z.B. Gitterbox, etc)';

comment on column dirkspzm32.lvs_lte_cfg.lte_vol_tiefe is
    'Länge des LTE in mm';

comment on column dirkspzm32.lvs_lte_cfg.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lte_cfg.stapelfaktor is
    'Stapelfaktor der LTE, 1 - 99, 99 => wenn kein Stapelfaktor bekannt';

comment on column dirkspzm32.lvs_lte_cfg.transport_einheit is
    'Transportierte Ware ''LTE'' = Alle LTE_CFG, ''LHM'' = Alle LHM_CFG, ''LTE_LTE'' = LTE_CFG vom Transporttyp LTE oder ''LTE_LHM'' = LTE_CFG vom Transporttyp LHM'
    ;

comment on column dirkspzm32.lvs_lte_cfg.verwaltet_von is
    'ISI = von ISIPlus durch Bediener verwaltet, HOST = vom Host verwaltet';

comment on column dirkspzm32.lvs_lte_cfg.virtuell is
    'NULL = Unbekannt, F = Echte Palette, T = Virtuelle Palette, L = Virtuelle Palette löschen wenn wieder leer';


-- sqlcl_snapshot {"hash":"27d30011e1d8afe501ed4d0c1de3cb618e97fee6","type":"COMMENT","name":"lvs_lte_cfg","schemaName":"dirkspzm32","sxml":""}