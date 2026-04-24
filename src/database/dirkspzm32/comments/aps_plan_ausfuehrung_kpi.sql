comment on table dirkspzm32.aps_plan_ausfuehrung_kpi is
    'Werte, die in der Planung entstehen - Z.B.: laufzeiten und Umgebungsparameter';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.aps_plan_stufe_id is
    'Planstufe ID - Reihenfolge';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.aps_plan_stufe_text is
    'Planstufe Text - bezeichnung';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.counter is
    'Zähler wie oft ist die Stufe gelaufen';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_bedarf_last is
    'Wie Viele Kundenaufträge (Bedarfe) gab es in dem Schritt';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_bedarf_max is
    'Wie Viele Kundenaufträge (Bedarfe) gab es in dem Schritt';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_bedarf_min is
    'Wie Viele Kundenaufträge (Bedarfe) gab es in dem Schritt';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_date_start_last is
    'Zeitpunkt der letzten Ausführung';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_date_start_max is
    'Zeitpunkt an dem die Ausführung am meisten Zeit beanspruchte';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_date_start_min is
    'Zeitpunkt an dem die Ausführung am wenigsten Zeit beanspruchte';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_ergebnis_last is
    'Wie Viele Kundenaufträge konnten mit diesem Schritt gedecket werden';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_ergebnis_max is
    'Wie Viele Kundenaufträge konnten mit diesem Schritt gedecket werden';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_ergebnis_min is
    'Wie Viele Kundenaufträge konnten mit diesem Schritt gedecket werden';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_ms_last is
    'letzte Ausführungszeit in Millisekunden';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_ms_max is
    'maximale Ausführungszeit in Millisekunden';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_ms_min is
    'minimale Ausführungszeit in Millisekunden';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_ms_sum is
    'Summe der Zeiten aller Aufrufe die im Counter gezählt wurden';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_params_last is
    'Parameter-Stringliste der Parameter die bei der letzten Ausführung eingegeben wurde z.B. Anzahl der Kundenaufträge-Pos., gedeckt duurch Lager, gedeckt dur FA und neu geplant'
    ;

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_params_max is
    'Parameter-Stringliste der Parameter bei meisten Zeit beanspruchte z.B. Anzahl der Kundenaufträge-Pos., gedeckt duurch Lager, gedeckt dur FA und neu geplant'
    ;

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.exec_params_min is
    'Parameter-Stringliste der Parameter bei wenigsten Zeit beanspruchte z.B. Anzahl der Kundenaufträge-Pos., gedeckt duurch Lager, gedeckt dur FA und neu geplant'
    ;

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.firma_nr is
    'FIRMA_NR';

comment on column dirkspzm32.aps_plan_ausfuehrung_kpi.sid is
    'SID';


-- sqlcl_snapshot {"hash":"83df46e0d7972315e7bcb9175174fd6217cdb168","type":"COMMENT","name":"aps_plan_ausfuehrung_kpi","schemaName":"dirkspzm32","sxml":""}