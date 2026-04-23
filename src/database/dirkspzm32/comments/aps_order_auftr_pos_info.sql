comment on table dirkspzm32.aps_order_auftr_pos_info is
    'Aufträge für die Planung';

comment on column dirkspzm32.aps_order_auftr_pos_info.aend_datum is
    'Bearbeitungsdatum, zuletzt bearbeitet am';

comment on column dirkspzm32.aps_order_auftr_pos_info.aend_login_id is
    'ID des Bearbeiters';

comment on column dirkspzm32.aps_order_auftr_pos_info.aps_info_zeitpunkt is
    'Zeitpunkt INFO - Fehler';

comment on column dirkspzm32.aps_order_auftr_pos_info.aps_plan_status is
    'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig'
    ;

comment on column dirkspzm32.aps_order_auftr_pos_info.aps_stufe is
    'Planungsstufe';

comment on column dirkspzm32.aps_order_auftr_pos_info.auftrag_nr is
    'Auftragsnummer';

comment on column dirkspzm32.aps_order_auftr_pos_info.erz_datum is
    'Erstellungsdatum, erstellt am';

comment on column dirkspzm32.aps_order_auftr_pos_info.erz_login_id is
    'ID des Erstellers';

comment on column dirkspzm32.aps_order_auftr_pos_info.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.aps_order_auftr_pos_info.pos_info is
    'Text zur Position';

comment on column dirkspzm32.aps_order_auftr_pos_info.pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.aps_order_auftr_pos_info.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.aps_order_auftr_pos_info.upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';


-- sqlcl_snapshot {"hash":"5c475a029b0bfddaa5ae5aa8df50e0388ed96a06","type":"COMMENT","name":"aps_order_auftr_pos_info","schemaName":"dirkspzm32","sxml":""}