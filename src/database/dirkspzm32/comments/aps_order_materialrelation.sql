comment on table dirkspzm32.aps_order_materialrelation is
    'Bedarf-Materialbeziehungen';

comment on column dirkspzm32.aps_order_materialrelation.aps_plan_status is
    'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig'
    ;

comment on column dirkspzm32.aps_order_materialrelation.auftrag_nr is
    'Auftragsnummer';

comment on column dirkspzm32.aps_order_materialrelation.bearb_datum is
    'Bearbeitungsdatum, zuletzt bearbeitet am';

comment on column dirkspzm32.aps_order_materialrelation.child_artikel_id is
    'Artikel-ID des Materials';

comment on column dirkspzm32.aps_order_materialrelation.child_id is
    'ID des materialbereitstellenden Objekts -1, wenn keinen Deckung (Typ 0 und 1), LTE_ID bei Lagerbestand, APS_PLAN_AUFTRAG bei Fertigung,  Bei Bestellung - AUF_ID der Bestellung'
    ;

comment on column dirkspzm32.aps_order_materialrelation.erstell_datum is
    'Erstellungsdatum, erstellt am';

comment on column dirkspzm32.aps_order_materialrelation.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.aps_order_materialrelation.fixed is
    'legt fest, ob die Beziehung bei der Planung erhalten bleiben soll
Wahrheitstyp
0 = nein, 1 = ja';

comment on column dirkspzm32.aps_order_materialrelation.info_date_availability is
    'informatives Feld zur Definition des Bereitstellungszeitpunktes';

comment on column dirkspzm32.aps_order_materialrelation.info_time_buffer is
    'informatives Feld zur Definition des maximal verbleibenden Zeitpuffers [s]';

comment on column dirkspzm32.aps_order_materialrelation.materialrelation_info is
    'Information über die Relation. Bsp.
Valide aus der Vorplanung mit Lagerbestand übernommen
Valide in der Planung mit Lagerbestand gedeckt
Valide konkrete Deckung durch Fertigungsaufträge
Valide Deckung durch die Planung (Reifen - Komponenten herstellerein verfügbar)
Planauftrag, keine Deckung der Komponenten';

comment on column dirkspzm32.aps_order_materialrelation.materialrelation_type is
    'Materialbeziehungstyp (von welchem Typ ist das materialbereitstellende Objekt)
Materialbeziehungstyp
Wert Bezeichnung Beschreibung
0 Keine Relation erstellt (Ungeprüft)
1 Materialfehler Material fehlt (niemand liefert)
2 Fertigungsauftrag Fertigungsauftrag liefert Material
4 Bestellung Lieferantenbestellung liefert Material
8 Lager Material wird aus Lager genommen
128 prognostizierter Primärbedarf Bedarf wird mit diesem Prognosebedarf verrechnet (nur für Prognosebedarf)
256 prognostizierter Sekundärbedarf Fertigungsauftrag wird mit diesem Prognosebedarf verrechnet (nur für Prognosebedarf)';

comment on column dirkspzm32.aps_order_materialrelation.materialrelation_valide is
    'Ist die Relation valide T/F Aus lagerbestand immer valiede, bei der Produktion müssen alle Komponenten (Rad und Reifen) verfügbar sein'
    ;

comment on column dirkspzm32.aps_order_materialrelation.menge is
    'bereitgestellte Materialmenge [Einheit]
Wird die Menge nicht übergeben, so gilt die gesamte Menge des bereitstellenden Objekts';

comment on column dirkspzm32.aps_order_materialrelation.pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.aps_order_materialrelation.quantity_unit_id is
    'Einheit der bereitgestellten Menge';

comment on column dirkspzm32.aps_order_materialrelation.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.aps_order_materialrelation.upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';


-- sqlcl_snapshot {"hash":"1f9d4e9c46b77cdac71135d939d81d4683775ca8","type":"COMMENT","name":"aps_order_materialrelation","schemaName":"dirkspzm32","sxml":""}