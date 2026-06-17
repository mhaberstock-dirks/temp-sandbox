comment on table DIRKSPZM32.APS_ORDER_MATERIALRELATION is 'Bedarf-Materialbeziehungen';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."APS_PLAN_STATUS" is 'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."AUFTRAG_NR" is 'Auftragsnummer';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."BEARB_DATUM" is 'Bearbeitungsdatum, zuletzt bearbeitet am';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."CHILD_ARTIKEL_ID" is 'Artikel-ID des Materials';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."CHILD_ID" is 'ID des materialbereitstellenden Objekts -1, wenn keinen Deckung (Typ 0 und 1), LTE_ID bei Lagerbestand, APS_PLAN_AUFTRAG bei Fertigung,  Bei Bestellung - AUF_ID der Bestellung';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."ERSTELL_DATUM" is 'Erstellungsdatum, erstellt am';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."FIXED" is 'legt fest, ob die Beziehung bei der Planung erhalten bleiben soll
Wahrheitstyp
0 = nein, 1 = ja';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."INFO_DATE_AVAILABILITY" is 'informatives Feld zur Definition des Bereitstellungszeitpunktes';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."INFO_TIME_BUFFER" is 'informatives Feld zur Definition des maximal verbleibenden Zeitpuffers [s]';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."MATERIALRELATION_INFO" is 'Information über die Relation. Bsp.
Valide aus der Vorplanung mit Lagerbestand übernommen
Valide in der Planung mit Lagerbestand gedeckt
Valide konkrete Deckung durch Fertigungsaufträge
Valide Deckung durch die Planung (Reifen - Komponenten herstellerein verfügbar)
Planauftrag, keine Deckung der Komponenten';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."MATERIALRELATION_TYPE" is 'Materialbeziehungstyp (von welchem Typ ist das materialbereitstellende Objekt)
Materialbeziehungstyp
Wert Bezeichnung Beschreibung
0 Keine Relation erstellt (Ungeprüft)
1 Materialfehler Material fehlt (niemand liefert)
2 Fertigungsauftrag Fertigungsauftrag liefert Material
4 Bestellung Lieferantenbestellung liefert Material
8 Lager Material wird aus Lager genommen
128 prognostizierter Primärbedarf Bedarf wird mit diesem Prognosebedarf verrechnet (nur für Prognosebedarf)
256 prognostizierter Sekundärbedarf Fertigungsauftrag wird mit diesem Prognosebedarf verrechnet (nur für Prognosebedarf)';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."MATERIALRELATION_VALIDE" is 'Ist die Relation valide T/F Aus lagerbestand immer valiede, bei der Produktion müssen alle Komponenten (Rad und Reifen) verfügbar sein';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."MENGE" is 'bereitgestellte Materialmenge [Einheit]
Wird die Menge nicht übergeben, so gilt die gesamte Menge des bereitstellenden Objekts';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."POS_NR" is 'Positionsnummer';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."QUANTITY_UNIT_ID" is 'Einheit der bereitgestellten Menge';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.APS_ORDER_MATERIALRELATION."UPOS_NR" is 'Unterposition Bsp.: Eine Position mit n Chargen etc.';



-- sqlcl_snapshot {"hash":"721d18a9c8c06c59183906ab2d115b48e8902446","type":"COMMENT","name":"aps_order_materialrelation","schemaName":"dirkspzm32","sxml":""}