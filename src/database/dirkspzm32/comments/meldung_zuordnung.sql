comment on table DIRKSPZM32.MELDUNG_ZUORDNUNG is 'Zuordnung der MELDUNG_HILFE_TEXTE zu den MELDUNG_TEXTEn';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."CREATED_DATE" is 'Erstellungsdatum';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."CREATED_LOGIN_ID" is 'Ersteller ID';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."GUID" is 'Oracle SYS_GUID as globally unique identifier';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."LAST_CHANGE_DATE" is 'Änderungsdatum';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."LAST_CHANGE_LOGIN_ID" is 'ID der den Datensatz geändert hat';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."MHT_GUID" is 'Verweis auf --> MELDUNG_HILFE_TEXTE.GUID';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."MT_FEHLERNR" is 'depricated Verweis auf --> MELDUNG_TEXTE.MT_FEHLERNR';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."MT_FEHLERNR_STR" is 'Verweis auf --> MELDUNG_TEXTE.MT_FEHLERNR_STR';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."MT_GRUPPE" is 'Verweis auf --> MELDUNG_TEXTE.MT_GRUPPE';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."MT_INDEX" is 'Verweis auf --> MELDUNG_TEXTE.MT_INDEX';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."MT_SPRACHE" is 'Verweis auf --> MELDUNG_TEXTE.MT_SPRACHE';
comment on column DIRKSPZM32.MELDUNG_ZUORDNUNG."POS" is 'Positionsnummer für Reihenfoge, in der die MELDUNG_HILFE_TEXTE angezeigt werden sollen, 10, 20, 15, ...';



-- sqlcl_snapshot {"hash":"ee36d2632b761a4def86329cfed326ad7b0ce2a1","type":"COMMENT","name":"meldung_zuordnung","schemaName":"dirkspzm32","sxml":""}