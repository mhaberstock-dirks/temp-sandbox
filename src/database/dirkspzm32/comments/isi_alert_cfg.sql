comment on column dirkspzm32.isi_alert_cfg.alert_aktiv is
    '''T'' = Alert Ein;   ''F'' = Alert Aus ''M'' = Manuell';

comment on column dirkspzm32.isi_alert_cfg.alert_cfg_name is
    'Unique Name';

comment on column dirkspzm32.isi_alert_cfg.alert_datum is
    'Datum des Alert';

comment on column dirkspzm32.isi_alert_cfg.alert_filter is
    'Filter z.B. "QUALITÄT;" es werden nur die Meldungen herangezogen die diesem Filter entsprechen siehe auch MELDUNG_TEXT.FILTER_MASK'
    ;

comment on column dirkspzm32.isi_alert_cfg.alert_intervall is
    'Intervall in Sekunden ';

comment on column dirkspzm32.isi_alert_cfg.alert_status is
    '''T'' = Alert Aktiv;   ''F'' = Alert Aus ''-'' = unbekannt';

comment on column dirkspzm32.isi_alert_cfg.alert_typ is
    '''R'' Resourcen Alert, ''M'' Meldungen Alert .... ''S'' ServiceLogik Alert';

comment on column dirkspzm32.isi_alert_cfg.mail_address is
    'Mail Adresse';

comment on column dirkspzm32.isi_alert_cfg.res_id is
    '--> ISI_RESOURCE Resourcen_id der parent_id, Linien_res_id';

comment on column dirkspzm32.isi_alert_cfg.template_kopf is
    'Vorlage Meldung Allgemein';

comment on column dirkspzm32.isi_alert_cfg.template_meld_geht is
    'Vorlage Meldung gegangen';

comment on column dirkspzm32.isi_alert_cfg.template_meld_kommt is
    'Vorlage Meldung Aktiv';


-- sqlcl_snapshot {"hash":"b87f63b06a6848bcc47295c9fdbdf68578cc2b52","type":"COMMENT","name":"isi_alert_cfg","schemaName":"dirkspzm32","sxml":""}