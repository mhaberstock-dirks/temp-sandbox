comment on table dirkspzm32.pps_arb_plan_ag_fhm is
    'Benötigtes Fertigungshilfsmittel zu diesem Arbeitsgang';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.ag_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.anz_benoetigt is
    'wieviele FHMs belegt dieser Vorgang auf einem Fertigungshilfsmittel [Gantt rechnet hier in %] - Die tatsächliche Belegung wird auf ganze Zahlen abgerundet'
    ;

comment on column dirkspzm32.pps_arb_plan_ag_fhm.arb_plan_id is
    'Arbeitsplan, dem dieser AG zugeordnet werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.arb_plan_pos_id is
    'Eindeutige ID der Position für die Verbindung zur STL';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.fhm is
    'ID Fertigungshilsmittel';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.fhm_grp is
    'ID Fertigungshilsmittel Gruppe';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.firma_nr is
    'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.sid is
    'Datenbank dieser Firma';

comment on column dirkspzm32.pps_arb_plan_ag_fhm.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';


-- sqlcl_snapshot {"hash":"1610819134e7fdd8fbaccf80645dc45a0d1bca5e","type":"COMMENT","name":"pps_arb_plan_ag_fhm","schemaName":"dirkspzm32","sxml":""}