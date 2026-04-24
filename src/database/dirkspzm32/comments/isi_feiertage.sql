comment on table dirkspzm32.isi_feiertage is
    'Zukünftig werden die Daten von hier geholt - https://github.com/openpotato/openholidaysapi.data/blob/develop/src/de/holidays/holidays.public.csv'
    ;

comment on column dirkspzm32.isi_feiertage.f_country is
    'Landeskuerzel z.B. DE';

comment on column dirkspzm32.isi_feiertage.f_datum is
    'Datum des Fieertags';

comment on column dirkspzm32.isi_feiertage.f_name is
    'Feiertags Name in Landes Sprachd';

comment on column dirkspzm32.isi_feiertage.f_name_2 is
    'Feiertags Name in Sprache der Verantwortungsstelle';

comment on column dirkspzm32.isi_feiertage.f_name_en is
    'Feiertags Name in Englisch als Fallback';

comment on column dirkspzm32.isi_feiertage.f_sonder_feiertag is
    'SF = Sonderfeiertag';

comment on column dirkspzm32.isi_feiertage.f_wochentag is
    'Wochentag des Feiertags 1 = Montag, 7 = Sontag';

comment on column dirkspzm32.isi_feiertage.region_codes_csv is
    'Bundesland / Region - Zur Feiertagsfindung z.B.: 
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


-- sqlcl_snapshot {"hash":"b443783bd9c38e2f1ec3a895c88589b3ca3f58f2","type":"COMMENT","name":"isi_feiertage","schemaName":"dirkspzm32","sxml":""}