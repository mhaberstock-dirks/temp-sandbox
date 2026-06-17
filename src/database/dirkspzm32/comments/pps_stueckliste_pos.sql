comment on table DIRKSPZM32.PPS_STUECKLISTE_POS is 'PPS Stückliste Positionen';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."ARTIKEL_ID" is 'Artikel ID aus ISI-Artikel';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."FIRMA_NR" is 'Firma';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."PLAN_MENGE_P_EINHEIT" is 'Faktor Bedarfsmenge zur AG Planmenge';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."PLAN_MENGE_P_EINHEIT_OP" is '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."POS_NR" is 'Stücklistenposition für Reihenfolge ';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."PROD_PARAMS" is 'Produktionsparameter Statisch für Stücklisteneintrag';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."SID" is 'SID';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."SL_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."STUECKLISTE_ID" is 'Stücklisten ID';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."STUECKLISTE_POS_ID" is 'Eindeutige ID für genau diesen Eintrag';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."ZEICHNUNG" is 'Zeichnung (Wenn genau diese verwendet werden soll) Wenn NULL dann aus Artikel';
comment on column DIRKSPZM32.PPS_STUECKLISTE_POS."ZEICHNUNG_INDEX" is 'Zeichnungsindex (Wenn genau dieser verwendet werden soll) Wenn NULL dann aus Artikel';



-- sqlcl_snapshot {"hash":"439facd2972607601224aaea3929fe67164be2de","type":"COMMENT","name":"pps_stueckliste_pos","schemaName":"dirkspzm32","sxml":""}