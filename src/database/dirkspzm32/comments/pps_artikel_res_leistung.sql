comment on column dirkspzm32.pps_artikel_res_leistung.alternative is
    'Leer ist Stammplan, sonst alternative';

comment on column dirkspzm32.pps_artikel_res_leistung.artikel_id is
    'ArtikelID für diese Leistungsdaten';

comment on column dirkspzm32.pps_artikel_res_leistung.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_artikel_res_leistung.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_artikel_res_leistung.fhm_notwendig is
    'Werden FHM für diesen Artikel in Kombi. mit dieser Maschin bei der Produktion benoetigt';

comment on column dirkspzm32.pps_artikel_res_leistung.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_artikel_res_leistung.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_artikel_res_leistung.prod_params is
    'Produktionsparameter zum Steuern von Prozessen oder Maschinenparametern oder Werkzeugen etc.';

comment on column dirkspzm32.pps_artikel_res_leistung.res_id is
    'Res-ID der Maschine';

comment on column dirkspzm32.pps_artikel_res_leistung.stueck_je_takt is
    'Menge je Takt im Mengeneinheit des Artikels';

comment on column dirkspzm32.pps_artikel_res_leistung.takt_zeit is
    'Taktzeit im Sekunden';

comment on column dirkspzm32.pps_artikel_res_leistung.vorgabe_ap is
    '-1 ist der Erste, dann -2, -3, … (Muss immer negative Nummer sein)';

comment on column dirkspzm32.pps_artikel_res_leistung.vorgabe_ap_pos is
    'Vorgabe-Positionsnummer für Template (Vorgabearbeitsplan)';

comment on column dirkspzm32.pps_artikel_res_leistung.vorgabe_sl_pos_bis is
    'Stücklistenpositionen bis';

comment on column dirkspzm32.pps_artikel_res_leistung.vorgabe_sl_pos_von is
    'Stücklistenpositionen von';


-- sqlcl_snapshot {"hash":"66aa3eb41097938fe00e241ab4313c2feb51e84d","type":"COMMENT","name":"pps_artikel_res_leistung","schemaName":"dirkspzm32","sxml":""}