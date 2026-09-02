comment on table APS_PLAN_AUSFUEHRUNG_HIST is 'Werte, die in der Planung entstehen - Z.B.: laufzeiten und Umgebungsparameter';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."APS_PLAN_STUFE_ID" is 'Planstufe ID - Reihenfolge';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."APS_PLAN_STUFE_TEXT" is 'Planstufe Text - bezeichnung';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."EXEC_BEDARF" is 'Wie Viele Kundenaufträge (Bedarfe) gab es in dem Schritt';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."EXEC_DATE_END" is 'Zeitpunkt der Ausführung Ende';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."EXEC_DATE_START" is 'Zeitpunkt der Ausführung';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."EXEC_ERGEBNIS" is 'Wie Viele Kundenaufträge konnten mit diesem Schritt gedecket werden';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."EXEC_MS" is 'Zeit in MS für den Aufruf';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."EXEC_PARAMS" is 'Parameter-Stringliste der Parameter die bei der letzten Ausführung eingegeben wurde z.B. Anzahl der Kundenaufträge-Pos., gedeckt duurch Lager, gedeckt dur FA und neu geplant';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."FIRMA_NR" is 'FIRMA_NR';
comment on column APS_PLAN_AUSFUEHRUNG_HIST."SID" is 'SID';



-- sqlcl_snapshot {"hash":"5e7e69ae9fa4ff56863863136463bb39a7dcf369","type":"COMMENT","name":"aps_plan_ausfuehrung_hist","schemaName":"dirkspzm32","sxml":""}