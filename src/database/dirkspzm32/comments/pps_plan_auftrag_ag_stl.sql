comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_STL."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_STL."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_STL."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_STL."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_STL."PROD_MENGE_IX" is 'Index, falls die STL-Position vereinzelt werden soll';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_STL."PROD_MENGE_P_EINHEIT" is 'Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_STL."PROD_MENGE_P_EINHEIT_OP" is '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_STL."PROD_REIHENFOLGE" is 'Produktionsreihenfolge (In dieser Reihenfolge wird diese Stücklisteneintrag in der Produktion verarbeitet)';



-- sqlcl_snapshot {"hash":"1cdbfda8bf5a5163d2a9db6db81cb9564b1514d9","type":"COMMENT","name":"pps_plan_auftrag_ag_stl","schemaName":"dirkspzm32","sxml":""}