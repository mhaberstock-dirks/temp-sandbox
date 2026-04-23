comment on table dirkspzm32.pps_arb_plan_ag_op_rel is
    'Vorgänger Nachfolger Relation für diesen FA';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.ag_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.arb_plan_id is
    'Arbeitsplan, dem dieser AG zugeordnet werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.arb_plan_pos_id is
    'Eindeutige ID der Position für die Verbindung zur STL';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.firma_nr is
    'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.maxpuffer is
    'Maximaler Abstand zwichen den Vorgängen';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.maxpufferbeachten is
    'aktiviert/deaktiviert maximalen Puffer 0=nein 1=ja';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.minpuffer is
    'minimaler zeitlicher Abstand zum Nachfolger';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.nag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.narb_plan_pos_id is
    'Eindeutige ID der Position für die Verbindung zur STL';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.npos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.nvorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.sid is
    'Datenbank dieser Firma';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.ueberlappungstyp is
    'Überlappungstyp, falls Überlappungen zwischen Vorgängen geplant werden sollen 0=keine,  1=prozentual    2=Zeit in s    3=automatisch
';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_op_rel.wert is
    'Überlappungswert entsprechend dem eingestellten 0berlappungstyp
';


-- sqlcl_snapshot {"hash":"22e184969b49f6f01d1e653201e87cd169af03e7","type":"COMMENT","name":"pps_arb_plan_ag_op_rel","schemaName":"dirkspzm32","sxml":""}