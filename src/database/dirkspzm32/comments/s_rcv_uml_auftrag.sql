comment on table dirkspzm32.s_rcv_uml_auftrag is
    'Umlageraufträge aus dem SAP (Lagerort -> Lagerort)';

comment on column dirkspzm32.s_rcv_uml_auftrag.artikel is
    'Artikelnummer ISI_ARTIKEL.ARTIKEL';

comment on column dirkspzm32.s_rcv_uml_auftrag.auftrnr is
    'Auftragsnummer';

comment on column dirkspzm32.s_rcv_uml_auftrag.charge is
    'Geforderte Charge';

comment on column dirkspzm32.s_rcv_uml_auftrag.erstellt_datum is
    'Erzeugungsdatum';

comment on column dirkspzm32.s_rcv_uml_auftrag.firma_nr is
    'Firmanummer (Mandant)';

comment on column dirkspzm32.s_rcv_uml_auftrag.lte_id is
    'Genau diese LTE ist zu transportieren';

comment on column dirkspzm32.s_rcv_uml_auftrag.qiuell_lgr_platz is
    'Quellenlagerplatz (In ISI-Plus)';

comment on column dirkspzm32.s_rcv_uml_auftrag.quell_lgr_ort is
    'Quellenlagerort Lagerort im ISIPlus ==> LVS_LGR_ORT.LGR_ORT';

comment on column dirkspzm32.s_rcv_uml_auftrag.sid is
    'SID ';

comment on column dirkspzm32.s_rcv_uml_auftrag.umldat is
    'Umlagerdatum';

comment on column dirkspzm32.s_rcv_uml_auftrag.ziel_lgr_ort is
    'Ziellagerort Lagerort im ISIPlus ==> LVS_LGR_ORT.LGR_ORT';

comment on column dirkspzm32.s_rcv_uml_auftrag.ziel_lgr_platz is
    'Ziellagerplatz (In ISI-Plus)';

comment on column dirkspzm32.s_rcv_uml_auftrag.ziel_ort_bez is
    'Ziel Halle';


-- sqlcl_snapshot {"hash":"3085c57cd3d10e1f6ca34c307ae39779122be822","type":"COMMENT","name":"s_rcv_uml_auftrag","schemaName":"dirkspzm32","sxml":""}