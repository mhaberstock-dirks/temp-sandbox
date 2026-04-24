comment on column dirkspzm32.bde_pd_lam_stl_daten.aend_datum is
    'Letztes Änderungsdatum des Datensatzes';

comment on column dirkspzm32.bde_pd_lam_stl_daten.aend_login_id is
    'LoginId der Users, der die letzte Änderung gespeichert hat';

comment on column dirkspzm32.bde_pd_lam_stl_daten.fa_ag is
    'AG zu dem die Informationen und der Status gespeichert werden';

comment on column dirkspzm32.bde_pd_lam_stl_daten.fa_ag_stl_id is
    'Stücklistenposition zu der die Fertigungsdetails, -daten gespeichert werden (nicht NIO-Daten!)';

comment on column dirkspzm32.bde_pd_lam_stl_daten.fa_nr is
    'eindeutige Nummer, Fertigungsauftrags-Nr. (LEITZAHL in AG) ISIPlus PPS';

comment on column dirkspzm32.bde_pd_lam_stl_daten.fa_upos is
    'AG-UPos zu dem die Informationen und der Status gespeichert werden';

comment on column dirkspzm32.bde_pd_lam_stl_daten.fert_lam_id is
    'LAM_ID des Fertigproduktes (Fertigungseinheit)';

comment on column dirkspzm32.bde_pd_lam_stl_daten.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.bde_pd_lam_stl_daten.pd_lam_stl_daten_id is
    'Eindeutige Nummer aus Sequence';

comment on column dirkspzm32.bde_pd_lam_stl_daten.result_params is
    'Container für Fertigungsparameter / -daten die von Ressourcen automatisiert eingetragen werden können';

comment on column dirkspzm32.bde_pd_lam_stl_daten.res_id is
    'RES_ID (falls bekannt) der Ressource auf der diese LAM in diesem Schritt gefertigt werden soll / wurde';

comment on column dirkspzm32.bde_pd_lam_stl_daten.res_status_id is
    'Ressourcenstatus, der Ressource wenn der Status sich auf eine AG_STL_ID bezieht';

comment on column dirkspzm32.bde_pd_lam_stl_daten.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.bde_pd_lam_stl_daten.status is
    'aktueller Status des LAM + AG + Upos (+ AG_STL)';

comment on column dirkspzm32.bde_pd_lam_stl_daten.stl_lam_ab_menge is
    'Menge Lagerabgang für die LAM';

comment on column dirkspzm32.bde_pd_lam_stl_daten.stl_lam_id is
    'ggf. konkrete LAM_ID der Stücklistenposition';

comment on column dirkspzm32.bde_pd_lam_stl_daten.stl_lam_ist_menge is
    'Menge, die durch den normalen Verbrauch der Fertigungseinheit verbraucht (Verarbeitet) wurde';


-- sqlcl_snapshot {"hash":"74dd4815aef545cf3b4e61dafb6d8c6b96457159","type":"COMMENT","name":"bde_pd_lam_stl_daten","schemaName":"dirkspzm32","sxml":""}