comment on table dirkspzm32.pps_arb_plan_ag_res_id_liste is
    'PPS Liste der Resourcen, die diesen Arbeitsgang fertigen können.';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.ag_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.arb_plan_id is
    'Arbeitsplan, dem dieser AG zugeordnet werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.arb_plan_pos_id is
    'Eindeutige ID der Position für die Verbindung zur STL';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.firma_nr is
    'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.maschinenzeitfaktor is
    'Faktor auf Arbeitsplatzzeit der Position bei Wahl dieses Arbeitsplatzes';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.nio_res_id is
    'Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.res_id is
    'Resource(ngruppe), die für die Produktion eingesetzt werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.sid is
    'Datenbank dieser Firma';

comment on column dirkspzm32.pps_arb_plan_ag_res_id_liste.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';


-- sqlcl_snapshot {"hash":"737ee95875d937249171921171920d77adcce7d7","type":"COMMENT","name":"pps_arb_plan_ag_res_id_liste","schemaName":"dirkspzm32","sxml":""}