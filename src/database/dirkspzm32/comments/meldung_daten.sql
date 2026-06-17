comment on table DIRKSPZM32.MELDUNG_DATEN is 'aufgelaufene Fehlermeldungen mit link auf Meldung_Texte und Meldungs_cfg';
comment on column DIRKSPZM32.MELDUNG_DATEN."CREATED_DATE" is 'Erstellungsdatum';
comment on column DIRKSPZM32.MELDUNG_DATEN."CREATED_LOGIN_ID" is 'Ersteller ID';
comment on column DIRKSPZM32.MELDUNG_DATEN."ENGINE_ID" is 'Welcher Server benutzt diese Daten';
comment on column DIRKSPZM32.MELDUNG_DATEN."FIRMA_NR" is 'FIRMA_NR';
comment on column DIRKSPZM32.MELDUNG_DATEN."LAST_CHANGE_DATE" is 'Änderungsdatum';
comment on column DIRKSPZM32.MELDUNG_DATEN."LAST_CHANGE_LOGIN_ID" is 'ID der den Datensatz geändert hat';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_AUSLOES_MD_ID" is 'Zeiger auf die auslösende Stoerung, wenn erste dann Null (ab Version 3.5.1)';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_BEREICH" is '--> Meldung_CFG.Name';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_DETAIL_INDEX" is '--> MELDUNG_TEXTE_DETAIL';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_GEHT" is 'Timestamp Fehler gegangen';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_GRUPPE" is 'Verweis auf --> MELDUNG_CFG.FEHLER_TEXT_GRUPPE';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_HILFSTEXT" is 'Hilfetext zum Individualisieren z.B NotAus "RBG_1"';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_ID" is 'eindeutige ID für diese Tabelle';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_INDEX" is 'Meldungs Index; Nr oder Bitarray Position';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_INFO_TEXT" is 'zusätzlich beschreibender Text z.B. vom Schichtleiter';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_INITIAL_INDEX" is 'MD_Index mit dem der Fehler initial angelegt wurde.';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_KOMMT" is 'Timestamp Fehler gekommen';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_PARAM_1" is '<%1> Optionaler Paramer z.B. Lte_id';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_PARAM_2" is '<%2>Optionaler Paramer z.B. Lagerplatz';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_STATUS" is '''K'' Kommt,  ''KG'' Kommt Gegangen  ';
comment on column DIRKSPZM32.MELDUNG_DATEN."MD_TYP" is '(SPS, MFR,BDE,NQ,  ....)';
comment on column DIRKSPZM32.MELDUNG_DATEN."SID" is 'SID';



-- sqlcl_snapshot {"hash":"740735e1d6c1e1b3133da4897ac50d04f9699619","type":"COMMENT","name":"meldung_daten","schemaName":"dirkspzm32","sxml":""}