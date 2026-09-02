comment on table S_MFR_RCV_AUFTR is 'Host aufträge für den MFR';
comment on column S_MFR_RCV_AUFTR."AUF_ID" is 'eindeutige Sequenz-Nummer';
comment on column S_MFR_RCV_AUFTR."AUFTRAG" is 'Auftragsnummer vom Host';
comment on column S_MFR_RCV_AUFTR."FIRMA_NR" is 'Mandant z.B. 01';
comment on column S_MFR_RCV_AUFTR."FUNKTION" is 'z.B. 101 = einlagern .....';
comment on column S_MFR_RCV_AUFTR."GEN_DATUM" is 'Generierungsdatum';
comment on column S_MFR_RCV_AUFTR."LTE_ID" is 'transportierte LTE ';
comment on column S_MFR_RCV_AUFTR."QUELLE" is 'Transport Quelle nur Info';
comment on column S_MFR_RCV_AUFTR."SATZART" is 'BE = Bestellung LI = Anstehende Lieferung';
comment on column S_MFR_RCV_AUFTR."TELEGRAMM" is 'Telegramm das versendet werden soll ';
comment on column S_MFR_RCV_AUFTR."ZIEL" is 'Transport Ziel nur Info';



-- sqlcl_snapshot {"hash":"ea3571c50ab31a41c29bc599a3905473c37ce027","type":"COMMENT","name":"s_mfr_rcv_auftr","schemaName":"dirkspzm32","sxml":""}