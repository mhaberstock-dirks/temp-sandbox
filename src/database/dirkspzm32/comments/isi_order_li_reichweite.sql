comment on table DIRKSPZM32.ISI_ORDER_LI_REICHWEITE is 'Daten zur Ermittlung von Reichweiten in Sortierung nach Lieferschein';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."LI_NR" is 'Lieferschein Nummer, oder die von_liefersdcheinnummer wenn für 1-n oder 0 dann für alle Lieferscheine in der TOUR';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."LI_POS_ARTIKEL_ID" is 'Artikel-ID der Positionen ';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."LI_POS_KOM_INFO_LIST" is 'Liste der Kom-Infos';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."LI_POS_LGR_BESTAND" is 'Lagerbestand für diesen Artikel vor Lieferung dieser Positionen ';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."LI_POS_LIST" is 'Liste  der Lieferscheinpositionen ';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."LI_POS_MENGE" is 'benötigte Menge in den Positionen';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."LI_POS_REST_LGR_BESTAND" is 'Lagerbestand für diesen Artikel nach Lieferunf dieser Positionen ';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_ORDER_LI_REICHWEITE."VORGANG_ID" is 'Nummer um die Positionen zu Klammern Z.B. Tourennummer';



-- sqlcl_snapshot {"hash":"193c0e443b1f1e533c2e2c2f8b26a0c05f96cc15","type":"COMMENT","name":"isi_order_li_reichweite","schemaName":"dirkspzm32","sxml":""}