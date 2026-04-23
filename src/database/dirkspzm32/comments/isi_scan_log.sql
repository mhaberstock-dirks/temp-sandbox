comment on table dirkspzm32.isi_scan_log is
    'Logtabelle für Scannungen während der IBS';

comment on column dirkspzm32.isi_scan_log.error_txt is
    'Erläuternder Text bei fehlerhafter Scannung';

comment on column dirkspzm32.isi_scan_log.isi_scan_log_id is
    'Fortlaufende ID des Log-Eintrags';

comment on column dirkspzm32.isi_scan_log.leitzahl is
    'Fertigungsauftragsnummer / Leitzahl';

comment on column dirkspzm32.isi_scan_log.lhm_id is
    'Lagerhilfsmittel-ID (Barcode auf dem Karton)';

comment on column dirkspzm32.isi_scan_log.log_time is
    'Zeitpunkt des Logeintrags';

comment on column dirkspzm32.isi_scan_log.lte_id is
    'ID der Transporteinheit an der Maschine';

comment on column dirkspzm32.isi_scan_log.pers_nr is
    'Personalnummer des Maschinenführers';

comment on column dirkspzm32.isi_scan_log.res_aufgabe is
    'Aufgabe der Maschine P=Produzieren R=Rüsten NULL=Kein Auftrag angemeldet';

comment on column dirkspzm32.isi_scan_log.res_id is
    'Maschinennummer';

comment on column dirkspzm32.isi_scan_log.res_status_id is
    'Maschinenstatus';

comment on column dirkspzm32.isi_scan_log.scanner_cmd is
    'Kommando-Sequenz an den Scanner';

comment on column dirkspzm32.isi_scan_log.scanner_name is
    'Name des Scanners';

comment on column dirkspzm32.isi_scan_log.scanner_read is
    'Scannerlesung: gültiger Barcode, Fehllesung oder Fehlertext';

comment on column dirkspzm32.isi_scan_log.scan_ok is
    '''T''  Scannung erfolgreich, ''F'' Scannung fehlerhaft';

comment on column dirkspzm32.isi_scan_log.sid is
    'Oracle SID';


-- sqlcl_snapshot {"hash":"4133b82502da784dc100951b4fe66b570016c2a3","type":"COMMENT","name":"isi_scan_log","schemaName":"dirkspzm32","sxml":""}