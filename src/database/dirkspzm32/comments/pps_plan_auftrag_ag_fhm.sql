comment on table dirkspzm32.pps_plan_auftrag_ag_fhm is
    'Fertigungshilfsmittel-Liste für diesen AG im Planauftrag';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.ag_upos is
    'Unterposition / Alternative für das FHM im Arbeitsgang';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.plan_auf_ag_id is
    'Eindeutige Nummer aus SEQ';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.plan_auf_id is
    'Auftragsnummer aus PPS_PLAN_AUFTRAG';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.prod_fhm is
    'Benötigtes FHM';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.sid is
    'SID';

comment on column dirkspzm32.pps_plan_auftrag_ag_fhm.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';


-- sqlcl_snapshot {"hash":"59947ab54b1e3376950841fb63c397905fc978b2","type":"COMMENT","name":"pps_plan_auftrag_ag_fhm","schemaName":"dirkspzm32","sxml":""}