comment on table dirkspzm32.aps_plan_op_a is
    'APS Fertigungsplan-Abeitsgänge Aktionen';

comment on column dirkspzm32.aps_plan_op_a.activity_id is
    'vorgangsinterne eindeutige ID der Vorgangsposition des oben aufgelisteten Vorgangs (muss der activity_id der zugeordneten
Arbeitsplan-Vorgang-Position entsprechen)';

comment on column dirkspzm32.aps_plan_op_a.activity_type is
    'Typ der Vorgangsposition, beschreibt, um welche Art Vorgang es sich handelt Vorgangspositionstyp
1 fertigen Positionstyp fertigen
2 rüsten Positionstyp rüsten
4 liegen Positionstyp liegen - belegt keinen Arbeitsplatz und erfordert keine Qualifikation
8 fremdfertigen Positionstyp fremdfertigen';

comment on column dirkspzm32.aps_plan_op_a.ag_bez1 is
    'Bezeichnung1 des Fertigungsauftrags';

comment on column dirkspzm32.aps_plan_op_a.ag_bez2 is
    'Bezeichnung1 des Fertigungsauftrags';

comment on column dirkspzm32.aps_plan_op_a.ag_text1 is
    'benutzerdefinierter Eintrag';

comment on column dirkspzm32.aps_plan_op_a.ag_text2 is
    'benutzerdefinierter Eintrag';

comment on column dirkspzm32.aps_plan_op_a.ag_text3 is
    'benutzerdefinierter Eintrag';

comment on column dirkspzm32.aps_plan_op_a.alternative_id is
    'Alternativen-ID des Vorgangs (muss der alternative_id der zugeordneten Arbeitsplan-Vorgang-Position entsprechen)';

comment on column dirkspzm32.aps_plan_op_a.aps_plan_ag is
    'FA.FA_AG auftragsinterne, eindeutige ID des Vorgangs (muss der operation_id der zugeordneten Arbeitsplan-Vorgang-Position entsprechen)'
    ;

comment on column dirkspzm32.aps_plan_op_a.aps_plan_ag_upos is
    'FA.FA_AG auftragsinterne, eindeutige ID des des Splits im Vorgangs';

comment on column dirkspzm32.aps_plan_op_a.aps_plan_auftrag_nr is
    'eindeutige ID des Fertigungsauftrags';

comment on column dirkspzm32.aps_plan_op_a.aps_plan_status is
    'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig'
    ;

comment on column dirkspzm32.aps_plan_op_a.bearb_datum is
    'Bearbeitungsdatum, zuletzt bearbeitet am';

comment on column dirkspzm32.aps_plan_op_a.date_end is
    'Ende der Vorgangsposition
Wird von vorhandener BDE-Meldung überschrieben';

comment on column dirkspzm32.aps_plan_op_a.date_start is
    'Start der Vorgangsposition
Wird von vorhandener BDE-Meldung überschrieben';

comment on column dirkspzm32.aps_plan_op_a.date_start_fix is
    'Fixierte Startzeit
Zeit gilt, sofern > 01.01.1900';

comment on column dirkspzm32.aps_plan_op_a.duration_fix is
    'Fixierte Dauer der Vorgangsposition in Sekunden
Wenn Wert < 0, dann keine Fixierung der Dauer';

comment on column dirkspzm32.aps_plan_op_a.earliest_start_date is
    'Frühester Starttermin der Vorgangsposition';

comment on column dirkspzm32.aps_plan_op_a.erstell_datum is
    'Erstellungsdatum, erstellt am';

comment on column dirkspzm32.aps_plan_op_a.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.aps_plan_op_a.info_date_earliest_end_initial is
    'Frühestes Ende nach Kalkulation der kleinstmöglichen Durchlaufzeit, ohne Berücksichtigung von Einkaufsmaterial
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_earliest_end_mat is
    'Frühestes Ende nach Kalkulation der kleinstmöglichen Durchlaufzeit, bei Berücksichtigung von Einkaufsmaterial
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_earliest_end_sched is
    'Frühestes Ende während der Optimierung und bei bereits teilbelegten Ressourcen
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_earliest_start_init is
    'Frühester Start nach Kalkulation der kleinstmöglichen Durchlaufzeit, ohne Berücksichtigung von Einkaufsmaterial
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_earliest_start_mat is
    'Frühester Start nach Kalkulation der kleinstmöglichen Durchlaufzeit, bei Berücksichtigung von Einkaufsmaterial
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_earliest_start_sched is
    'Spätester Start während der Optimierung und bei bereits teilbelegten Ressourcen
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_end_initial is
    'Initiale Referenz für Ende der Vorgangsposition
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_latest_end_initial is
    'Spätestes Ende nach Kalkulation der kleinstmöglichen Durchlaufzeit, ohne Berücksichtigung von Einkaufsmaterial
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_latest_end_mat is
    'Spätestes Ende nach Kalkulation der kleinstmöglichen Durchlaufzeit, bei Berücksichtigung von Einkaufsmaterial
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_latest_end_sched is
    'Spätestes Ende während der Optimierung und bei bereits teilbelegten Ressourcen
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_latest_start_initial is
    'Spätester Start nach Kalkulation der kleinstmöglichen Durchlaufzeit, ohne Berücksichtigung von Einkaufsmaterial
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_latest_start_mat is
    'Spätester Start nach Kalkulation der kleinstmöglichen Durchlaufzeit, bei Berücksichtigung von Einkaufsmaterial
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_latest_start_sched is
    'Spätester Start während der Optimierung und bei bereits teilbelegten Ressourcen
