comment on table DIRKSPZM32.ISI_RES_MAG_CFG is 'Stores the current configuration for one magazine resource';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."ARTIKEL_ID" is 'id of the assigned article';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."CHARGE" is 'charge of current loaded article';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."CREATED_LOGIN_ID" is 'login id of the user creating this dataset';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."ENABLED" is 'T = enabled, F = disabled';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."LAST_CHANGE_LOGIN_ID" is 'login id of the user changing this dataset';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."LHM_NAME" is 'Art der Lagerhilfsmittel Bsp.: K600 = ''Karton 600''';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."LTE_NAME" is 'Art, Name der Transporteinheit';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."MAG_PARAMS" is 'individual configuration params for the magazine';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."MAG_TYPE" is 'ART = Artikel, LTE = LTE-Magazin, LHM = LHM-Magazin';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."MENGE_IST" is 'amount of current loaded article';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."MENGE_MAX" is 'max amount of current article';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."MENGE_MIN" is 'man amount of current article for use of low capacity warning';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."MODUL_BEARBEITER" is 'MFR, SLS, PAP papier a la huf aus lvs_lgr_ort isi_modul SHT Shutle';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."RES_ID" is 'resource id of the magazine';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."STATUS" is 'NU = not used / disabled, OK = usable and filled, LOW = low capacity, EMP = empty (but enabled)';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."USAGE" is 'SO = sensor oriented stack / slot, AC = amount counter (logic oriented) ';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."ZEICHNUNG" is 'drawing number of current assigned article';
comment on column DIRKSPZM32.ISI_RES_MAG_CFG."ZEICHNUNG_INDEX" is 'revision index of current assigned article';



-- sqlcl_snapshot {"hash":"dc1efd95409c16f01bd29219ad5b0ed798b90f24","type":"COMMENT","name":"isi_res_mag_cfg","schemaName":"dirkspzm32","sxml":""}