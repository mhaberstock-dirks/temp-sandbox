comment on table dirkspzm32.isi_kpi_ring_buffer_cfg is
    'KPI Persistierung für Reportind oder historische Betrachtung ';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.buffer_anzahl_werte is
    'Wie viele KPI-Werte sollen im Ring-Buffer gehalten werden. 0 = unendlich oder nur durch zeitliche Begrenzung';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.buffer_max_zeit_tage is
    'Wie viele Zeit in Tagen sollen im Ring-Buffer gehalten werden. 0 = unendlich oder nur max Anzahl Werte';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.created_login_id is
    'Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.isi_kpi_id is
    'Identifier Referenz zu ISI_KPI R4-DAL';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.kpi_name is
    'Name als Refenz zur Anzeigeposition im Dashboard ';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.kpi_sel_param is
    'Selektionsparameter um eine KPI für bestimmte Filggf. Kundenspezifisch einzutragen';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.isi_kpi_ring_buffer_cfg.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"28f9f09f246d37c0675588f46b29b0fd8b2d27e8","type":"COMMENT","name":"isi_kpi_ring_buffer_cfg","schemaName":"dirkspzm32","sxml":""}