comment on table dirkspzm32.s_mfr_rcv_auftr is
    'Host aufträge für den MFR';

comment on column dirkspzm32.s_mfr_rcv_auftr.auftrag is
    'Auftragsnummer vom Host';

comment on column dirkspzm32.s_mfr_rcv_auftr.auf_id is
    'eindeutige Sequenz-Nummer';

comment on column dirkspzm32.s_mfr_rcv_auftr.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_mfr_rcv_auftr.funktion is
    'z.B. 101 = einlagern .....';

comment on column dirkspzm32.s_mfr_rcv_auftr.gen_datum is
    'Generierungsdatum';

comment on column dirkspzm32.s_mfr_rcv_auftr.lte_id is
    'transportierte LTE ';

comment on column dirkspzm32.s_mfr_rcv_auftr.quelle is
    'Transport Quelle nur Info';

comment on column dirkspzm32.s_mfr_rcv_auftr.satzart is
    'BE = Bestellung LI = Anstehende Lieferung';

comment on column dirkspzm32.s_mfr_rcv_auftr.telegramm is
    'Telegramm das versendet werden soll ';

comment on column dirkspzm32.s_mfr_rcv_auftr.ziel is
    'Transport Ziel nur Info';


-- sqlcl_snapshot {"hash":"8811f8335b6bcfeb343c14db4f1a6f89d1bcf5ea","type":"COMMENT","name":"s_mfr_rcv_auftr","schemaName":"dirkspzm32","sxml":""}