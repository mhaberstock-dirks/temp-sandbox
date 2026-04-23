comment on table dirkspzm32.isi_res_leistung_cfg is
    'Leistungsparameter und Daten von Resourcen';

comment on column dirkspzm32.isi_res_leistung_cfg.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_res_leistung_cfg.param_erhebung is
    '''A'' Automatisch, ''B'' Berechnet, ''E'' Erfasst';

comment on column dirkspzm32.isi_res_leistung_cfg.param_menge is
    'Menge ';

comment on column dirkspzm32.isi_res_leistung_cfg.param_menge_einh is
    'Mengeneinheit';

comment on column dirkspzm32.isi_res_leistung_cfg.param_name is
    'z.B. STK_MIN, DURCH_STK_TAG, STD_TAG';

comment on column dirkspzm32.isi_res_leistung_cfg.param_zeit is
    'Zeitraum für die Menge';

comment on column dirkspzm32.isi_res_leistung_cfg.param_zeit_einh is
    'z.B. MI Minute, D Tag, M Monat, Y Jahr (Like Oracle Date)';

comment on column dirkspzm32.isi_res_leistung_cfg.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk';

comment on column dirkspzm32.isi_res_leistung_cfg.res_l_cfg_id is
    'Eindeutige ID als PK aus Seq.';

comment on column dirkspzm32.isi_res_leistung_cfg.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"2c3e59e719e2a5405de4ffea08a8df5be184248b","type":"COMMENT","name":"isi_res_leistung_cfg","schemaName":"dirkspzm32","sxml":""}