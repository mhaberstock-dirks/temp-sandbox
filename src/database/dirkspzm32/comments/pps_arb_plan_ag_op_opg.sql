comment on table dirkspzm32.pps_arb_plan_ag_op_opg is
    'Optimierungen - Gruppe Realation';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.ag_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.arb_plan_id is
    'Arbeitsplan, dem dieser AG zugeordnet werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.arb_plan_pos_id is
    'Eindeutige ID der Position für die Verbindung zur STL';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.firma_nr is
    'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.optimierungsgruppen_id is
    'ID der Optimierungsgruppe
Wenn ID leer ist, dann gilt keine Optimierungsgruppe (auch nicht die aus dem Materialstamm)';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.optimierungsgruppen_typ is
    'gibt an, welche Optimierungen von dieser Gruppe abhängen
Optimierungsgruppentyp
Wert Bezeichnung Beschreibung
1 statisch rüsten Statische Rüstpositionen werden bei gleicher Optimierungsgruppe reduziert.
2 dynamisch rüsten Dynamische Rüstpositionen werden entsprechend der Umrüstmatrix reduziert.
4 parallele Belegung Aufträge werden parallel auf eine Ressource geplant.
jeder Typ darf nur einmal pro Vorgang verwendet werden';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.optimierungsgruppen_value is
    'wertmäßige Ausprägung der Optimierungsgruppe
Das Merkmal darf nur entsprechend der Angabe in der Optimierungsgruppe maximal abweichen (Toleranz), damit gleiche Optimierungsgruppen zueinander
als kompatibel gelten. (Bei Kompatibilität würde z.B. die eingestellte Dauer aus der Diagonalen der Rüstmatrix nicht verwendet werden)'
    ;

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.sid is
    'Datenbank dieser Firma';

comment on column dirkspzm32.pps_arb_plan_ag_op_opg.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';


-- sqlcl_snapshot {"hash":"f4a54e0a158357d67bf748d71a9189c85542529e","type":"COMMENT","name":"pps_arb_plan_ag_op_opg","schemaName":"dirkspzm32","sxml":""}