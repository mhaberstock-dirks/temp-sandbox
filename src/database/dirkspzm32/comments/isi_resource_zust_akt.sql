comment on column dirkspzm32.isi_resource_zust_akt.abfuell_abschalt_fein is
    'Absch. Fein';

comment on column dirkspzm32.isi_resource_zust_akt.abfuell_abschalt_grob is
    'Absch. Grob';

comment on column dirkspzm32.isi_resource_zust_akt.abfuell_abschalt_mittel is
    'Absch. Mittel';

comment on column dirkspzm32.isi_resource_zust_akt.abfuell_brutto is
    'Istmenge für der Abfüllung Brutto';

comment on column dirkspzm32.isi_resource_zust_akt.abfuell_ist is
    'Sollmenge für die Abfüllung';

comment on column dirkspzm32.isi_resource_zust_akt.abfuell_silo is
    'Silo für Abfüllung';

comment on column dirkspzm32.isi_resource_zust_akt.abfuell_soll is
    'Sollmenge für die Abfüllung';

comment on column dirkspzm32.isi_resource_zust_akt.abfuell_tara is
    'Istmenge für der Abfüllung TARA';

comment on column dirkspzm32.isi_resource_zust_akt.abfuell_toleranz_minus is
    'Toleranz Minus';

comment on column dirkspzm32.isi_resource_zust_akt.abfuell_toleranz_plus is
    'Toleranz Plus';

comment on column dirkspzm32.isi_resource_zust_akt.akt_aufgabe is
    'Akt. Aufgabe P=Produzieren R=Rüsten NULL=Kein Auftrag angemeldtet';

comment on column dirkspzm32.isi_resource_zust_akt.akt_aufgabe_seit is
    'Seit wann ist die Aufgabe angemeldtet';

comment on column dirkspzm32.isi_resource_zust_akt.akt_sequenz_seit is
    'Datum Uhrzeit, wann die aktuelle Sequenz auf dieser Resource begonnen wurde';

comment on column dirkspzm32.isi_resource_zust_akt.akt_terminal is
    'An welchem Termial wurder der Auftrag angemeldet (Für Etikettendruck)';

comment on column dirkspzm32.isi_resource_zust_akt.auftrag_status is
    'Auftrags Online Status:
Neu nur gesendet, noch nicht begonnen = ''G'';
Frei=''F''  Kein Auftrag Resource ist Leer !;
Daten=''D'' Resource hat Daten;
AuftrLaeuft=''L'' Resource mit Auftag Gestartet;
AuftrStop  =''S'' Auftrag vom Bediener gestoppt  (Nur bei Absackwaagen ! );
AuftrEnde  =''E'' Resource Fertig produziert! Soll>=Ist ;
AuftrBeenden =''B'' Recource beendet. Aktueller Zustand z.B. Leerfahren !;
Error ''E'' = Error';

comment on column dirkspzm32.isi_resource_zust_akt.fa_ag is
    'Aktueller Arbeitsgang der Leitzahl';

comment on column dirkspzm32.isi_resource_zust_akt.fa_seit is
    'Zeitpunkt, wann ein AG angemeldet wurde, oder wann das letzte Paket die Maschine verlassen hat, um den Produktionsbeginn des nächsten Pakets zu bestimmen'
    ;

comment on column dirkspzm32.isi_resource_zust_akt.fa_upos is
    'Unterposition des AG bei Gruppenarbeit';

comment on column dirkspzm32.isi_resource_zust_akt.fehler_res_id is
    'Konkrete eingebaute Resource an der ein Fehler aufgetreten ist';

comment on column dirkspzm32.isi_resource_zust_akt.fert_lam_id is
    'LAM_ID der aktuellen LAM_ID, die in diesem Moment gefertigt wird';

comment on column dirkspzm32.isi_resource_zust_akt.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_resource_zust_akt.leitzahl is
    'Fertigungsauftrag Nr. (Leitzahl)';

comment on column dirkspzm32.isi_resource_zust_akt.ls_login_id is
    'Aktuelles Login auf dieser Maschine für Link zum Scanner';

comment on column dirkspzm32.isi_resource_zust_akt.lte_id is
    'Aktueller Ladungsträger auf dem die Produktion gestellt wird';

comment on column dirkspzm32.isi_resource_zust_akt.mde_communication is
    'F = Keine MDE Erfassung;
T = MDE-Daten sollen erfaast werden
O = MDE-Daten werden erfasst. MDE-Schnittstelle ist online
E = MDE-Daten sollen erfaast werden, MDE ist OFFLINE (Error)';

comment on column dirkspzm32.isi_resource_zust_akt.pers_nr is
    'Personalnummer des Maschinenführeres';

comment on column dirkspzm32.isi_resource_zust_akt.prod_params is
    'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';

comment on column dirkspzm32.isi_resource_zust_akt.p_plan_nr is
    'Prüfplannummer zur Prüfplanreferenz (GTP zum Rezept)';

comment on column dirkspzm32.isi_resource_zust_akt.p_plan_ref is
    'Referenz zum Prüfplan (GTP-Rezept)';

comment on column dirkspzm32.isi_resource_zust_akt.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk';

comment on column dirkspzm32.isi_resource_zust_akt.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_resource_zust_akt.status_id is
    'Akt Status ID';

comment on column dirkspzm32.isi_resource_zust_akt.status_seit is
    'Akt. Status seit (Datum Zeit)';


-- sqlcl_snapshot {"hash":"ae2f7045df51abae51b6d4cdef4c8f298cc21462","type":"COMMENT","name":"isi_resource_zust_akt","schemaName":"dirkspzm32","sxml":""}