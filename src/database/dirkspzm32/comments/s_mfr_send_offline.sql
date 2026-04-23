comment on table dirkspzm32.s_mfr_send_offline is
    'Offline Bewegungen für ein Hostsystem aus dem MFR ';

comment on column dirkspzm32.s_mfr_send_offline.auftrag is
    'Auftragsnummer vom Host';

comment on column dirkspzm32.s_mfr_send_offline.auf_id is
    'eindeutige Sequenz-Nummer des Hostauftrags';

comment on column dirkspzm32.s_mfr_send_offline.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_mfr_send_offline.funktion is
    'z.B. 101 = einlagern .....';

comment on column dirkspzm32.s_mfr_send_offline.gen_datum is
    'Generierungsdatum';

comment on column dirkspzm32.s_mfr_send_offline.gruppe is
    'Gruppe z.B. Zusammenfassung einer Übertragungsgruppe ';

comment on column dirkspzm32.s_mfr_send_offline.lte_id is
    'transportierte LTE ';

comment on column dirkspzm32.s_mfr_send_offline.offline_id is
    'Eindeutige ID der OFFLINE-Buchung';

comment on column dirkspzm32.s_mfr_send_offline.quelle is
    'Transport Quelle nur Info';

comment on column dirkspzm32.s_mfr_send_offline.satzart is
    'BE = Bestellung LI = Anstehende Lieferung';

comment on column dirkspzm32.s_mfr_send_offline.telegramm is
    'Telegramm das versendet werden soll ';

comment on column dirkspzm32.s_mfr_send_offline.ziel is
    'Transport Ziel nur Info';


-- sqlcl_snapshot {"hash":"d1181b7a3c10134c62976ad610ce0fe90f0d28a9","type":"COMMENT","name":"s_mfr_send_offline","schemaName":"dirkspzm32","sxml":""}