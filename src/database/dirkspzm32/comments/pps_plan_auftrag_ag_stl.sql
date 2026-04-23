comment on column dirkspzm32.pps_plan_auftrag_ag_stl.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_stl.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_stl.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_stl.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag_stl.prod_menge_ix is
    'Index, falls die STL-Position vereinzelt werden soll';

comment on column dirkspzm32.pps_plan_auftrag_ag_stl.prod_menge_p_einheit is
    'Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG';

comment on column dirkspzm32.pps_plan_auftrag_ag_stl.prod_menge_p_einheit_op is
    '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';

comment on column dirkspzm32.pps_plan_auftrag_ag_stl.prod_reihenfolge is
    'Produktionsreihenfolge (In dieser Reihenfolge wird diese Stücklisteneintrag in der Produktion verarbeitet)';


-- sqlcl_snapshot {"hash":"cdeca49fb144fb82c369a611c991c26ad855596b","type":"COMMENT","name":"pps_plan_auftrag_ag_stl","schemaName":"dirkspzm32","sxml":""}