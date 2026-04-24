comment on table dirkspzm32.pps_arb_plan_ag_stl is
    'Relation Arbeitsplan - Stückliste';

comment on column dirkspzm32.pps_arb_plan_ag_stl.ag_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag_stl.arb_plan_id is
    'Arbeitsplan, dem dieser AG zugeordnet werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_stl.arb_plan_pos_id is
    'Arbeitsplan Position ';

comment on column dirkspzm32.pps_arb_plan_ag_stl.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_stl.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_stl.firma_nr is
    'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_stl.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_stl.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_stl.prod_menge_ix is
    'Index, falls die STL-Position vereinzelt werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_stl.prod_menge_p_einheit is
    'Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG';

comment on column dirkspzm32.pps_arb_plan_ag_stl.prod_menge_p_einheit_op is
    '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';

comment on column dirkspzm32.pps_arb_plan_ag_stl.prod_reihenfolge is
    'Produktionsreihenfolge (In dieser Reihenfolge wird diese Stücklisteneintrag in der Produktion verarbeitet)';

comment on column dirkspzm32.pps_arb_plan_ag_stl.sid is
    'Datenbank dieser Firma';

comment on column dirkspzm32.pps_arb_plan_ag_stl.sl_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag_stl.stueckliste_id is
    'Eindeutige Sequenz der Stückliste ';

comment on column dirkspzm32.pps_arb_plan_ag_stl.stueckliste_pos_id is
    'Zugehöriger Stücklisteneintrag';


-- sqlcl_snapshot {"hash":"3d21f6666e0ecadf3450e8a209d70010c6cfdeb4","type":"COMMENT","name":"pps_arb_plan_ag_stl","schemaName":"dirkspzm32","sxml":""}