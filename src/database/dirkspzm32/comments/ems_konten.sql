comment on table EMS_KONTEN is 'Leergutkonten';
comment on column EMS_KONTEN."ABSCHLUSS_DATUM_GES" is 'Datum des letzten Gesamtabschluss über alle Artikel';
comment on column EMS_KONTEN."ADRESS_ID" is 'Adresse des Kunden/Lieferanten/Unternehmers';
comment on column EMS_KONTEN."AEND_DATUM" is 'Datum, an dem dieser Datensatz zuletzt geändert wurde';
comment on column EMS_KONTEN."AEND_LOGIN_ID" is 'LoginID des Benutzers, der diesen Datensatz zuletzt geändert hat';
comment on column EMS_KONTEN."AKTIV" is 'T = dieses Konto kann für Buchungen genutzt werden, F = keine Buchungen';
comment on column EMS_KONTEN."BESCHREIBUNG" is 'freier Text zur Beschreibung des Kontos';
comment on column EMS_KONTEN."EMS_KONTO_NR" is 'Eindeutige Kontonummer aus Sequenz';
comment on column EMS_KONTEN."ERZ_DATUM" is 'Datum, an dem dieser Datensatz angelegt wurde';
comment on column EMS_KONTEN."ERZ_LOGIN_ID" is 'LoginID des Benutzers, der diesen Datensatz angelegt hat';
comment on column EMS_KONTEN."KONTO_TYP" is 'C = (counter) Zähler-Konto, (später vielleicht Vermiet- oder Mietkonto etc.)';
comment on column EMS_KONTEN."LETZTE_BUCHUNG" is 'Datum der letzten ausgeführten Buchung';



-- sqlcl_snapshot {"hash":"7e59f0f5c441c15ff177595e154b77f1783e939a","type":"COMMENT","name":"ems_konten","schemaName":"dirkspzm32","sxml":""}