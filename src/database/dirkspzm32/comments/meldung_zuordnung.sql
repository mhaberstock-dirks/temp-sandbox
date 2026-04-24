comment on table dirkspzm32.meldung_zuordnung is
    'Zuordnung der MELDUNG_HILFE_TEXTE zu den MELDUNG_TEXTEn';

comment on column dirkspzm32.meldung_zuordnung.created_date is
    'Erstellungsdatum';

comment on column dirkspzm32.meldung_zuordnung.created_login_id is
    'Ersteller ID';

comment on column dirkspzm32.meldung_zuordnung.guid is
    'Oracle SYS_GUID as globally unique identifier';

comment on column dirkspzm32.meldung_zuordnung.last_change_date is
    'Änderungsdatum';

comment on column dirkspzm32.meldung_zuordnung.last_change_login_id is
    'ID der den Datensatz geändert hat';

comment on column dirkspzm32.meldung_zuordnung.mht_guid is
    'Verweis auf --> MELDUNG_HILFE_TEXTE.GUID';

comment on column dirkspzm32.meldung_zuordnung.mt_fehlernr is
    'depricated Verweis auf --> MELDUNG_TEXTE.MT_FEHLERNR';

comment on column dirkspzm32.meldung_zuordnung.mt_fehlernr_str is
    'Verweis auf --> MELDUNG_TEXTE.MT_FEHLERNR_STR';

comment on column dirkspzm32.meldung_zuordnung.mt_gruppe is
    'Verweis auf --> MELDUNG_TEXTE.MT_GRUPPE';

comment on column dirkspzm32.meldung_zuordnung.mt_index is
    'Verweis auf --> MELDUNG_TEXTE.MT_INDEX';

comment on column dirkspzm32.meldung_zuordnung.mt_sprache is
    'Verweis auf --> MELDUNG_TEXTE.MT_SPRACHE';

comment on column dirkspzm32.meldung_zuordnung.pos is
    'Positionsnummer für Reihenfoge, in der die MELDUNG_HILFE_TEXTE angezeigt werden sollen, 10, 20, 15, ...';


-- sqlcl_snapshot {"hash":"8cd1fd06983e45186dc9e8e861d3e9ddb340e759","type":"COMMENT","name":"meldung_zuordnung","schemaName":"dirkspzm32","sxml":""}