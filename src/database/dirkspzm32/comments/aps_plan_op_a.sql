comment on table DIRKSPZM32.APS_PLAN_OP_A is 'APS Fertigungsplan-Abeitsgänge Aktionen';
comment on column DIRKSPZM32.APS_PLAN_OP_A."ACTIVITY_ID" is 'vorgangsinterne eindeutige ID der Vorgangsposition des oben aufgelisteten Vorgangs (muss der activity_id der zugeordneten
Arbeitsplan-Vorgang-Position entsprechen)';
comment on column DIRKSPZM32.APS_PLAN_OP_A."ACTIVITY_TYPE" is 'Typ der Vorgangsposition, beschreibt, um welche Art Vorgang es sich handelt Vorgangspositionstyp
1 fertigen Positionstyp fertigen
2 rüsten Positionstyp rüsten
4 liegen Positionstyp liegen - belegt keinen Arbeitsplatz und erfordert keine Qualifikation
8 fremdfertigen Positionstyp fremdfertigen';
comment on column DIRKSPZM32.APS_PLAN_OP_A."AG_BEZ1" is 'Bezeichnung1 des Fertigungsauftrags';
comment on column DIRKSPZM32.APS_PLAN_OP_A."AG_BEZ2" is 'Bezeichnung1 des Fertigungsauftrags';
comment on column DIRKSPZM32.APS_PLAN_OP_A."AG_TEXT1" is 'benutzerdefinierter Eintrag';
comment on column DIRKSPZM32.APS_PLAN_OP_A."AG_TEXT2" is 'benutzerdefinierter Eintrag';
comment on column DIRKSPZM32.APS_PLAN_OP_A."AG_TEXT3" is 'benutzerdefinierter Eintrag';
comment on column DIRKSPZM32.APS_PLAN_OP_A."ALTERNATIVE_ID" is 'Alternativen-ID des Vorgangs (muss der alternative_id der zugeordneten Arbeitsplan-Vorgang-Position entsprechen)';
comment on column DIRKSPZM32.APS_PLAN_OP_A."APS_PLAN_AG" is 'FA.FA_AG auftragsinterne, eindeutige ID des Vorgangs (muss der operation_id der zugeordneten Arbeitsplan-Vorgang-Position entsprechen)';
comment on column DIRKSPZM32.APS_PLAN_OP_A."APS_PLAN_AG_UPOS" is 'FA.FA_AG auftragsinterne, eindeutige ID des des Splits im Vorgangs';
comment on column DIRKSPZM32.APS_PLAN_OP_A."APS_PLAN_AUFTRAG_NR" is 'eindeutige ID des Fertigungsauftrags';
comment on column DIRKSPZM32.APS_PLAN_OP_A."APS_PLAN_STATUS" is 'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig';
comment on column DIRKSPZM32.APS_PLAN_OP_A."BEARB_DATUM" is 'Bearbeitungsdatum, zuletzt bearbeitet am';
comment on column DIRKSPZM32.APS_PLAN_OP_A."DATE_END" is 'Ende der Vorgangsposition
Wird von vorhandener BDE-Meldung überschrieben';
comment on column DIRKSPZM32.APS_PLAN_OP_A."DATE_START" is 'Start der Vorgangsposition
Wird von vorhandener BDE-Meldung überschrieben';
comment on column DIRKSPZM32.APS_PLAN_OP_A."DATE_START_FIX" is 'Fixierte Startzeit
Zeit gilt, sofern > 01.01.1900';
comment on column DIRKSPZM32.APS_PLAN_OP_A."DURATION_FIX" is 'Fixierte Dauer der Vorgangsposition in Sekunden
Wenn Wert < 0, dann keine Fixierung der Dauer';
comment on column DIRKSPZM32.APS_PLAN_OP_A."EARLIEST_START_DATE" is 'Frühester Starttermin der Vorgangsposition';
comment on column DIRKSPZM32.APS_PLAN_OP_A."ERSTELL_DATUM" is 'Erstellungsdatum, erstellt am';
comment on column DIRKSPZM32.APS_PLAN_OP_A."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_EARLIEST_END_INITIAL" is 'Frühestes Ende nach Kalkulation der kleinstmöglichen Durchlaufzeit, ohne Berücksichtigung von Einkaufsmaterial
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_EARLIEST_END_MAT" is 'Frühestes Ende nach Kalkulation der kleinstmöglichen Durchlaufzeit, bei Berücksichtigung von Einkaufsmaterial
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_EARLIEST_END_SCHED" is 'Frühestes Ende während der Optimierung und bei bereits teilbelegten Ressourcen
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_EARLIEST_START_INIT" is 'Frühester Start nach Kalkulation der kleinstmöglichen Durchlaufzeit, ohne Berücksichtigung von Einkaufsmaterial
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_EARLIEST_START_MAT" is 'Frühester Start nach Kalkulation der kleinstmöglichen Durchlaufzeit, bei Berücksichtigung von Einkaufsmaterial
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_EARLIEST_START_SCHED" is 'Spätester Start während der Optimierung und bei bereits teilbelegten Ressourcen
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_END_INITIAL" is 'Initiale Referenz für Ende der Vorgangsposition
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_LATEST_END_INITIAL" is 'Spätestes Ende nach Kalkulation der kleinstmöglichen Durchlaufzeit, ohne Berücksichtigung von Einkaufsmaterial
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_LATEST_END_MAT" is 'Spätestes Ende nach Kalkulation der kleinstmöglichen Durchlaufzeit, bei Berücksichtigung von Einkaufsmaterial
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_LATEST_END_SCHED" is 'Spätestes Ende während der Optimierung und bei bereits teilbelegten Ressourcen
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_LATEST_START_INITIAL" is 'Spätester Start nach Kalkulation der kleinstmöglichen Durchlaufzeit, ohne Berücksichtigung von Einkaufsmaterial
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_LATEST_START_MAT" is 'Spätester Start nach Kalkulation der kleinstmöglichen Durchlaufzeit, bei Berücksichtigung von Einkaufsmaterial
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_LATEST_START_SCHED" is 'Spätester Start während der Optimierung und bei bereits teilbelegten Ressourcen
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DATE_START_INITIAL" is 'Initiale Referenz für Start der Vorgangsposition
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DEBUG" is 'internes Informationsfeld
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_DURATION" is 'geplante Dauer der Vorgangsposition
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_NOTE" is 'Im Leitstand zu visualisierende Informationen';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_SETUP" is 'Text mit Informationen zum Rüsten (dynamisch, statisch)
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_TIME_BUFFER_INITIAL" is 'Puffer laut initialer Grobplanung
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_TIME_BUFFER_LATEST_END" is 'tatsächlicher Puffer laut aktueller Planung
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_TIME_BUFFER_MATERIAL" is 'Puffer laut Grobplanung mit femdbezogenem Material
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_TIME_BUFFER_SCHEDULING" is 'Puffer laut Grobplanung während der Optimierung
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_VALUE_WORKCENTER" is 'ermittelte Arbeitsplatzkosten
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_VALUE_WORKER" is 'ermittelte Personalkosten
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."INFO_WORKER_UTILIZATION" is 'Prozentualer Bedienanteil des Mitarbeiters [%]
*1';
comment on column DIRKSPZM32.APS_PLAN_OP_A."JOB_PARALLEL_ID" is 'definiert die Zugehörigkeit dieses Vorgangs zu weiteren Vorgängen, die gleichzeitig beginnen müssen';
comment on column DIRKSPZM32.APS_PLAN_OP_A."JOB_SEQUENTIAL_ID" is 'definiert die Zugehörigkeit dieses Vorgangs zu weiteren Vorgängen, die nacheinander beginnen müssen';
comment on column DIRKSPZM32.APS_PLAN_OP_A."LAST_CONFIRMATION_DATE" is 'Zeitpunkt der letzten Teilrückmeldung
Wird von vorhandener BDE-Meldung überschrieben';
comment on column DIRKSPZM32.APS_PLAN_OP_A."OPERATION_TYPE" is 'Typ des Vorgangs
Vorgangstyp
1 Standard Standard Arbeitsplan-Vorgang
3 Alternativ Alternativer Arbeitsplan-Vorgang kann anstelle des zugehörigen Standard Arbeitsplan-Vorgangs geplant
werden. Alternative Vorgänge können nicht gleichzeitig mit Splits verwendet werden.';
comment on column DIRKSPZM32.APS_PLAN_OP_A."PRIORITY_VALUE" is 'harte Priorität zur Reihenfolge der Einplanung von Vorgangspositionen (je höher je wichtiger)
Funktioniert nur für die erste Vorgangsposition eines Auftrags';
comment on column DIRKSPZM32.APS_PLAN_OP_A."SCHEDULING_LEVEL" is 'gibt an, wie die Vorgangsposition bei der letzten Planung eingeplant wurde
Planlevel
1 Nachzuholen Sollstart liegt vor der Ist-Linie (wurde im stabilen Zeitraum geplant, hätte schon gestartet sein sollen)
2 Stabil Sollstart liegt vor Ende des stabilen Zeitraums (wurde im stabilen Zeitraum geplant)
4 Variabel restliche Vorgänge, welche nicht stabil und auch nicht nachzuholen sind (frei eingeplant)
8 Manuell manuell geplanter/verschobener Vorgang
16 Rückgemeldet laut BDE/Rückmeldung geplanter Vorgang
32 Fixiert mit fixierter Startzeit geplanter Vorgang';
comment on column DIRKSPZM32.APS_PLAN_OP_A."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.APS_PLAN_OP_A."SOLL_MENGE" is 'Menge (ohne Ausschuss), die mit diesem Fertigungsauftrag zu fertigen ist';
comment on column DIRKSPZM32.APS_PLAN_OP_A."STATUS" is 'Fertigungszustand der Vorgangsposition
Fertigungsauftragsstatustyp
1 Ungeplant
2 Teilgeplant Nur für Fertigungsaufträge gültig.
4 Geplant
8 Gestartet
16 Teilrückgemeldet Nur für Fertigungsauftragsvorgänge gültig.
32 Beendet
Wird von vorhandener BDE-Meldung überschrieben';



-- sqlcl_snapshot {"hash":"e2ad3b4b65d1c5ad1dafee8337e1f29b44310eed","type":"COMMENT","name":"aps_plan_op_a","schemaName":"dirkspzm32","sxml":""}