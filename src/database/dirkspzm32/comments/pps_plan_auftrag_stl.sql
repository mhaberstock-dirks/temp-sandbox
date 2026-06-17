comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."ARTIKEL_ID" is 'Artikel ID für die Stücklistenposition';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."FIRMA_NR" is 'Firma Nr.';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."MENGE" is 'Menge für diesen Auftrag';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."MENGE_EINHEIT" is 'Mengeneinheit (Wenn NULL dann aus dem Artikel)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."PLAN_AUF_ID" is 'PLan_AUF_ID aus PPS_PLAN_AUFTRAG (FA-Auftrag)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."PLAN_AUF_STL_ID" is 'Eindeutige Nummer der Stücklistenposition (PLAN_AUF_ID * xx + POS_NR)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."POS_NR" is 'Stücklistenposition';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."PROD_MENGE_P_EINHEIT" is 'Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."PROD_MENGE_P_EINHEIT_OP" is '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."PROD_PARAMS" is 'Produktionsparameter für diese Stücklistenposition für diesen Auftrag';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."SID" is 'SID';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."ZEICHNUNG" is 'Zeichnungsnummer für diesen Auftrag';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_STL."ZEICHNUNG_INDEX" is 'Zeichnungsindex für diesen Auftrag';



-- sqlcl_snapshot {"hash":"865926e907766b3ea072625816a8ee09d62fc5bc","type":"COMMENT","name":"pps_plan_auftrag_stl","schemaName":"dirkspzm32","sxml":""}