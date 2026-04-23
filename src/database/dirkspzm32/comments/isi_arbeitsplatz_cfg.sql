comment on table dirkspzm32.isi_arbeitsplatz_cfg is
    'Parameter die für einen Arbeitsplatz eingestellt sind (z.B. Erreichbare Lagerorte)';

comment on column dirkspzm32.isi_arbeitsplatz_cfg.app_cfg_id is
    'sequence referenz Haupttabelle';

comment on column dirkspzm32.isi_arbeitsplatz_cfg.arbeitsplatz_id is
    'Eindeutige ID';

comment on column dirkspzm32.isi_arbeitsplatz_cfg.modul_funktion is
    'z.b WE für Wareneingang';

comment on column dirkspzm32.isi_arbeitsplatz_cfg.modul_name is
    'Name des Moduls z.B. LVS,BDE,PZM';

comment on column dirkspzm32.isi_arbeitsplatz_cfg.modul_parameter is
    'welche we sind zugelassen, welche Lagerorte sind zugelassen .....';

comment on column dirkspzm32.isi_arbeitsplatz_cfg.modul_start_parameter is
    'Hiermit kann die Applikation xx z.B. seine Startparameter ablegen';


-- sqlcl_snapshot {"hash":"fbedf525353bcaddd6911a4192c152cf9d52d575","type":"COMMENT","name":"isi_arbeitsplatz_cfg","schemaName":"dirkspzm32","sxml":""}