*1';

comment on column dirkspzm32.aps_plan_op_a.info_date_start_initial is
    'Initiale Referenz für Start der Vorgangsposition
*1';

comment on column dirkspzm32.aps_plan_op_a.info_debug is
    'internes Informationsfeld
*1';

comment on column dirkspzm32.aps_plan_op_a.info_duration is
    'geplante Dauer der Vorgangsposition
*1';

comment on column dirkspzm32.aps_plan_op_a.info_note is
    'Im Leitstand zu visualisierende Informationen';

comment on column dirkspzm32.aps_plan_op_a.info_setup is
    'Text mit Informationen zum Rüsten (dynamisch, statisch)
*1';

comment on column dirkspzm32.aps_plan_op_a.info_time_buffer_initial is
    'Puffer laut initialer Grobplanung
*1';

comment on column dirkspzm32.aps_plan_op_a.info_time_buffer_latest_end is
    'tatsächlicher Puffer laut aktueller Planung
*1';

comment on column dirkspzm32.aps_plan_op_a.info_time_buffer_material is
    'Puffer laut Grobplanung mit femdbezogenem Material
*1';

comment on column dirkspzm32.aps_plan_op_a.info_time_buffer_scheduling is
    'Puffer laut Grobplanung während der Optimierung
*1';

comment on column dirkspzm32.aps_plan_op_a.info_value_workcenter is
    'ermittelte Arbeitsplatzkosten
*1';

comment on column dirkspzm32.aps_plan_op_a.info_value_worker is
    'ermittelte Personalkosten
*1';

comment on column dirkspzm32.aps_plan_op_a.info_worker_utilization is
    'Prozentualer Bedienanteil des Mitarbeiters [%]
*1';

comment on column dirkspzm32.aps_plan_op_a.job_parallel_id is
    'definiert die Zugehörigkeit dieses Vorgangs zu weiteren Vorgängen, die gleichzeitig beginnen müssen';

comment on column dirkspzm32.aps_plan_op_a.job_sequential_id is
    'definiert die Zugehörigkeit dieses Vorgangs zu weiteren Vorgängen, die nacheinander beginnen müssen';

comment on column dirkspzm32.aps_plan_op_a.last_confirmation_date is
    'Zeitpunkt der letzten Teilrückmeldung
Wird von vorhandener BDE-Meldung überschrieben';

comment on column dirkspzm32.aps_plan_op_a.operation_type is
    'Typ des Vorgangs
Vorgangstyp
1 Standard Standard Arbeitsplan-Vorgang
3 Alternativ Alternativer Arbeitsplan-Vorgang kann anstelle des zugehörigen Standard Arbeitsplan-Vorgangs geplant
werden. Alternative Vorgänge können nicht gleichzeitig mit Splits verwendet werden.';

comment on column dirkspzm32.aps_plan_op_a.priority_value is
    'harte Priorität zur Reihenfolge der Einplanung von Vorgangspositionen (je höher je wichtiger)
Funktioniert nur für die erste Vorgangsposition eines Auftrags';

comment on column dirkspzm32.aps_plan_op_a.scheduling_level is
    'gibt an, wie die Vorgangsposition bei der letzten Planung eingeplant wurde
Planlevel
1 Nachzuholen Sollstart liegt vor der Ist-Linie (wurde im stabilen Zeitraum geplant, hätte schon gestartet sein sollen)
2 Stabil Sollstart liegt vor Ende des stabilen Zeitraums (wurde im stabilen Zeitraum geplant)
4 Variabel restliche Vorgänge, welche nicht stabil und auch nicht nachzuholen sind (frei eingeplant)
8 Manuell manuell geplanter/verschobener Vorgang
16 Rückgemeldet laut BDE/Rückmeldung geplanter Vorgang
32 Fixiert mit fixierter Startzeit geplanter Vorgang';

comment on column dirkspzm32.aps_plan_op_a.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.aps_plan_op_a.soll_menge is
    'Menge (ohne Ausschuss), die mit diesem Fertigungsauftrag zu fertigen ist';

comment on column dirkspzm32.aps_plan_op_a.status is
    'Fertigungszustand der Vorgangsposition
Fertigungsauftragsstatustyp
1 Ungeplant
2 Teilgeplant Nur für Fertigungsaufträge gültig.
4 Geplant
8 Gestartet
16 Teilrückgemeldet Nur für Fertigungsauftragsvorgänge gültig.
32 Beendet
Wird von vorhandener BDE-Meldung überschrieben';


-- sqlcl_snapshot {"hash":"f0ec326174e4cf5a299223c421f32a858e0461aa","type":"COMMENT","name":"aps_plan_op_a","schemaName":"dirkspzm32","sxml":""}