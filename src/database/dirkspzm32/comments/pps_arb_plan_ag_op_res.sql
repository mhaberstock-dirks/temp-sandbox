comment on table dirkspzm32.pps_arb_plan_ag_op_res is
    'Vorgänger Nachfolger Relation für diesen FA';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.ag_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.arb_plan_id is
    'Arbeitsplan, dem dieser AG zugeordnet werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.arb_plan_pos_id is
    'Eindeutige ID der Position für die Verbindung zur STL';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.delta is
    'Prozentualer Ressourcenkostenaufschlag, sofern diese Alternative verwendet wird.
Es kann ein beliebiger Wert eingestellt werden, auch negativ. Für die endgültige Entscheidung werden dann weiterhin Verspätungskosten, Stillstandskosten,
FHM-Prioritäten usw. hinzugezogen. Darauf hat das Delta keinen Einfluss mehr. Auf die finale Bewertung der Kosten für das Ergebnis, Reports usw. hat das Delta
auch keinen Einfluss.
0% = alle alternativen Arbeitsplätze sind gleichwertig';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.firma_nr is
    'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.lot_size_max is
    'maximale vorgangsspezifische Losgröße, die Angabe erfolgt in der Losgrößen-Einheit laut Arbeitsplatz-Stamm (lot_size_unit_id)
-1 = Vorgabe aus Arbeitsplatz-Stamm gilt';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.lot_size_min is
    'minimale vorgangsspezifische Losgröße, die Angabe erfolgt in der Losgrößen-Einheit laut Arbeitsplatz-Stamm (lot_size_unit_id)
-1 = Vorgabe aus Arbeitsplatz-Stamm gilt';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.res_id is
    'ID der Maschine / Arbeitsplatz';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.sid is
    'Datenbank dieser Firma';

comment on column dirkspzm32.pps_arb_plan_ag_op_res.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';


-- sqlcl_snapshot {"hash":"de738741b26fe5cd29e45584be4a5bca1a69599e","type":"COMMENT","name":"pps_arb_plan_ag_op_res","schemaName":"dirkspzm32","sxml":""}