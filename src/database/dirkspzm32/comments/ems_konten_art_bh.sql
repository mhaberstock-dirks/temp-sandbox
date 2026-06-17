comment on table DIRKSPZM32.EMS_KONTEN_ART_BH is 'Buchungen zum Konto Salden und Informationen zu Leergutartikeln';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."AEND_DATUM" is 'Datum, an dem dieser Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."AEND_LOGIN_ID" is 'LoginID des Benutzers, der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."BEL_MENGE_NETTO" is 'Belastung Kunde/Spedition';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."EMS_ART_NAME" is 'Referenz auf Leergutartikel (EMS_ARTIKEL)';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."EMS_BELEG_NR" is 'Belegnummer aus einem vorhandenen Beleg (EMS_BELEGE)';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."EMS_KONTEN_ART_BH_ID" is 'Eindeutige ID aus Sequence';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."EMS_KONTO_NR" is 'Referenz auf Kontonummer (EMS_KONTEN)';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."ENTL_MENGE_BRUTTO" is 'Entlastung Kunde/Spedition Brutto';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."ENTL_MENGE_DEFEKT" is 'Entlastung Kunde/Spedition um diese Menge reduzieren';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."ENTL_MENGE_NETTO" is 'Entlastung Kunde/Spedition Netto';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."ERZ_DATUM" is 'Datum, an dem dieser Datensatz angelegt, gebucht wurde';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."ERZ_LOGIN_ID" is 'LoginID des Benutzers, der die Buchung erstellt hat';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."INFO" is 'freier Text';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."SALDO" is 'Endsaldo nach der Buchung';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."SALDO_VORTRAG" is 'Anfangssaldo vor der Buchung';
comment on column DIRKSPZM32.EMS_KONTEN_ART_BH."SUMME_MENGE" is 'Summe dieser Buchung Entlastung - Belastung';



-- sqlcl_snapshot {"hash":"ecf20ae43ec4f24c05f7b4d055bd8b86c40ac6f5","type":"COMMENT","name":"ems_konten_art_bh","schemaName":"dirkspzm32","sxml":""}