comment on table EMS_ARTIKEL is 'Leergutartikel';
comment on column EMS_ARTIKEL."AEND_DATUM" is 'Datum, an dem dieser Datensatz zuletzt geändert wurde';
comment on column EMS_ARTIKEL."AEND_LOGIN_ID" is 'LoginID des Benutzers, der diesen Datensatz zuletzt geändert hat';
comment on column EMS_ARTIKEL."AKTIV" is 'Kennzeichen, ob der Leergutartikel bei aktiven Buchungen genutzt werden kann';
comment on column EMS_ARTIKEL."ARTIKEL_ID" is 'ggf. Referenz auf einen Artikel im Artikelstamm';
comment on column EMS_ARTIKEL."BESCHREIBUNG" is 'freier Text zur Beschreibung der Leergutartikels';
comment on column EMS_ARTIKEL."EMS_ART_GRUPPE_ID" is 'Referenz auf die Leergutartikelgruppe';
comment on column EMS_ARTIKEL."EMS_ART_NAME" is 'Name des Leergutartikels';
comment on column EMS_ARTIKEL."EMS_ART_TEXT" is 'lange Namensform für den Leergutartikel (Caption)';
comment on column EMS_ARTIKEL."ERZ_DATUM" is 'Datum, an dem dieser Datensatz angelegt wurde';
comment on column EMS_ARTIKEL."ERZ_LOGIN_ID" is 'LoginID des Benutzers, der diesen Datensatz angelegt hat';
comment on column EMS_ARTIKEL."FOTO_DATEI_K" is 'Dateiname eines kleinen Fotos vom Leergutartikel';
comment on column EMS_ARTIKEL."FOTO_DATEI_N" is 'Dateiname eines normalen Fotos vom Leergutartikel';
comment on column EMS_ARTIKEL."GEWICHT_KG" is 'Gewicht des Leergutartikels in kg';
comment on column EMS_ARTIKEL."LHM_NAME" is 'ggf. Referenz auf den LHM_NAME im LVS';
comment on column EMS_ARTIKEL."LTE_NAME" is 'ggf. Referenz auf den LTE_NAME im LVS';
comment on column EMS_ARTIKEL."MENGEN_EINHEIT" is 'Mengeneinheit: STK = Stück, ...';



-- sqlcl_snapshot {"hash":"b69cf5db6b631398fd7fbb36dff670f90837444b","type":"COMMENT","name":"ems_artikel","schemaName":"dirkspzm32","sxml":""}