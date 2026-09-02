comment on table S_MFR_SEND_OFFLINE is 'Offline Bewegungen für ein Hostsystem aus dem MFR ';
comment on column S_MFR_SEND_OFFLINE."AUF_ID" is 'eindeutige Sequenz-Nummer des Hostauftrags';
comment on column S_MFR_SEND_OFFLINE."AUFTRAG" is 'Auftragsnummer vom Host';
comment on column S_MFR_SEND_OFFLINE."FIRMA_NR" is 'Mandant z.B. 01';
comment on column S_MFR_SEND_OFFLINE."FUNKTION" is 'z.B. 101 = einlagern .....';
comment on column S_MFR_SEND_OFFLINE."GEN_DATUM" is 'Generierungsdatum';
comment on column S_MFR_SEND_OFFLINE."GRUPPE" is 'Gruppe z.B. Zusammenfassung einer Übertragungsgruppe ';
comment on column S_MFR_SEND_OFFLINE."LTE_ID" is 'transportierte LTE ';
comment on column S_MFR_SEND_OFFLINE."OFFLINE_ID" is 'Eindeutige ID der OFFLINE-Buchung';
comment on column S_MFR_SEND_OFFLINE."QUELLE" is 'Transport Quelle nur Info';
comment on column S_MFR_SEND_OFFLINE."SATZART" is 'BE = Bestellung LI = Anstehende Lieferung';
comment on column S_MFR_SEND_OFFLINE."TELEGRAMM" is 'Telegramm das versendet werden soll ';
comment on column S_MFR_SEND_OFFLINE."ZIEL" is 'Transport Ziel nur Info';



-- sqlcl_snapshot {"hash":"ceb243db7372fe9885d0d255045aac2106a480fc","type":"COMMENT","name":"s_mfr_send_offline","schemaName":"dirkspzm32","sxml":""}