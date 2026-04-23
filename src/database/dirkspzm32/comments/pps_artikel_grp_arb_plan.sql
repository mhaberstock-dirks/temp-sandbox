comment on column dirkspzm32.pps_artikel_grp_arb_plan.arb_plan_id is
    'Mit welchem Arbeitsplan wird der Artikel gefertigt';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.art_gruppe_id is
    'Fertig-Produkt ArtikelID aus der Tabelle isi_artikel';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.giltab is
    'Datum, ab wann dieses Material mit dem Arbeitsplan hergestellt werden kann';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.giltbis is
    'Datum, bis wann dieses Material mit dem Arbeitsplan hergestellt werden kann';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.linkindex is
    'Rangfolge, falls mehrere Arbeitspläne möglich. Je kleiner desto bevorzugter.';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.prod_params is
    'Prod. Parameter mit ; getrennt. Bsp: B=15;A=105;';

comment on column dirkspzm32.pps_artikel_grp_arb_plan.soll_betriebsart is
    'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus'
    ;

comment on column dirkspzm32.pps_artikel_grp_arb_plan.stueckliste_id is
    'Stückliste, die im Arbeitsplan benutzt werden soll';


-- sqlcl_snapshot {"hash":"ba2cb4932869c1fdad6ba78922577f42474afa1d","type":"COMMENT","name":"pps_artikel_grp_arb_plan","schemaName":"dirkspzm32","sxml":""}