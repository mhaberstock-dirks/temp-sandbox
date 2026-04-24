comment on table dirkspzm32.isi_order_li_rueck is
    'Rückmeldung von der Anlieferung zu einer TOUR (Lieferschein)';

comment on column dirkspzm32.isi_order_li_rueck.bis_li_nr is
    'Gilt für bis Lieferscheinnummer in der Tour';

comment on column dirkspzm32.isi_order_li_rueck.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.isi_order_li_rueck.li_nr is
    'Lieferschein Nummer, oder die von_liefersdcheinnummer wenn für 1-n oder 0 dann für alle Lieferscheine in der TOUR';

comment on column dirkspzm32.isi_order_li_rueck.lkw_am_ziel is
    'Zeitpunkt, an dem der LKW am Ziel angekommen ist';

comment on column dirkspzm32.isi_order_li_rueck.lkw_ende_entladung is
    'Zeitpunkt Ende der Verladung';

comment on column dirkspzm32.isi_order_li_rueck.lkw_start_entladung is
    'Zeitpunkt Start der Verladung';

comment on column dirkspzm32.isi_order_li_rueck.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_order_li_rueck.von_li_nr is
    'Gilt für von Lieferscheinnummer in der Tour';

comment on column dirkspzm32.isi_order_li_rueck.vorgang_id is
    'Nummer um die Positionen zu Klammern Z.B. Tourennummer';


-- sqlcl_snapshot {"hash":"42e48d31a93c0bdc59eea5492c4bd5de190228c3","type":"COMMENT","name":"isi_order_li_rueck","schemaName":"dirkspzm32","sxml":""}