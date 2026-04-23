comment on column dirkspzm32.pps_plan_auftrag_stl.artikel_id is
    'Artikel ID für die Stücklistenposition';

comment on column dirkspzm32.pps_plan_auftrag_stl.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_stl.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_plan_auftrag_stl.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.pps_plan_auftrag_stl.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_stl.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_plan_auftrag_stl.menge is
    'Menge für diesen Auftrag';

comment on column dirkspzm32.pps_plan_auftrag_stl.menge_einheit is
    'Mengeneinheit (Wenn NULL dann aus dem Artikel)';

comment on column dirkspzm32.pps_plan_auftrag_stl.plan_auf_id is
    'PLan_AUF_ID aus PPS_PLAN_AUFTRAG (FA-Auftrag)';

comment on column dirkspzm32.pps_plan_auftrag_stl.plan_auf_stl_id is
    'Eindeutige Nummer der Stücklistenposition (PLAN_AUF_ID * xx + POS_NR)';

comment on column dirkspzm32.pps_plan_auftrag_stl.pos_nr is
    'Stücklistenposition';

comment on column dirkspzm32.pps_plan_auftrag_stl.prod_menge_p_einheit is
    'Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG';

comment on column dirkspzm32.pps_plan_auftrag_stl.prod_menge_p_einheit_op is
    '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';

comment on column dirkspzm32.pps_plan_auftrag_stl.prod_params is
    'Produktionsparameter für diese Stücklistenposition für diesen Auftrag';

comment on column dirkspzm32.pps_plan_auftrag_stl.sid is
    'SID';

comment on column dirkspzm32.pps_plan_auftrag_stl.zeichnung is
    'Zeichnungsnummer für diesen Auftrag';

comment on column dirkspzm32.pps_plan_auftrag_stl.zeichnung_index is
    'Zeichnungsindex für diesen Auftrag';


-- sqlcl_snapshot {"hash":"e8ccb92f3da7dbfe70d314acbd790dc620bff1f9","type":"COMMENT","name":"pps_plan_auftrag_stl","schemaName":"dirkspzm32","sxml":""}