comment on table dirkspzm32.meldung_statistik is
    'Statistik Fehlermeldungen aus meldungen_daten und Meldungs_cfg';

comment on column dirkspzm32.meldung_statistik.bereich is
    '--> Meldung_CFG.Name';

comment on column dirkspzm32.meldung_statistik.created_date is
    'Erstellungsdatum';

comment on column dirkspzm32.meldung_statistik.created_login_id is
    'Ersteller ID';

comment on column dirkspzm32.meldung_statistik.engine_id is
    'Welcher Server benutzt diese Daten';

comment on column dirkspzm32.meldung_statistik.firma_nr is
    'FIRMA_NR';

comment on column dirkspzm32.meldung_statistik.gruppe is
    'Verweis auf --> MELDUNG_CFG.FEHLER_TEXT_GRUPPE';

comment on column dirkspzm32.meldung_statistik.last_change_date is
    'Änderungsdatum';

comment on column dirkspzm32.meldung_statistik.last_change_login_id is
    'ID der den Datensatz geändert hat';

comment on column dirkspzm32.meldung_statistik.ms_begin is
    'Begin des Störung';

comment on column dirkspzm32.meldung_statistik.ms_count is
    'Anzahl der Einzelmeldungen';

comment on column dirkspzm32.meldung_statistik.ms_ende is
    'Ende des Störung';

comment on column dirkspzm32.meldung_statistik.ms_minuten is
    'Störzeit in Minuten';

comment on column dirkspzm32.meldung_statistik.ms_texte is
    'Text / Beschreibung aus Meldungen_Daten und Text';

comment on column dirkspzm32.meldung_statistik.sid is
    'SID';


-- sqlcl_snapshot {"hash":"fa4776537de8dd4af06c2879feee5e5f5e73ef9a","type":"COMMENT","name":"meldung_statistik","schemaName":"dirkspzm32","sxml":""}