comment on table dirkspzm32.isi_resource_lam_akt is
    'In dieser Tabelle sind alle Artikel dim LAM_ID die auf diese Maschine gebucht sind';

comment on column dirkspzm32.isi_resource_lam_akt.artikel_id is
    'Artikel ID des Artikels, der auf diese Maschine gebucht wurde (Rohstoff)';

comment on column dirkspzm32.isi_resource_lam_akt.b_datum is
    'Buchungszeitpunkt';

comment on column dirkspzm32.isi_resource_lam_akt.lam_id is
    'Lager Artikel Material ID, Eindeutige ID des Materials im Lager';

comment on column dirkspzm32.isi_resource_lam_akt.lte_id is
    'Paletten LTE ID diesen Bestands';

comment on column dirkspzm32.isi_resource_lam_akt.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk';

comment on column dirkspzm32.isi_resource_lam_akt.res_lam_params is
    'Konfigurierbare Paramter für diese Resource mit Bezug auf die aktuelle LAM';

comment on column dirkspzm32.isi_resource_lam_akt.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"b14f0eca842d4bb628ba85de204c541d652bc5db","type":"COMMENT","name":"isi_resource_lam_akt","schemaName":"dirkspzm32","sxml":""}