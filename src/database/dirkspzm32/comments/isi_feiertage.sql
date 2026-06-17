comment on table DIRKSPZM32.ISI_FEIERTAGE is 'Zukünftig werden die Daten von hier geholt - https://github.com/openpotato/openholidaysapi.data/blob/develop/src/de/holidays/holidays.public.csv';
comment on column DIRKSPZM32.ISI_FEIERTAGE."F_COUNTRY" is 'Landeskuerzel z.B. DE';
comment on column DIRKSPZM32.ISI_FEIERTAGE."F_DATUM" is 'Datum des Fieertags';
comment on column DIRKSPZM32.ISI_FEIERTAGE."F_NAME" is 'Feiertags Name in Landes Sprachd';
comment on column DIRKSPZM32.ISI_FEIERTAGE."F_NAME_2" is 'Feiertags Name in Sprache der Verantwortungsstelle';
comment on column DIRKSPZM32.ISI_FEIERTAGE."F_NAME_EN" is 'Feiertags Name in Englisch als Fallback';
comment on column DIRKSPZM32.ISI_FEIERTAGE."F_SONDER_FEIERTAG" is 'SF = Sonderfeiertag';
comment on column DIRKSPZM32.ISI_FEIERTAGE."F_WOCHENTAG" is 'Wochentag des Feiertags 1 = Montag, 7 = Sontag';
comment on column DIRKSPZM32.ISI_FEIERTAGE."REGION_CODES_CSV" is 'Bundesland / Region - Zur Feiertagsfindung z.B.: 
DE-NRW Nordrhein-Westfalen
DE-NI Niedersachsen 
DE-BY Bayern
DE-BY-AU Augsburg in Bayern
Die Feiertagd-Kürzel sind dan z.B.:
DE Alle in Deuschland
DE-NI Feiertage in Niedersachsen 
zu finden
select t.*, t.rowid 
  from ISI_FEIERTAGE t,
       table(strsplit(t.region_codes_csv, '';'')) rc
 where ''DE-BY-AU'' like rc.column_value || ''%''
';



-- sqlcl_snapshot {"hash":"2431264ffc52d263d2663a49c814ca33bd017fa2","type":"COMMENT","name":"isi_feiertage","schemaName":"dirkspzm32","sxml":""}