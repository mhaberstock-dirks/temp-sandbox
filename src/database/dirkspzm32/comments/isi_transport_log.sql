comment on table dirkspzm32.isi_transport_log is
    'Loggen der Transportaktionen (Statusänderung)';

comment on column dirkspzm32.isi_transport_log.arbeitsplatz_id is
    'An/Mit welchem Arbeitsplatz (Terminal) wurde die Prüfung ausgeführt';

comment on column dirkspzm32.isi_transport_log.check_passed is
    'T = Prüfung konnte bestätigt werden, F = Prüfung konnte nicht bestätigt werden, NULL = keine gültige Prüfung erfolgt';

comment on column dirkspzm32.isi_transport_log.check_q_eti_typ is
    'VDA, CCG, NOBC = kein Barcode (manuelle Eingabe), CUST (kundenspezifischer Barcode)';

comment on column dirkspzm32.isi_transport_log.check_typ is
    'we_eti, we_lgr, wa_eti, wa_lgr_z, wa_lgr_q';

comment on column dirkspzm32.isi_transport_log.login_id is
    'Falls vorhanden, Login ID des Benutzers, der die Aktion durchgeführt hat';

comment on column dirkspzm32.isi_transport_log.log_typ is
    'STAT = Statusänderung, CHECK = Prüfung durch User';

comment on column dirkspzm32.isi_transport_log.lte_id is
    'Lte die Transportiert wird';

comment on column dirkspzm32.isi_transport_log.parent_transp_id is
    'PARENT_TRANSP_ID für diesen Auftrag';

comment on column dirkspzm32.isi_transport_log.res_id is
    'res_id des Transports';

comment on column dirkspzm32.isi_transport_log.scan_data is
    'Welche Daten wurden gescannt';

comment on column dirkspzm32.isi_transport_log.status is
    'F=Frei,
G=Gesperrt,
Z=Zugewiesen,
B=Begonnen (Resource bewegt sich zur LTE),
T=LTE wird transportiert,
D=Transport in die HIST Tabelle eingetragen
E=Fertig Ende';

comment on column dirkspzm32.isi_transport_log.status_ts is
    'Zeitpunkt des Status oder Check';

comment on column dirkspzm32.isi_transport_log.transaction_id is
    'transactionsid für die transprot Buchung';

comment on column dirkspzm32.isi_transport_log.transport_gruppe is
    'Tour Nr ';

comment on column dirkspzm32.isi_transport_log.transp_id is
    'Transport ID des Transports, dessen Status sich geändert hat';

comment on column dirkspzm32.isi_transport_log.transp_log_id is
    'Laufende Nummer des Logeintrags (seq_transp_log_id)';


-- sqlcl_snapshot {"hash":"ece73b792ffb05a9e846836939c0a4478ba71bbd","type":"COMMENT","name":"isi_transport_log","schemaName":"dirkspzm32","sxml":""}