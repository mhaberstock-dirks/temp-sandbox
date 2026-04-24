comment on table dirkspzm32.lvs_labor_status_cfg is
    'CFG für den Laborstatus';

comment on column dirkspzm32.lvs_labor_status_cfg.aend_datum is
    'wann wurde der Datensatz verändert';

comment on column dirkspzm32.lvs_labor_status_cfg.aend_login_id is
    'von wem wurde der Datensatz verändert';

comment on column dirkspzm32.lvs_labor_status_cfg.erz_datum is
    'wann wurde der Datensatz erzeugt';

comment on column dirkspzm32.lvs_labor_status_cfg.erz_login_id is
    'von wem wurde der Datensatz erzeugt';

comment on column dirkspzm32.lvs_labor_status_cfg.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_labor_status_cfg.labor_status is
    'Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung'
    ;

comment on column dirkspzm32.lvs_labor_status_cfg.labor_text is
    'Zusatztext aus Laborergebnis (Bsp. Ware darf nur zu einem bestimmten Kunden)';

comment on column dirkspzm32.lvs_labor_status_cfg.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"d8391af3d5b4e76dec65cdc381eb629853296e59","type":"COMMENT","name":"lvs_labor_status_cfg","schemaName":"dirkspzm32","sxml":""}