comment on table DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST is 'Offline Bewegungen für ein Hostsystem aus dem MFR ';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."AUFTRAG" is 'Auftragsnummer vom Host';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."AUF_ID" is 'eindeutige Sequenz-Nummer des Hostauftrags';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."FUNKTION" is 'z.B. 101 = einlagern .....';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."GEN_DATUM" is 'Generierungsdatum';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."GRUPPE" is 'Gruppe z.B. Zusammenfassung einer Übertragungsgruppe ';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."LTE_ID" is 'transportierte LTE ';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."OFFLINE_ID" is 'Eindeutige ID der OFFLINE-Buchung';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."QUELLE" is 'Transport Quelle nur Info';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."SATZART" is 'BE = Bestellung LI = Anstehende Lieferung';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."TELEGRAMM" is 'Telegramm das versendet werden soll ';
comment on column DIRKSPZM32.S_MFR_SEND_OFFLINE_HIST."ZIEL" is 'Transport Ziel nur Info';



-- sqlcl_snapshot {"hash":"508439057b65e242b244cdc51a5c6642f74d0ebc","type":"COMMENT","name":"s_mfr_send_offline_hist","schemaName":"dirkspzm32","sxml":""}