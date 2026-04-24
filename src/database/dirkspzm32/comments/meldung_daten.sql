comment on table dirkspzm32.meldung_daten is
    'aufgelaufene Fehlermeldungen mit link auf Meldung_Texte und Meldungs_cfg';

comment on column dirkspzm32.meldung_daten.created_date is
    'Erstellungsdatum';

comment on column dirkspzm32.meldung_daten.created_login_id is
    'Ersteller ID';

comment on column dirkspzm32.meldung_daten.engine_id is
    'Welcher Server benutzt diese Daten';

comment on column dirkspzm32.meldung_daten.firma_nr is
    'FIRMA_NR';

comment on column dirkspzm32.meldung_daten.last_change_date is
    'Änderungsdatum';

comment on column dirkspzm32.meldung_daten.last_change_login_id is
    'ID der den Datensatz geändert hat';

comment on column dirkspzm32.meldung_daten.md_ausloes_md_id is
    'Zeiger auf die auslösende Stoerung, wenn erste dann Null (ab Version 3.5.1)';

comment on column dirkspzm32.meldung_daten.md_bereich is
    '--> Meldung_CFG.Name';

comment on column dirkspzm32.meldung_daten.md_detail_index is
    '--> MELDUNG_TEXTE_DETAIL';

comment on column dirkspzm32.meldung_daten.md_geht is
    'Timestamp Fehler gegangen';

comment on column dirkspzm32.meldung_daten.md_gruppe is
    'Verweis auf --> MELDUNG_CFG.FEHLER_TEXT_GRUPPE';

comment on column dirkspzm32.meldung_daten.md_hilfstext is
    'Hilfetext zum Individualisieren z.B NotAus "RBG_1"';

comment on column dirkspzm32.meldung_daten.md_id is
    'eindeutige ID für diese Tabelle';

comment on column dirkspzm32.meldung_daten.md_index is
    'Meldungs Index; Nr oder Bitarray Position';

comment on column dirkspzm32.meldung_daten.md_info_text is
    'zusätzlich beschreibender Text z.B. vom Schichtleiter';

comment on column dirkspzm32.meldung_daten.md_initial_index is
    'MD_Index mit dem der Fehler initial angelegt wurde.';

comment on column dirkspzm32.meldung_daten.md_kommt is
    'Timestamp Fehler gekommen';

comment on column dirkspzm32.meldung_daten.md_param_1 is
    '<%1> Optionaler Paramer z.B. Lte_id';

comment on column dirkspzm32.meldung_daten.md_param_2 is
    '<%2>Optionaler Paramer z.B. Lagerplatz';

comment on column dirkspzm32.meldung_daten.md_status is
    '''K'' Kommt,  ''KG'' Kommt Gegangen  ';

comment on column dirkspzm32.meldung_daten.md_typ is
    '(SPS, MFR,BDE,NQ,  ....)';

comment on column dirkspzm32.meldung_daten.sid is
    'SID';


-- sqlcl_snapshot {"hash":"34ae339fa8399110a1807f8544b9ad23a7e27da9","type":"COMMENT","name":"meldung_daten","schemaName":"dirkspzm32","sxml":""}