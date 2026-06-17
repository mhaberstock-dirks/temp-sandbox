comment on table DIRKSPZM32.MELDUNG_TEXTE is 'Texte der Fehlermeldungen Meldungen Daten Kopf liegt in Tabelle Meldung_CFG';
comment on column DIRKSPZM32.MELDUNG_TEXTE."BG_COLOR" is 'Hintergrundfarbe der Störung';
comment on column DIRKSPZM32.MELDUNG_TEXTE."CREATED_DATE" is 'Erstellungsdatum';
comment on column DIRKSPZM32.MELDUNG_TEXTE."CREATED_LOGIN_ID" is 'Ersteller ID';
comment on column DIRKSPZM32.MELDUNG_TEXTE."ENGINE_ID" is 'Verweis auf --> MELDUNG_CFG.ENGINE_ID';
comment on column DIRKSPZM32.MELDUNG_TEXTE."FG_COLOR" is 'Fordergrundfarbe der Störung';
comment on column DIRKSPZM32.MELDUNG_TEXTE."FILTER_MASK" is 'Filter mask z.B. für Alerts';
comment on column DIRKSPZM32.MELDUNG_TEXTE."FIRMA_NR" is 'FIRMA_NR';
comment on column DIRKSPZM32.MELDUNG_TEXTE."LAST_CHANGE_DATE" is 'Änderungsdatum';
comment on column DIRKSPZM32.MELDUNG_TEXTE."LAST_CHANGE_LOGIN_ID" is 'ID der den Datensatz geändert hat';
comment on column DIRKSPZM32.MELDUNG_TEXTE."MT_FEHLERNR" is 'Fehlernummer für diesen MeldungsIndex (Daten aus File Import)';
comment on column DIRKSPZM32.MELDUNG_TEXTE."MT_FEHLERNR_STR" is 'Neue FehlerNr als ASCII z.B.  für Hex Fehlernummern.';
comment on column DIRKSPZM32.MELDUNG_TEXTE."MT_FEHLERTEXT" is 'Fehlertext für diesen MeldungsIndex (Daten aus File Import)';
comment on column DIRKSPZM32.MELDUNG_TEXTE."MT_GRUPPE" is 'Verweis auf --> MELDUNG_CFG.FEHLER_TEXT_GRUPPE';
comment on column DIRKSPZM32.MELDUNG_TEXTE."MT_INDEX" is 'MeldungsIndex; Nr oder Bitarray Position (Daten aus File Import)';
comment on column DIRKSPZM32.MELDUNG_TEXTE."MT_QUITTIEREN" is '''Q'' Quittierungspflichtige Störung';
comment on column DIRKSPZM32.MELDUNG_TEXTE."MT_REGELWERK" is 'Regelwerk für Meldungen mit Aktion z.B. RW_ZIEL_VOLL';
comment on column DIRKSPZM32.MELDUNG_TEXTE."MT_SPRACHE" is 'Verweis auf --> ISI_LANGUAGE.LANG_ID';
comment on column DIRKSPZM32.MELDUNG_TEXTE."MT_TYP" is 'MeldungsTyp; ''A'' Alarm, ''M'' Meldung, ''S'' Stoerung';
comment on column DIRKSPZM32.MELDUNG_TEXTE."SID" is 'SID';



-- sqlcl_snapshot {"hash":"e064fc4f040ae9411959ebc6de56807179e55d86","type":"COMMENT","name":"meldung_texte","schemaName":"dirkspzm32","sxml":""}