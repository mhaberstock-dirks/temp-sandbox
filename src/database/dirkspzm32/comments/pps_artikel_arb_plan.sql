comment on column PPS_ARTIKEL_ARB_PLAN."ARB_PLAN_ID" is 'Mit welchem Arbeitsplan wird der Artikel gefertigt';
comment on column PPS_ARTIKEL_ARB_PLAN."ARTIKEL_ID" is 'Fertig-Produkt ArtikelID aus der Tabelle isi_artikel';
comment on column PPS_ARTIKEL_ARB_PLAN."CREATED_DATE" is 'creation date+time of this dataset';
comment on column PPS_ARTIKEL_ARB_PLAN."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column PPS_ARTIKEL_ARB_PLAN."GILTAB" is 'Datum, ab wann dieses Material mit dem Arbeitsplan hergestellt werden kann';
comment on column PPS_ARTIKEL_ARB_PLAN."GILTBIS" is 'Datum, bis wann dieses Material mit dem Arbeitsplan hergestellt werden kann';
comment on column PPS_ARTIKEL_ARB_PLAN."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column PPS_ARTIKEL_ARB_PLAN."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column PPS_ARTIKEL_ARB_PLAN."LINKINDEX" is 'Rangfolge, falls mehrere Arbeitspläne möglich. Je kleiner desto bevorzugter.';
comment on column PPS_ARTIKEL_ARB_PLAN."PROD_PARAMS" is 'Prod. Parameter mit ; getrennt. Bsp: B=15;A=105;';
comment on column PPS_ARTIKEL_ARB_PLAN."SOLL_BETRIEBSART" is 'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus';
comment on column PPS_ARTIKEL_ARB_PLAN."STUECKLISTE_ID" is 'Stückliste, die im Arbeitsplan benutzt werden soll';



-- sqlcl_snapshot {"hash":"6c11858d4d4e1a368ede3ee91ec5bab6e0039ab2","type":"COMMENT","name":"pps_artikel_arb_plan","schemaName":"dirkspzm32","sxml":""}