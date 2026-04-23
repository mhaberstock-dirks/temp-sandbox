comment on table dirkspzm32.meldung_texte is
    'Texte der Fehlermeldungen Meldungen Daten Kopf liegt in Tabelle Meldung_CFG';

comment on column dirkspzm32.meldung_texte.bg_color is
    'Hintergrundfarbe der Störung';

comment on column dirkspzm32.meldung_texte.created_date is
    'Erstellungsdatum';

comment on column dirkspzm32.meldung_texte.created_login_id is
    'Ersteller ID';

comment on column dirkspzm32.meldung_texte.engine_id is
    'Verweis auf --> MELDUNG_CFG.ENGINE_ID';

comment on column dirkspzm32.meldung_texte.fg_color is
    'Fordergrundfarbe der Störung';

comment on column dirkspzm32.meldung_texte.filter_mask is
    'Filter mask z.B. für Alerts';

comment on column dirkspzm32.meldung_texte.firma_nr is
    'FIRMA_NR';

comment on column dirkspzm32.meldung_texte.last_change_date is
    'Änderungsdatum';

comment on column dirkspzm32.meldung_texte.last_change_login_id is
    'ID der den Datensatz geändert hat';

comment on column dirkspzm32.meldung_texte.mt_fehlernr is
    'Fehlernummer für diesen MeldungsIndex (Daten aus File Import)';

comment on column dirkspzm32.meldung_texte.mt_fehlernr_str is
    'Neue FehlerNr als ASCII z.B.  für Hex Fehlernummern.';

comment on column dirkspzm32.meldung_texte.mt_fehlertext is
    'Fehlertext für diesen MeldungsIndex (Daten aus File Import)';

comment on column dirkspzm32.meldung_texte.mt_gruppe is
    'Verweis auf --> MELDUNG_CFG.FEHLER_TEXT_GRUPPE';

comment on column dirkspzm32.meldung_texte.mt_index is
    'MeldungsIndex; Nr oder Bitarray Position (Daten aus File Import)';

comment on column dirkspzm32.meldung_texte.mt_quittieren is
    '''Q'' Quittierungspflichtige Störung';

comment on column dirkspzm32.meldung_texte.mt_regelwerk is
    'Regelwerk für Meldungen mit Aktion z.B. RW_ZIEL_VOLL';

comment on column dirkspzm32.meldung_texte.mt_sprache is
    'Verweis auf --> ISI_LANGUAGE.LANG_ID';

comment on column dirkspzm32.meldung_texte.mt_typ is
    'MeldungsTyp; ''A'' Alarm, ''M'' Meldung, ''S'' Stoerung';

comment on column dirkspzm32.meldung_texte.sid is
    'SID';


-- sqlcl_snapshot {"hash":"370ad5adccbf5ba80211a61c46de6a1b91d340af","type":"COMMENT","name":"meldung_texte","schemaName":"dirkspzm32","sxml":""}