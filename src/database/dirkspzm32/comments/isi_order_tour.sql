comment on table DIRKSPZM32.ISI_ORDER_TOUR is 'Tour zu Ladelisten oder Auslagerungen m it Kommission die zum Transport anstehen';
comment on column DIRKSPZM32.ISI_ORDER_TOUR."KOMM_ZEIT_SEC" is 'Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für alle Positionen';
comment on column DIRKSPZM32.ISI_ORDER_TOUR."PACK_LGR_PLATZ" is 'Reservierter Packplatz nachdem er zugeordnet wurde';
comment on column DIRKSPZM32.ISI_ORDER_TOUR."STARTZEITPUNKT_BERECHNET" is 'Berechneter Startzeitpunkt für die erste Posion dieser Klammer';
comment on column DIRKSPZM32.ISI_ORDER_TOUR."TOUR" is 'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';
comment on column DIRKSPZM32.ISI_ORDER_TOUR."TRANSP_ZEIT_SEC" is 'Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.';
comment on column DIRKSPZM32.ISI_ORDER_TOUR."VORGANG_ID" is 'Nummer um die Positionen zu Klammern Z.B. Tourennummer';



-- sqlcl_snapshot {"hash":"4a467bff10efefab06bc04aa2c65d0177b5fdbe2","type":"COMMENT","name":"isi_order_tour","schemaName":"dirkspzm32","sxml":""}