comment on table dirkspzm32.ems_konten is
    'Leergutkonten';

comment on column dirkspzm32.ems_konten.abschluss_datum_ges is
    'Datum des letzten Gesamtabschluss über alle Artikel';

comment on column dirkspzm32.ems_konten.adress_id is
    'Adresse des Kunden/Lieferanten/Unternehmers';

comment on column dirkspzm32.ems_konten.aend_datum is
    'Datum, an dem dieser Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.ems_konten.aend_login_id is
    'LoginID des Benutzers, der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.ems_konten.aktiv is
    'T = dieses Konto kann für Buchungen genutzt werden, F = keine Buchungen';

comment on column dirkspzm32.ems_konten.beschreibung is
    'freier Text zur Beschreibung des Kontos';

comment on column dirkspzm32.ems_konten.ems_konto_nr is
    'Eindeutige Kontonummer aus Sequenz';

comment on column dirkspzm32.ems_konten.erz_datum is
    'Datum, an dem dieser Datensatz angelegt wurde';

comment on column dirkspzm32.ems_konten.erz_login_id is
    'LoginID des Benutzers, der diesen Datensatz angelegt hat';

comment on column dirkspzm32.ems_konten.konto_typ is
    'C = (counter) Zähler-Konto, (später vielleicht Vermiet- oder Mietkonto etc.)';

comment on column dirkspzm32.ems_konten.letzte_buchung is
    'Datum der letzten ausgeführten Buchung';


-- sqlcl_snapshot {"hash":"feb167f5f9024615140d01dee0c3ee522c0d8ca4","type":"COMMENT","name":"ems_konten","schemaName":"dirkspzm32","sxml":""}