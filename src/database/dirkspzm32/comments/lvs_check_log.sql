comment on table dirkspzm32.lvs_check_log is
    'Loggen der Transport und Lagerprüfungen, z.B. mit Terminal (Ist das Teil auf dem richtigen Platz?)';

comment on column dirkspzm32.lvs_check_log.arbeitsplatz_id is
    'An/Mit welchem Arbeitsplatz (Terminal) wurde die Prüfung ausgeführt';

comment on column dirkspzm32.lvs_check_log.check_passed is
    'T = Prüfung konnte bestätigt werden, F = Prüfung konnte nicht bestätigt werden, U = unbekannt / keine gültige Prüfung erfolgt';

comment on column dirkspzm32.lvs_check_log.check_q_eti_typ is
    'VDA, CCG, NOBC = kein Barcode (manuelle Eingabe), CUST (kundenspezifischer Barcode), LGR =Lagerplatzbarcode';

comment on column dirkspzm32.lvs_check_log.check_ts is
    'Zeitpunkt des Checks';

comment on column dirkspzm32.lvs_check_log.check_typ is
    'ware_lgr_platz = Prüfung des Standorts der Ware, lgr_platz = Prüfung des Lagerplatzes und dessen Inhalt';

comment on column dirkspzm32.lvs_check_log.check_z_eti_typ is
    'VDA, CCG, NOBC = kein Barcode (manuelle Eingabe), CUST (kundenspezifischer Barcode), LGR =Lagerplatzbarcode';

comment on column dirkspzm32.lvs_check_log.lgr_platz is
    'Optional: um welchen Lagerplatz handelte es sich beim Check';

comment on column dirkspzm32.lvs_check_log.lhm_id is
    'Optional: um welche LHM ID handelte es sich beim Check';

comment on column dirkspzm32.lvs_check_log.login_id is
    'Falls vorhanden, Login ID des Benutzers, der die Aktion durchgeführt hat';

comment on column dirkspzm32.lvs_check_log.lte_id is
    'Optional: um welche LTE ID handelte es sich beim Check';

comment on column dirkspzm32.lvs_check_log.lvs_check_log_id is
    'Laufende Nummer des Logeintrags (seq_lvs_check_log_id)';

comment on column dirkspzm32.lvs_check_log.scan_data_1 is
    'Welche Daten wurden zum Prüfen gescannt';

comment on column dirkspzm32.lvs_check_log.scan_data_2 is
    'Welche Daten wurden zur Kontrolle (Vergleich) gescannt';

comment on column dirkspzm32.lvs_check_log.soll_data_2 is
    'Welche Daten wurden in SCAN_DATA_2 erwartet';


-- sqlcl_snapshot {"hash":"2531c99954a87afedcb738fb8eb7034edf55c17b","type":"COMMENT","name":"lvs_check_log","schemaName":"dirkspzm32","sxml":""}