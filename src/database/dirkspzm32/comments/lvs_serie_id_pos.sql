comment on table dirkspzm32.lvs_serie_id_pos is
    'Tabelle mit allen IDs die für einen Fertigungsauftrag generiert worden sind';

comment on column dirkspzm32.lvs_serie_id_pos.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.lvs_serie_id_pos.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.lvs_serie_id_pos.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_serie_id_pos.lam_id is
    'LAM-ID mit der diese SDeriennummer verküpft ist. Wenn NULL dann frei';

comment on column dirkspzm32.lvs_serie_id_pos.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.lvs_serie_id_pos.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.lvs_serie_id_pos.serie_id is
    'ID des zu der Serie gehörenden Headers (BDE_SERIAL_ID_HDR)';

comment on column dirkspzm32.lvs_serie_id_pos.serie_id_lfdn is
    'LFDN der SERIE-ID';

comment on column dirkspzm32.lvs_serie_id_pos.serie_nr is
    'Seriennummer aus Kopf fertig aufgelöst (Gleich wie bei der Charge die Chargenbezeichnung - Eigentliche Seriennummer auf dem Produkt)'
    ;

comment on column dirkspzm32.lvs_serie_id_pos.serie_nr_extern is
    'Externe Seriennummer aus Kopf fertig aufgelöst - Z.B. Owner-ID ';

comment on column dirkspzm32.lvs_serie_id_pos.serie_pos_lfdn is
    'Laufende Nummer der IDs in Vergabereihenfolge einer Serie (Bsp. bei einer Menge von 1000 => 1 bis 1000 )';

comment on column dirkspzm32.lvs_serie_id_pos.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"9d11832de5725ec5a09e8ae1965e7f2a876c3812","type":"COMMENT","name":"lvs_serie_id_pos","schemaName":"dirkspzm32","sxml":""}