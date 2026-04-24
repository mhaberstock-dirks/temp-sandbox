comment on table dirkspzm32.aps_plan_op_a_mat_relation is
    'Produktionauftragsbeziehungen';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.activity_id is
    'ID der Vorgangsposition
*1';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.aps_plan_ag is
    'FA.FA_AG auftragsinterne, eindeutige ID des Vorgangs (muss der operation_id der zugeordneten Arbeitsplan-Vorgang-Position entsprechen)'
    ;

comment on column dirkspzm32.aps_plan_op_a_mat_relation.aps_plan_ag_upos is
    'FA.FA_AG auftragsinterne, eindeutige ID des des Splits im Vorgangs';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.aps_plan_auftrag_nr is
    'eindeutige ID des Fertigungsauftrags';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.aps_plan_status is
    'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig'
    ;

comment on column dirkspzm32.aps_plan_op_a_mat_relation.bearb_datum is
    'Bearbeitungsdatum, zuletzt bearbeitet am';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.child_activity_id is
    'MATERIALRELATION_TYPE=2 Fertigungsauftrag - ID der Vorgangsposition des Sekundär-FAs
*2';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.child_artikel_id is
    'Artikel-ID des Materials';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.child_auf_id is
    'MATERIALRELATION_TYPE=4 Bestellung - AUF_ID der Bestellung';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.child_id is
    'ID des materialbereitstellenden Objekts LTE_ID bei Lagerbestand, APS_PLAN_AUFTRAG bei Fertigung,  Bei Bestellung - AUF_ID der Bestellung'
    ;

comment on column dirkspzm32.aps_plan_op_a_mat_relation.child_lte_id is
    'MATERIALRELATION_TYPE=8 Lagerbestand gedeckt durch LTE_ID';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.child_plan_ag is
    'MATERIALRELATION_TYPE=2 Fertigungsauftrag - ID des Vorgangs des Sekundär-FAs
*2';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.child_plan_ag_upos is
    'MATERIALRELATION_TYPE=2 Fertigungsauftrag - ID des Vorgangssplits des Sekundär-FA
*2"';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.erstell_datum is
    'Erstellungsdatum, erstellt am';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.fixed is
    'legt fest, ob die Beziehung bei der Planung erhalten bleiben soll
Wahrheitstyp
0 = nein, 1 = ja';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.info_date_availability is
    'informatives Feld zur Definition des Bereitstellungszeitpunktes';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.info_time_buffer is
    'informatives Feld zur Definition des maximal verbleibenden Zeitpuffers [s]';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.materialrelation_info is
    'Information über die Relation. Bsp. 
Valide aus der Vorplanung mit Lagerbestand übernommen
Valide in der Planung mit Lagerbestand gedeckt
Valide konkrete Deckung durch Fertigungsaufträge
Valide Deckung durch die Planung (Rad und Reifen (Herstellerein) - Komponenten verfügbar)
Planauftrag, keine Deckung der Komponenten';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.materialrelation_type is
    'Materialbeziehungstyp (von welchem Typ ist das materialbereitstellende Objekt)
Materialbeziehungstyp
Wert Bezeichnung Beschreibung
0 Noch keine Relationerstellt
1 Materialfehler Material fehlt (niemand liefert)
2 Fertigungsauftrag Fertigungsauftrag liefert Material
4 Bestellung Lieferantenbestellung liefert Material
8 Lager Material wird aus Lager genommen
128 prognostizierter Primärbedarf Bedarf wird mit diesem Prognosebedarf verrechnet (nur für Prognosebedarf)
256 prognostizierter Sekundärbedarf Fertigungsauftrag wird mit diesem Prognosebedarf verrechnet (nur für Prognosebedarf)';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.materialrelation_valide is
    'Ist die Relation valide T/F Aus lagerbestand immer valiede, bei der Produktion müssen alle Komponenten (Rad und Reifen) verfügbar sein'
    ;

comment on column dirkspzm32.aps_plan_op_a_mat_relation.menge is
    'bereitgestellte Materialmenge [Einheit]
Wird die Menge nicht übergeben, so gilt die gesamte Menge des bereitstellenden Objekts';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.overlap_value is
    'erlaubte Überlappung zwischen Primär- und Sekundärauftrag [%]
Werte 0 – 100%';

comment on column dirkspzm32.aps_plan_op_a_mat_relation.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"c3cb9609072f5a7ee81392b3ceef6d344c6db7aa","type":"COMMENT","name":"aps_plan_op_a_mat_relation","schemaName":"dirkspzm32","sxml":""}