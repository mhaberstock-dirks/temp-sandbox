comment on table dirkspzm32.isi_res_plan_data is
    'Stores the current configuration for resource pan data';

comment on column dirkspzm32.isi_res_plan_data.arbeitszeitmodellnr is
    'R+ID Nummer des Arbeitszeitmodells, welches diese maschine nutzt (Eine Maschine kann nur ein Arbeitszeitmodell gleichzeitig nutzen. Die Nummer muss wie in Wert festgelegt werden.)'
    ;

comment on column dirkspzm32.isi_res_plan_data.belegungs_typ is
    '1=single
2=parallel
Angabe, wie die Belegung mit Vorgängen auf der Ressource erfolgen kann *1.	single: es darf sich maximal 1 Vorgang auf der Ressource befinden
*2	parallel: es dürfen sich mehrere Vorgänge zur gleichen Zeit auf der Ressource befinden
';

comment on column dirkspzm32.isi_res_plan_data.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.isi_res_plan_data.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.isi_res_plan_data.fa_reichweite_mg is
    'Minimale Menge, die als Reichweite in der Maschine eingestellt ist. Wird diese Menge unterschritten, dann wird eine weiterer FA generiert solange generiert, biss die Menge minimal erreicht ist.'
    ;

comment on column dirkspzm32.isi_res_plan_data.fa_reichweite_zeit is
    'Zeit in Minuten, für die eine Arbeitsvorat generiert werden sollen. ';

comment on column dirkspzm32.isi_res_plan_data.kap_typ is
    '1=keine
2=Belegung+Zeit
5=gesperrt
6=Zeit
-> Typ der Kapazitätsprüfung der Ressource *1.	keine: es erfolgt keine Überprüfung der zeitlichen Verfügbarkeit und der Kapazität für diese Ressource
*2.	Belegung + Zeit: die Ressource arbeitet mit zeiticher Begrenzung entsprechend dem zugehörigen Schichtmodell und begrenzter Kapazität
*3.	gesperrt: die Ressource besitzt keine Kapazität und kann somit nicht beplant werden
*4.	Zeit: die Ressource arbeitet mit begrenzter zeitlicher Verfügbarkeit und unendlicher Kapazität
';

comment on column dirkspzm32.isi_res_plan_data.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.isi_res_plan_data.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.isi_res_plan_data.max_auslastung is
    'Kapazitätsauslastung des Arbeitsplatzes, hat Auswirkung auf die Geschwindigkeit der Fertigung';

comment on column dirkspzm32.isi_res_plan_data.max_belegung is
    '[%] max. mengenmäßige Belegung dieser Ressource entsprechend des Belegungstyps';

comment on column dirkspzm32.isi_res_plan_data.max_transporte is
    'Maximale Anzahl der Transporte zu diesem Ziel';

comment on column dirkspzm32.isi_res_plan_data.mehrschicht is
    '0=nein
1=ja
Arbeitsplatz für Mehrschichtbearbeitung zugelassen, d.h. dass ein Mitarbeiter aus einer anderen Schicht den angemeldeten Auftrag auf dieser Maschine weiterbearbeiten darf'
    ;

comment on column dirkspzm32.isi_res_plan_data.parallelbelegungs_typ is
    '1=Vorgang
2=Materialgruppe
4=alle
16=Material
32=Job
 falls Parallelbelegung erlaubt ist: durch welche Vorgänge darf diese Ressource parallel belegt werden ';

comment on column dirkspzm32.isi_res_plan_data.personalbedarf is
    'Anzahl der Personen, die an dieser Maschine benötigt werden';

comment on column dirkspzm32.isi_res_plan_data.personalplanung is
    '0=nein
1=ja
 Angabe, ob zu dieser Maschine Personal geplant /beachtet werden soll ';

comment on column dirkspzm32.isi_res_plan_data.prozess is
    '0=nein
1=ja
 -> Angabe, ob auf dem Arbeitsplatz zeitlich durchgängige, ununterbrechbare Vorgänge (als durchgängiger Prozess) geplant werden';

comment on column dirkspzm32.isi_res_plan_data.res_id is
    'resource id of the magazine';

comment on column dirkspzm32.isi_res_plan_data.ruestoptimierungs_typ is
    '0=Keine
1=Standard
2=Zwang
-> Angabe, ob und in welcher Form auf dieser Maschine Rüstoptimierung zum Einsatz kommt';

comment on column dirkspzm32.isi_res_plan_data.ruestzeit_statisch is
    'Sekunden statische Umrüstzeit bei Materialwechsel -> Feste Dauer des dynamischen Rüsten, falls keine Rüstmatrix gegeben.';

comment on column dirkspzm32.isi_res_plan_data.ruest_matrix_id is
    'eindeutige ID einer angelegten Rüstmatrix, die für dynamische Rüstvorgänge verwendet werden soll';

comment on column dirkspzm32.isi_res_plan_data.ruest_typ is
    '2=wenn Material-gruppe wie bei Vorgänger
4=wenn Material wie bei Vorgänger
 -> beschreibt, wann auf dieser Ressource Rüstoptimierung stattfindet';

comment on column dirkspzm32.isi_res_plan_data.sm_name is
    'Schichtmodellname';

comment on column dirkspzm32.isi_res_plan_data.stillstandskostenzeitraum is
    'Sekunden -> Dauer, innerhalb welcher Stillstandskosten für die Maschine beachtet werden sollen  ';


-- sqlcl_snapshot {"hash":"329b8ff9a362a9a4ca1ad3d12f37870e9f05047f","type":"COMMENT","name":"isi_res_plan_data","schemaName":"dirkspzm32","sxml":""}