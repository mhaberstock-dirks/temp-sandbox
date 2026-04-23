comment on column dirkspzm32.isi_event_cfg.abort_types is
    'NONE;ABORT_IF_TRUE;ABORT_IF_FALSE;';

comment on column dirkspzm32.isi_event_cfg.beschreibung is
    'Freier Text zur Beschreibung des Events';

comment on column dirkspzm32.isi_event_cfg.caption is
    'Sichbarer Text (Projekt-, Kundenspezifisch)';

comment on column dirkspzm32.isi_event_cfg.event_function is
    'z.B. WE2';

comment on column dirkspzm32.isi_event_cfg.event_handler is
    'ISI_APP_DLG, ...';

comment on column dirkspzm32.isi_event_cfg.event_type is
    'SHOW_MESSAGE, OPEN_DLG, ...';

comment on column dirkspzm32.isi_event_cfg.msg_text_src is
    'z.B. ISI_EVENT_MESSAGE_TEXTE';

comment on column dirkspzm32.isi_event_cfg.name is
    'Eventname (ohne sonderzeichen und ohne Leerzeichen';

comment on column dirkspzm32.isi_event_cfg.object_captions is
    'Artikel Nr; Fa AG  (Leerzeichen und Sonderzeichen erlaubt, Trennungdurch '';'')';

comment on column dirkspzm32.isi_event_cfg.object_names is
    'z.B. ARTIKEL_ID;edArtikel';

comment on column dirkspzm32.isi_event_cfg.object_types is
    'DB_FIELD_NAME;EDIT_BOX_NAME;SQL';

comment on column dirkspzm32.isi_event_cfg.open_dlg_unique_id is
    'ACT.INVENTUR.STD, ACT.INVENTUR.HUF';

comment on column dirkspzm32.isi_event_cfg.operators is
    '<, >, =, <=, >=, !=, ~ (like)';


-- sqlcl_snapshot {"hash":"fc47e93d5231c14c0d8259fe1b031caa2cc59087","type":"COMMENT","name":"isi_event_cfg","schemaName":"dirkspzm32","sxml":""}