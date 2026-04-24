comment on table dirkspzm32.pps_simple_fa is
    'Für nicht geplante Fertigungsaufträge Direkte Eingabe erzeugt BDE_FA_AUFTRAG';

comment on column dirkspzm32.pps_simple_fa.abnr is
    'Auftrag Bestätigungsnummer (PLEIT) oder Batch';

comment on column dirkspzm32.pps_simple_fa.adress_id is
    'Verlängerte Werkbank, Eigetümer der Rohstoffe und Fertigware';

comment on column dirkspzm32.pps_simple_fa.aend_datum is
    'wann wurde der Datensatz verändert';

comment on column dirkspzm32.pps_simple_fa.artikel_id is
    'artikel der Produziert werden soll';

comment on column dirkspzm32.pps_simple_fa.best_nr_kunde is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.pps_simple_fa.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_simple_fa.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_simple_fa.erz_datum is
    'wann wurde der Datensatz erzeugt';

comment on column dirkspzm32.pps_simple_fa.firma_nr is
    'Firma-Nr.';

comment on column dirkspzm32.pps_simple_fa.hersteller_kuerzel_liste is
    'Liste der Hersteller als Kürzel mit Semikolon getrennt';

comment on column dirkspzm32.pps_simple_fa.kenz_lhm_druck is
    '''T'' = Bei jedem Karton soll auch ein Etikett gedruckt werden';

comment on column dirkspzm32.pps_simple_fa.kunden_nr is
    'Kunden Nummer';

comment on column dirkspzm32.pps_simple_fa.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.pps_simple_fa.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_simple_fa.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_simple_fa.lead_leitzahl is
    'Leitzahl des Vorgängerauftrags';

comment on column dirkspzm32.pps_simple_fa.leitzahl is
    'Leitzahl des Fertigungsauftrags (KLEIT)';

comment on column dirkspzm32.pps_simple_fa.lohn_arbeit is
    'Ist der Auftrag Lohnarbeit ''T''=True, ''F''=False  -> verlängerte Werkbank, soll beforzugt KONSI-Bestände des Kunden verwenden '
    ;

comment on column dirkspzm32.pps_simple_fa.menge is
    'zu produzierende Menge';

comment on column dirkspzm32.pps_simple_fa.primaer_leitzahl is
    'Leitzahl des Primärauftrag';

comment on column dirkspzm32.pps_simple_fa.prod_params is
    'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';

comment on column dirkspzm32.pps_simple_fa.res_id is
    'Resourcen_ID auf der gerfertigt werden soll';

comment on column dirkspzm32.pps_simple_fa.seq_nr is
    'Sequenz-Nummer, für das Zielprodukt auf der Fertigungslinie Montage - Ab DB31';

comment on column dirkspzm32.pps_simple_fa.sid is
    'SID';

comment on column dirkspzm32.pps_simple_fa.soll_betriebsart is
    'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus'
    ;

comment on column dirkspzm32.pps_simple_fa.text1 is
    'Freies Textfeld1';

comment on column dirkspzm32.pps_simple_fa.text2 is
    'Freies Textfeld2';

comment on column dirkspzm32.pps_simple_fa.text3 is
    'Freies Textfeld3';


-- sqlcl_snapshot {"hash":"d281cbb862b4c9b07183a2f458a7d7858af95284","type":"COMMENT","name":"pps_simple_fa","schemaName":"dirkspzm32","sxml":""}