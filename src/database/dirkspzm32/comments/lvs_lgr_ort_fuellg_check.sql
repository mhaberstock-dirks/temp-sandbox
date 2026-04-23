comment on table dirkspzm32.lvs_lgr_ort_fuellg_check is
    'CFG der Lagerorte zur Steuerung der Einlagerung über Füllgrad (Prüfung obmöglich)';

comment on column dirkspzm32.lvs_lgr_ort_fuellg_check.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lgr_ort_fuellg_check.lgr_gruppe_id is
    'ID Der Gruppe (Gruppe für die Zuordnung von Fahrzeugen) NULL = über alle prüfen';

comment on column dirkspzm32.lvs_lgr_ort_fuellg_check.lgr_ort is
    'Kurzname oder Nummer des Lagerorts';

comment on column dirkspzm32.lvs_lgr_ort_fuellg_check.lgr_ort_fuellg_check_id is
    'für PKey';

comment on column dirkspzm32.lvs_lgr_ort_fuellg_check.lgr_ort_fuellg_max_proz is
    'Max Prozent Befüllung für alle Einlagerungen (z.B. das Umlagerungen unf Freifahren möglich bleibt)';

comment on column dirkspzm32.lvs_lgr_ort_fuellg_check.lgr_ort_fuellg_wee_max_p is
    'Max Prozent Befüllung für Externe Anliferung ';

comment on column dirkspzm32.lvs_lgr_ort_fuellg_check.lte_name is
    'Name der LTE, die geprüft werden soll.  Generell wenn Leer dann über alle Typen prüfen';

comment on column dirkspzm32.lvs_lgr_ort_fuellg_check.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"5cdd0705241d6a48065c7cc7756ed5b215ff6672","type":"COMMENT","name":"lvs_lgr_ort_fuellg_check","schemaName":"dirkspzm32","sxml":""}