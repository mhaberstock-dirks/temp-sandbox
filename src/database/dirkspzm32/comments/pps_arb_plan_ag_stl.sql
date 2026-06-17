comment on table DIRKSPZM32.PPS_ARB_PLAN_AG_STL is 'Relation Arbeitsplan - Stückliste';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."AG_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."ARB_PLAN_ID" is 'Arbeitsplan, dem dieser AG zugeordnet werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."ARB_PLAN_POS_ID" is 'Arbeitsplan Position ';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."FIRMA_NR" is 'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."PROD_MENGE_IX" is 'Index, falls die STL-Position vereinzelt werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."PROD_MENGE_P_EINHEIT" is 'Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."PROD_MENGE_P_EINHEIT_OP" is '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."PROD_REIHENFOLGE" is 'Produktionsreihenfolge (In dieser Reihenfolge wird diese Stücklisteneintrag in der Produktion verarbeitet)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."SID" is 'Datenbank dieser Firma';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."SL_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."STUECKLISTE_ID" is 'Eindeutige Sequenz der Stückliste ';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_STL."STUECKLISTE_POS_ID" is 'Zugehöriger Stücklisteneintrag';



-- sqlcl_snapshot {"hash":"5c2d4531d8e6be70709a674e22b0bac5147e4971","type":"COMMENT","name":"pps_arb_plan_ag_stl","schemaName":"dirkspzm32","sxml":""}