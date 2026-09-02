comment on table ISI_ORDER_LI_REICHWEITE is 'Daten zur Ermittlung von Reichweiten in Sortierung nach Lieferschein';
comment on column ISI_ORDER_LI_REICHWEITE."FIRMA_NR" is 'Mandant z.B. 01';
comment on column ISI_ORDER_LI_REICHWEITE."LI_NR" is 'Lieferschein Nummer, oder die von_liefersdcheinnummer wenn für 1-n oder 0 dann für alle Lieferscheine in der TOUR';
comment on column ISI_ORDER_LI_REICHWEITE."LI_POS_ARTIKEL_ID" is 'Artikel-ID der Positionen ';
comment on column ISI_ORDER_LI_REICHWEITE."LI_POS_KOM_INFO_LIST" is 'Liste der Kom-Infos';
comment on column ISI_ORDER_LI_REICHWEITE."LI_POS_LGR_BESTAND" is 'Lagerbestand für diesen Artikel vor Lieferung dieser Positionen ';
comment on column ISI_ORDER_LI_REICHWEITE."LI_POS_LIST" is 'Liste  der Lieferscheinpositionen ';
comment on column ISI_ORDER_LI_REICHWEITE."LI_POS_MENGE" is 'benötigte Menge in den Positionen';
comment on column ISI_ORDER_LI_REICHWEITE."LI_POS_REST_LGR_BESTAND" is 'Lagerbestand für diesen Artikel nach Lieferunf dieser Positionen ';
comment on column ISI_ORDER_LI_REICHWEITE."SID" is 'Datenbank für Konsolidierung';
comment on column ISI_ORDER_LI_REICHWEITE."VORGANG_ID" is 'Nummer um die Positionen zu Klammern Z.B. Tourennummer';



-- sqlcl_snapshot {"hash":"45758b62e442fb09f22b258051cd666100d4d000","type":"COMMENT","name":"isi_order_li_reichweite","schemaName":"dirkspzm32","sxml":""}