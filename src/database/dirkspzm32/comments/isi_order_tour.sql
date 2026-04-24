comment on table dirkspzm32.isi_order_tour is
    'Tour zu Ladelisten oder Auslagerungen m it Kommission die zum Transport anstehen';

comment on column dirkspzm32.isi_order_tour.komm_zeit_sec is
    'Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ aller Quellgebinde für alle Positionen';

comment on column dirkspzm32.isi_order_tour.pack_lgr_platz is
    'Reservierter Packplatz nachdem er zugeordnet wurde';

comment on column dirkspzm32.isi_order_tour.startzeitpunkt_berechnet is
    'Berechneter Startzeitpunkt für die erste Posion dieser Klammer';

comment on column dirkspzm32.isi_order_tour.tour is
    'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';

comment on column dirkspzm32.isi_order_tour.transp_zeit_sec is
    'Benötigte Zeit in Sekunden für den Transport der Gebinde. Da Transporte parallel durchgefürt werden, ist hier nicht die Summierte Arbeitszeit hinterlegt, sondern der benötigte Zeitraum der für den gesamten Transport benötigt wird.'
    ;

comment on column dirkspzm32.isi_order_tour.vorgang_id is
    'Nummer um die Positionen zu Klammern Z.B. Tourennummer';


-- sqlcl_snapshot {"hash":"2efc1d3f72f4a10e2ab6b5071f29060de3ba994f","type":"COMMENT","name":"isi_order_tour","schemaName":"dirkspzm32","sxml":""}