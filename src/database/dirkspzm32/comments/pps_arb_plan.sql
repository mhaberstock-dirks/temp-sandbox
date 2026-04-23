comment on table dirkspzm32.pps_arb_plan is
    'Arbeitsplan für Artikel';

comment on column dirkspzm32.pps_arb_plan.arb_plan_id is
    'unikats ID';

comment on column dirkspzm32.pps_arb_plan.arb_plan_name is
    'Name des Arbeitsplans (z.B. identisch mit Artikelnr wenn 1 zu 1)';

comment on column dirkspzm32.pps_arb_plan.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan.firma_nr is
    'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';

comment on column dirkspzm32.pps_arb_plan.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan.sid is
    'Datenbank dieser Firma';

comment on column dirkspzm32.pps_arb_plan.soll_betriebsart is
    'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus'
    ;

comment on column dirkspzm32.pps_arb_plan.text1 is
    'Bezeichnung des Arbeitsplans';

comment on column dirkspzm32.pps_arb_plan.text2 is
    'Bezeichnung des Arbeitsplans';

comment on column dirkspzm32.pps_arb_plan.text3 is
    'Bezeichnung des Arbeitsplans';


-- sqlcl_snapshot {"hash":"4d4d3df3227f54dc4a9e6341586d06e3294758d2","type":"COMMENT","name":"pps_arb_plan","schemaName":"dirkspzm32","sxml":""}