comment on table dirkspzm32.isi_order_li_reichweite is
    'Daten zur Ermittlung von Reichweiten in Sortierung nach Lieferschein';

comment on column dirkspzm32.isi_order_li_reichweite.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.isi_order_li_reichweite.li_nr is
    'Lieferschein Nummer, oder die von_liefersdcheinnummer wenn für 1-n oder 0 dann für alle Lieferscheine in der TOUR';

comment on column dirkspzm32.isi_order_li_reichweite.li_pos_artikel_id is
    'Artikel-ID der Positionen ';

comment on column dirkspzm32.isi_order_li_reichweite.li_pos_kom_info_list is
    'Liste der Kom-Infos';

comment on column dirkspzm32.isi_order_li_reichweite.li_pos_lgr_bestand is
    'Lagerbestand für diesen Artikel vor Lieferung dieser Positionen ';

comment on column dirkspzm32.isi_order_li_reichweite.li_pos_list is
    'Liste  der Lieferscheinpositionen ';

comment on column dirkspzm32.isi_order_li_reichweite.li_pos_menge is
    'benötigte Menge in den Positionen';

comment on column dirkspzm32.isi_order_li_reichweite.li_pos_rest_lgr_bestand is
    'Lagerbestand für diesen Artikel nach Lieferunf dieser Positionen ';

comment on column dirkspzm32.isi_order_li_reichweite.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_order_li_reichweite.vorgang_id is
    'Nummer um die Positionen zu Klammern Z.B. Tourennummer';


-- sqlcl_snapshot {"hash":"f3fca447b286bce7709ca15ea07c12b39f01624a","type":"COMMENT","name":"isi_order_li_reichweite","schemaName":"dirkspzm32","sxml":""}