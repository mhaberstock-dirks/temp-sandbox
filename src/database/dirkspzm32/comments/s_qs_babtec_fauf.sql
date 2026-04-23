comment on table dirkspzm32.s_qs_babtec_fauf is
    'Alle Fertigungsaufträge für Babtec QS';

comment on column dirkspzm32.s_qs_babtec_fauf.artikel is
    'Artikelnummer ';

comment on column dirkspzm32.s_qs_babtec_fauf.auftragnr is
    'AuftragNr des Fertigungsauftrags + Maschine + Julianisches Datum';

comment on column dirkspzm32.s_qs_babtec_fauf.bearb_datum is
    'Bearbeitungsdatum, zuletzt bearbeitet am';

comment on column dirkspzm32.s_qs_babtec_fauf.benutzer1 is
    'Charge (Bei Seaquist AB-TEXT-2)';

comment on column dirkspzm32.s_qs_babtec_fauf.benutzer2 is
    'Maschine';

comment on column dirkspzm32.s_qs_babtec_fauf.bestellnr is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.s_qs_babtec_fauf.erstell_datum is
    'Erstellungsdatum, erstellt am';

comment on column dirkspzm32.s_qs_babtec_fauf.fehler_code is
    'Host-Übertragung Fehlernummer';

comment on column dirkspzm32.s_qs_babtec_fauf.fehler_text is
    'Host-Übertragung Fehlertext';

comment on column dirkspzm32.s_qs_babtec_fauf.kundennr is
    'Kundennummer + Liefewradresse für den Auftrag';

comment on column dirkspzm32.s_qs_babtec_fauf.liefermenge is
    'Sollmenge aus dem Kundenauftrag (Fertigartikel)';

comment on column dirkspzm32.s_qs_babtec_fauf.mengeneinheit is
    'Mengeneinheit STK = Stück, KG = Kilogramm, L = Liter, M = Meter, M2, M3, PCK = Päckchen';

comment on column dirkspzm32.s_qs_babtec_fauf.status is
    '''N'' = Neu, UE = Übernommen, ERR=Fehler';


-- sqlcl_snapshot {"hash":"db6d9ac81b4ee232d5a8d51469d96abc2ed9ada3","type":"COMMENT","name":"s_qs_babtec_fauf","schemaName":"dirkspzm32","sxml":""}