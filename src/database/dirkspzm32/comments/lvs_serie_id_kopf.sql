comment on table dirkspzm32.lvs_serie_id_kopf is
    'Header Tabelle für die generierung von Serien';

comment on column dirkspzm32.lvs_serie_id_kopf.abnr is
    'Auftrag Bestätigungsnummer (PLEIT) oder Batch';

comment on column dirkspzm32.lvs_serie_id_kopf.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.lvs_serie_id_kopf.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.lvs_serie_id_kopf.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_serie_id_kopf.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.lvs_serie_id_kopf.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.lvs_serie_id_kopf.leitzahl is
    'Leitzahl des Fertigungsauftrags (KLEIT)';

comment on column dirkspzm32.lvs_serie_id_kopf.serie_extern_maske is
    'Maske der externen Seriennummer aus Kopf. @@@ Wird mit LFDN ersetzt';

comment on column dirkspzm32.lvs_serie_id_kopf.serie_extern_start_id is
    'Erste ID in der Serie';

comment on column dirkspzm32.lvs_serie_id_kopf.serie_gen_richtung is
    'Vorgabe ob die Serie Absteigend (AB) oder Aufsteigend (AU) generiert werden soll';

comment on column dirkspzm32.lvs_serie_id_kopf.serie_id is
    'ID Der Serie';

comment on column dirkspzm32.lvs_serie_id_kopf.serie_maske is
    'Format Vorlage nach der die ID generiert wird. @ Zeichen werden durch die laufende Nummer ersetzt';

comment on column dirkspzm32.lvs_serie_id_kopf.serie_menge is
    'Menge des Artikels die in den Fertigungsauftrag produziert werden muss';

comment on column dirkspzm32.lvs_serie_id_kopf.serie_start_id is
    'Erste ID in der Serie';

comment on column dirkspzm32.lvs_serie_id_kopf.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"f74f3f5da9a963f82ade218199117e87c6a37ef5","type":"COMMENT","name":"lvs_serie_id_kopf","schemaName":"dirkspzm32","sxml":""}