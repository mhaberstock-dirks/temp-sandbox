comment on table dirkspzm32.isi_number_ranges is
    'Nummernkreise für Rechnungen, Lieferscheine, Gutschriften, Vorkasse etc.';

comment on column dirkspzm32.isi_number_ranges.created_by_login_id is
    'Login ID des Benutzers der den Nummernkreis erstellt hat';

comment on column dirkspzm32.isi_number_ranges.created_date is
    'Datum der Erstellung';

comment on column dirkspzm32.isi_number_ranges.last_modified_by_login_id is
    'Login ID des Benutzers der die letzte Änderung durchgeführt hat';

comment on column dirkspzm32.isi_number_ranges.last_modified_date is
    'Datum der letzen Änderung';

comment on column dirkspzm32.isi_number_ranges.last_number is
    'Letzte verwendete Nummer aus dem Nummernkreis';

comment on column dirkspzm32.isi_number_ranges.num_range_id is
    'Unique ID (GUID/UUID) des Nummernkreises';

comment on column dirkspzm32.isi_number_ranges.num_range_name is
    'Individuelle Bezeichnung des Nummernkreises';

comment on column dirkspzm32.isi_number_ranges.num_range_type is
    'Typ des Nummernkreises (ARTNR=Artikelnummer, RECH=Rechnung, PROFR=pro-forma Rechnung, GUTS=Gutschrift, LIEF=Lieferschein, ANG=Angebot, PROJ=Projekt)'
    ;

comment on column dirkspzm32.isi_number_ranges.prefix is
    'Optionaler Präfix bei Verwendung der nächsten Nummer aus dem Nummernkreis';

comment on column dirkspzm32.isi_number_ranges.suffix is
    'Optionaler Suffix bei Verwendung der nächsten Nummer aus dem Nummernkreis';


-- sqlcl_snapshot {"hash":"44ec0de02d37970cb82d094adf16204ff66128a1","type":"COMMENT","name":"isi_number_ranges","schemaName":"dirkspzm32","sxml":""}