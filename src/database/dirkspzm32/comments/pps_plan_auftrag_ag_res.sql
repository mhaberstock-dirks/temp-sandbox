comment on table dirkspzm32.pps_plan_auftrag_ag_res is
    'Resourcenliste für diesen AG im Planauftrag';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.nio_res_id is
    'Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.plan_auf_ag_id is
    'Eindeutige Nummer aus SEQ';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.plan_auf_id is
    'Auftragsnummer aus PPS_PLAN_AUFTRAG';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.res_delta is
    'Angabe, um wie viel Prozent besser eine Alternativ-Ressource als die Standard-Ressource sein muss, damit sie ohne bestehenden Maschinenengpass genutzt wird 0%, d.h. alle Maschinen sind gleichwertig'
    ;

comment on column dirkspzm32.pps_plan_auftrag_ag_res.res_id is
    'Resource(ngruppe), die für die Produktion eingesetzt werden soll';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.sid is
    'SID';

comment on column dirkspzm32.pps_plan_auftrag_ag_res.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';


-- sqlcl_snapshot {"hash":"c5f85f48a14811341edf837e81e6b4726b142257","type":"COMMENT","name":"pps_plan_auftrag_ag_res","schemaName":"dirkspzm32","sxml":""}