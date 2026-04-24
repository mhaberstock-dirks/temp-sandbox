comment on table dirkspzm32.aps_plan_ausfuehrung_hist is
    'Werte, die in der Planung entstehen - Z.B.: laufzeiten und Umgebungsparameter';

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.aps_plan_stufe_id is
    'Planstufe ID - Reihenfolge';

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.aps_plan_stufe_text is
    'Planstufe Text - bezeichnung';

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.exec_bedarf is
    'Wie Viele Kundenaufträge (Bedarfe) gab es in dem Schritt';

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.exec_date_end is
    'Zeitpunkt der Ausführung Ende';

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.exec_date_start is
    'Zeitpunkt der Ausführung';

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.exec_ergebnis is
    'Wie Viele Kundenaufträge konnten mit diesem Schritt gedecket werden';

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.exec_ms is
    'Zeit in MS für den Aufruf';

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.exec_params is
    'Parameter-Stringliste der Parameter die bei der letzten Ausführung eingegeben wurde z.B. Anzahl der Kundenaufträge-Pos., gedeckt duurch Lager, gedeckt dur FA und neu geplant'
    ;

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.firma_nr is
    'FIRMA_NR';

comment on column dirkspzm32.aps_plan_ausfuehrung_hist.sid is
    'SID';


-- sqlcl_snapshot {"hash":"5d1fa64a317f73363fc89d8ec931b4551a471fda","type":"COMMENT","name":"aps_plan_ausfuehrung_hist","schemaName":"dirkspzm32","sxml":""}