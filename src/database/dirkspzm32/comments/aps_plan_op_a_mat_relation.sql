comment on table DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION is 'Produktionauftragsbeziehungen';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."ACTIVITY_ID" is 'ID der Vorgangsposition
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."APS_PLAN_AG" is 'FA.FA_AG auftragsinterne, eindeutige ID des Vorgangs (muss der operation_id der zugeordneten Arbeitsplan-Vorgang-Position entsprechen)';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."APS_PLAN_AG_UPOS" is 'FA.FA_AG auftragsinterne, eindeutige ID des des Splits im Vorgangs';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."APS_PLAN_AUFTRAG_NR" is 'eindeutige ID des Fertigungsauftrags';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."APS_PLAN_STATUS" is 'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."BEARB_DATUM" is 'Bearbeitungsdatum, zuletzt bearbeitet am';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."CHILD_ACTIVITY_ID" is 'MATERIALRELATION_TYPE=2 Fertigungsauftrag - ID der Vorgangsposition des Sekundär-FAs
*2';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."CHILD_ARTIKEL_ID" is 'Artikel-ID des Materials';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."CHILD_AUF_ID" is 'MATERIALRELATION_TYPE=4 Bestellung - AUF_ID der Bestellung';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."CHILD_ID" is 'ID des materialbereitstellenden Objekts LTE_ID bei Lagerbestand, APS_PLAN_AUFTRAG bei Fertigung,  Bei Bestellung - AUF_ID der Bestellung';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."CHILD_LTE_ID" is 'MATERIALRELATION_TYPE=8 Lagerbestand gedeckt durch LTE_ID';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."CHILD_PLAN_AG" is 'MATERIALRELATION_TYPE=2 Fertigungsauftrag - ID des Vorgangs des Sekundär-FAs
*2';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."CHILD_PLAN_AG_UPOS" is 'MATERIALRELATION_TYPE=2 Fertigungsauftrag - ID des Vorgangssplits des Sekundär-FA
*2"';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."ERSTELL_DATUM" is 'Erstellungsdatum, erstellt am';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."FIXED" is 'legt fest, ob die Beziehung bei der Planung erhalten bleiben soll
Wahrheitstyp
0 = nein, 1 = ja';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."INFO_DATE_AVAILABILITY" is 'informatives Feld zur Definition des Bereitstellungszeitpunktes';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."INFO_TIME_BUFFER" is 'informatives Feld zur Definition des maximal verbleibenden Zeitpuffers [s]';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."MATERIALRELATION_INFO" is 'Information über die Relation. Bsp. 
Valide aus der Vorplanung mit Lagerbestand übernommen
Valide in der Planung mit Lagerbestand gedeckt
Valide konkrete Deckung durch Fertigungsaufträge
Valide Deckung durch die Planung (Rad und Reifen (Herstellerein) - Komponenten verfügbar)
Planauftrag, keine Deckung der Komponenten';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."MATERIALRELATION_TYPE" is 'Materialbeziehungstyp (von welchem Typ ist das materialbereitstellende Objekt)
Materialbeziehungstyp
Wert Bezeichnung Beschreibung
0 Noch keine Relationerstellt
1 Materialfehler Material fehlt (niemand liefert)
2 Fertigungsauftrag Fertigungsauftrag liefert Material
4 Bestellung Lieferantenbestellung liefert Material
8 Lager Material wird aus Lager genommen
128 prognostizierter Primärbedarf Bedarf wird mit diesem Prognosebedarf verrechnet (nur für Prognosebedarf)
256 prognostizierter Sekundärbedarf Fertigungsauftrag wird mit diesem Prognosebedarf verrechnet (nur für Prognosebedarf)';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."MATERIALRELATION_VALIDE" is 'Ist die Relation valide T/F Aus lagerbestand immer valiede, bei der Produktion müssen alle Komponenten (Rad und Reifen) verfügbar sein';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."MENGE" is 'bereitgestellte Materialmenge [Einheit]
Wird die Menge nicht übergeben, so gilt die gesamte Menge des bereitstellenden Objekts';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."OVERLAP_VALUE" is 'erlaubte Überlappung zwischen Primär- und Sekundärauftrag [%]
Werte 0 – 100%';
comment on column DIRKSPZM32.APS_PLAN_OP_A_MAT_RELATION."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"3b4787449788efa88ca08db82988c1bdb2c2c06e","type":"COMMENT","name":"aps_plan_op_a_mat_relation","schemaName":"dirkspzm32","sxml":""}