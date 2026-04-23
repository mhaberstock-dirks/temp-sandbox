comment on table dirkspzm32.isi_res_status is
    'Resourcen-Status Tabelle';

comment on column dirkspzm32.isi_res_status.fehler_res_id is
    'Konkrete eingebaute Resource an der ein Fehler aufgetreten ist';

comment on column dirkspzm32.isi_res_status.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_res_status.ls_login_id is
    'Login ID des Erfassers';

comment on column dirkspzm32.isi_res_status.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk';

comment on column dirkspzm32.isi_res_status.res_st_id is
    'ID der Statusgrunds (0 = Produktion läuft; -1 = Status undefiniert)';

comment on column dirkspzm32.isi_res_status.res_st_ug_id is
    'ID der Untergruppe';

comment on column dirkspzm32.isi_res_status.res_typ is
    'MG=MaschGruppe, MS=Maschine, WKZ=Werkzeug, ST = Stapler, LI = Linie';

comment on column dirkspzm32.isi_res_status.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_res_status.st_ende is
    'Status beendet am/um';

comment on column dirkspzm32.isi_res_status.st_start is
    'Status hat begonnen am/um';


-- sqlcl_snapshot {"hash":"b802bdb6fe7fbecb5eaf6a5a1cc63ad2d3f609be","type":"COMMENT","name":"isi_res_status","schemaName":"dirkspzm32","sxml":""}