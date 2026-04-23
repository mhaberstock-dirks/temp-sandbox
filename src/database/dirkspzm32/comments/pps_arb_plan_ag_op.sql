comment on table dirkspzm32.pps_arb_plan_ag_op is
    'Vorgänger Nachfolger Relation für diesen FA';

comment on column dirkspzm32.pps_arb_plan_ag_op.ag_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag_op.ag_o_name1 is
    'Bezeichnung (Klartext)';

comment on column dirkspzm32.pps_arb_plan_ag_op.ag_o_name2 is
    'Bezeichnung (Klartext) discription';

comment on column dirkspzm32.pps_arb_plan_ag_op.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_arb_plan_ag_op.arb_plan_id is
    'Arbeitsplan, dem dieser AG zugeordnet werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_op.arb_plan_pos_id is
    'Eindeutige ID der Position für die Verbindung zur STL';

comment on column dirkspzm32.pps_arb_plan_ag_op.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op.info1 is
    'Zusatztext für die Beschreibung';

comment on column dirkspzm32.pps_arb_plan_ag_op.info2 is
    'Zusatztext für die Beschreibung';

comment on column dirkspzm32.pps_arb_plan_ag_op.info3 is
    'Zusatztext für die Beschreibung';

comment on column dirkspzm32.pps_arb_plan_ag_op.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_arb_plan_ag_op.sid is
    'SID';

comment on column dirkspzm32.pps_arb_plan_ag_op.split_max is
    'Anzal der maximalen Sprints 0 = Keiner erlaubt';

comment on column dirkspzm32.pps_arb_plan_ag_op.split_min is
    'Anzal minimal Sprints 0 = Keiner erlaubt';

comment on column dirkspzm32.pps_arb_plan_ag_op.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_op.vorgangsqualifikation is
    'optionale Vorgangsqualifikation (Sonder- oder auch Tätigkeitsqualifikation), die das Personal zur Bedienung des Vorgangs benötigt'
    ;

comment on column dirkspzm32.pps_arb_plan_ag_op.vorgangstyp is
    '1 Standard Standard Arbeitsplan-Vorgang
3 Alternativ Alternativer Arbeitsplan-Vorgang kann anstelle des zugehörigen Standard Arbeitsplan-Vorgangs geplant werden. Alternative
Vorgänge können nicht gleichzeitig mit Splits verwendet werden.';


-- sqlcl_snapshot {"hash":"f01a6e67bae07a4e54833f7116cfdb5447f8810e","type":"COMMENT","name":"pps_arb_plan_ag_op","schemaName":"dirkspzm32","sxml":""}