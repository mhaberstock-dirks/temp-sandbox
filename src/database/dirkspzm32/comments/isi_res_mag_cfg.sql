comment on table dirkspzm32.isi_res_mag_cfg is
    'Stores the current configuration for one magazine resource';

comment on column dirkspzm32.isi_res_mag_cfg.artikel_id is
    'id of the assigned article';

comment on column dirkspzm32.isi_res_mag_cfg.charge is
    'charge of current loaded article';

comment on column dirkspzm32.isi_res_mag_cfg.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.isi_res_mag_cfg.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.isi_res_mag_cfg.enabled is
    'T = enabled, F = disabled';

comment on column dirkspzm32.isi_res_mag_cfg.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.isi_res_mag_cfg.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.isi_res_mag_cfg.lhm_name is
    'Art der Lagerhilfsmittel Bsp.: K600 = ''Karton 600''';

comment on column dirkspzm32.isi_res_mag_cfg.lte_name is
    'Art, Name der Transporteinheit';

comment on column dirkspzm32.isi_res_mag_cfg.mag_params is
    'individual configuration params for the magazine';

comment on column dirkspzm32.isi_res_mag_cfg.mag_type is
    'ART = Artikel, LTE = LTE-Magazin, LHM = LHM-Magazin';

comment on column dirkspzm32.isi_res_mag_cfg.menge_ist is
    'amount of current loaded article';

comment on column dirkspzm32.isi_res_mag_cfg.menge_max is
    'max amount of current article';

comment on column dirkspzm32.isi_res_mag_cfg.menge_min is
    'man amount of current article for use of low capacity warning';

comment on column dirkspzm32.isi_res_mag_cfg.modul_bearbeiter is
    'MFR, SLS, PAP papier a la huf aus lvs_lgr_ort isi_modul SHT Shutle';

comment on column dirkspzm32.isi_res_mag_cfg.res_id is
    'resource id of the magazine';

comment on column dirkspzm32.isi_res_mag_cfg.status is
    'NU = not used / disabled, OK = usable and filled, LOW = low capacity, EMP = empty (but enabled)';

comment on column dirkspzm32.isi_res_mag_cfg.usage is
    'SO = sensor oriented stack / slot, AC = amount counter (logic oriented) ';

comment on column dirkspzm32.isi_res_mag_cfg.zeichnung is
    'drawing number of current assigned article';

comment on column dirkspzm32.isi_res_mag_cfg.zeichnung_index is
    'revision index of current assigned article';


-- sqlcl_snapshot {"hash":"4de7798963aeb8e2f9d3d03be3647c57d882a580","type":"COMMENT","name":"isi_res_mag_cfg","schemaName":"dirkspzm32","sxml":""}