comment on table PPS_ARB_PLAN is 'Arbeitsplan für Artikel';
comment on column PPS_ARB_PLAN."ARB_PLAN_ID" is 'unikats ID';
comment on column PPS_ARB_PLAN."ARB_PLAN_NAME" is 'Name des Arbeitsplans (z.B. identisch mit Artikelnr wenn 1 zu 1)';
comment on column PPS_ARB_PLAN."CREATED_DATE" is 'creation date+time of this dataset';
comment on column PPS_ARB_PLAN."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column PPS_ARB_PLAN."FIRMA_NR" is 'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';
comment on column PPS_ARB_PLAN."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column PPS_ARB_PLAN."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column PPS_ARB_PLAN."SID" is 'Datenbank dieser Firma';
comment on column PPS_ARB_PLAN."SOLL_BETRIEBSART" is 'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus';
comment on column PPS_ARB_PLAN."TEXT1" is 'Bezeichnung des Arbeitsplans';
comment on column PPS_ARB_PLAN."TEXT2" is 'Bezeichnung des Arbeitsplans';
comment on column PPS_ARB_PLAN."TEXT3" is 'Bezeichnung des Arbeitsplans';



-- sqlcl_snapshot {"hash":"05097e07109e9f431d39a46c1f2e2738dc39995f","type":"COMMENT","name":"pps_arb_plan","schemaName":"dirkspzm32","sxml":""}