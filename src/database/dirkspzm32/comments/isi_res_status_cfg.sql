comment on column dirkspzm32.isi_res_status_cfg.ausfallzeit is
    'Ausfallzeit einer Resource in Stunden';

comment on column dirkspzm32.isi_res_status_cfg.fehler_schluessel is
    'Fehlerschlüssel der Resource für Gruppierung der Fehlerstati';

comment on column dirkspzm32.isi_res_status_cfg.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_res_status_cfg.res_st_id is
    'ID der Statusgrunds (0 = Produktion läuft)';

comment on column dirkspzm32.isi_res_status_cfg.res_typ is
    'MG=MaschGruppe, MS=Maschine, WKZ=Werkzeug, ST = Stapler, LI = Linie';

comment on column dirkspzm32.isi_res_status_cfg.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_res_status_cfg.st_bg_color is
    'Hintergrundfarbe der Störung';

comment on column dirkspzm32.isi_res_status_cfg.st_fg_color is
    'Fordergrundfarbe der Störung';

comment on column dirkspzm32.isi_res_status_cfg.st_gruppe is
    '(M/E/P/R) Mechanisch, Elektrisch, Produktionsbedingt oder Rüsten';

comment on column dirkspzm32.isi_res_status_cfg.st_text is
    'Bezeichnung der Störung (Hauptgruppe)';


-- sqlcl_snapshot {"hash":"8603f4da7ca5b1c115dfca87907e6a81f6b8eb29","type":"COMMENT","name":"isi_res_status_cfg","schemaName":"dirkspzm32","sxml":""}