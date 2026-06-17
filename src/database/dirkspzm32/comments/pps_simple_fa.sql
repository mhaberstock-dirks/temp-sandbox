comment on table DIRKSPZM32.PPS_SIMPLE_FA is 'Für nicht geplante Fertigungsaufträge Direkte Eingabe erzeugt BDE_FA_AUFTRAG';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."ABNR" is 'Auftrag Bestätigungsnummer (PLEIT) oder Batch';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."ADRESS_ID" is 'Verlängerte Werkbank, Eigetümer der Rohstoffe und Fertigware';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."AEND_DATUM" is 'wann wurde der Datensatz verändert';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."ARTIKEL_ID" is 'artikel der Produziert werden soll';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."BEST_NR_KUNDE" is 'Bestellnummer des Kunden';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."ERZ_DATUM" is 'wann wurde der Datensatz erzeugt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."FIRMA_NR" is 'Firma-Nr.';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."HERSTELLER_KUERZEL_LISTE" is 'Liste der Hersteller als Kürzel mit Semikolon getrennt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."KENZ_LHM_DRUCK" is '''T'' = Bei jedem Karton soll auch ein Etikett gedruckt werden';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."KUNDEN_NR" is 'Kunden Nummer';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL1" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL10" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL2" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL3" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL4" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL5" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL6" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL7" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL8" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAM_SEL9" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LEAD_LEITZAHL" is 'Leitzahl des Vorgängerauftrags';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LEITZAHL" is 'Leitzahl des Fertigungsauftrags (KLEIT)';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."LOHN_ARBEIT" is 'Ist der Auftrag Lohnarbeit ''T''=True, ''F''=False  -> verlängerte Werkbank, soll beforzugt KONSI-Bestände des Kunden verwenden ';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."MENGE" is 'zu produzierende Menge';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."PRIMAER_LEITZAHL" is 'Leitzahl des Primärauftrag';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."PROD_PARAMS" is 'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."RES_ID" is 'Resourcen_ID auf der gerfertigt werden soll';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."SEQ_NR" is 'Sequenz-Nummer, für das Zielprodukt auf der Fertigungslinie Montage - Ab DB31';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."SID" is 'SID';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."SOLL_BETRIEBSART" is 'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."TEXT1" is 'Freies Textfeld1';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."TEXT2" is 'Freies Textfeld2';
comment on column DIRKSPZM32.PPS_SIMPLE_FA."TEXT3" is 'Freies Textfeld3';



-- sqlcl_snapshot {"hash":"e51805e72fa99d2adf3c2af3a98b07b9cc1cb355","type":"COMMENT","name":"pps_simple_fa","schemaName":"dirkspzm32","sxml":""}