comment on table dirkspzm32.s_mfr_send_offline_hist is
    'Offline Bewegungen für ein Hostsystem aus dem MFR ';

comment on column dirkspzm32.s_mfr_send_offline_hist.auftrag is
    'Auftragsnummer vom Host';

comment on column dirkspzm32.s_mfr_send_offline_hist.auf_id is
    'eindeutige Sequenz-Nummer des Hostauftrags';

comment on column dirkspzm32.s_mfr_send_offline_hist.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_mfr_send_offline_hist.funktion is
    'z.B. 101 = einlagern .....';

comment on column dirkspzm32.s_mfr_send_offline_hist.gen_datum is
    'Generierungsdatum';

comment on column dirkspzm32.s_mfr_send_offline_hist.gruppe is
    'Gruppe z.B. Zusammenfassung einer Übertragungsgruppe ';

comment on column dirkspzm32.s_mfr_send_offline_hist.lte_id is
    'transportierte LTE ';

comment on column dirkspzm32.s_mfr_send_offline_hist.offline_id is
    'Eindeutige ID der OFFLINE-Buchung';

comment on column dirkspzm32.s_mfr_send_offline_hist.quelle is
    'Transport Quelle nur Info';

comment on column dirkspzm32.s_mfr_send_offline_hist.satzart is
    'BE = Bestellung LI = Anstehende Lieferung';

comment on column dirkspzm32.s_mfr_send_offline_hist.telegramm is
    'Telegramm das versendet werden soll ';

comment on column dirkspzm32.s_mfr_send_offline_hist.ziel is
    'Transport Ziel nur Info';


-- sqlcl_snapshot {"hash":"98fa59d348b53ea99fb31a0984d2e4fc5c60fbe8","type":"COMMENT","name":"s_mfr_send_offline_hist","schemaName":"dirkspzm32","sxml":""}