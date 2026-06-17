comment on table DIRKSPZM32.BDE_FA_KOPF is 'Kopf eine Fertigungsauftrags';
comment on column DIRKSPZM32.BDE_FA_KOPF."ADRESS_ID" is 'Verlängerte Werkbank, Eigetümer der Rohstoffe und Fertigware';
comment on column DIRKSPZM32.BDE_FA_KOPF."AEND_DATUM" is 'wann wurde der Datensatz verändert';
comment on column DIRKSPZM32.BDE_FA_KOPF."AEND_LOGIN_ID" is 'von wem wurde der Datensatz verändert';
comment on column DIRKSPZM32.BDE_FA_KOPF."ARB_PLAN_ID" is 'Mit welchem Arbeitsplan soll dieser Auftrag produziert werden';
comment on column DIRKSPZM32.BDE_FA_KOPF."ARTIKEL_ID" is '(Artikel_ID) der FertigungsMaterialNr -> Artikel_ID ';
comment on column DIRKSPZM32.BDE_FA_KOPF."ERZEUGER" is 'ISI = in ISIPlus (intern) erzeugt, HOST = über eine Schnittstelle angelegt';
comment on column DIRKSPZM32.BDE_FA_KOPF."ERZ_DATUM" is 'wann wurde der Datensatz erzeugt';
comment on column DIRKSPZM32.BDE_FA_KOPF."ERZ_LOGIN_ID" is 'von wem wurde der Datensatz erzeugt';
comment on column DIRKSPZM32.BDE_FA_KOPF."FA_GRUPPE" is 'Gruppierungsmerkmal / -schlüssel um Fertigungsaufträge gruppieren zu können';
comment on column DIRKSPZM32.BDE_FA_KOPF."FA_NR" is 'eindeutige Nummer, Fertigungsauftrags-Nr. (LEITZAHL in AG) ISIPlus PPS';
comment on column DIRKSPZM32.BDE_FA_KOPF."FA_NR_EXT" is 'Optional: eindeutige Nummer aus einem externen System (z.B. Fertigungsauftrags-Nr. SAP)';
comment on column DIRKSPZM32.BDE_FA_KOPF."FIRMA_NR" is 'Firma-Nr.';
comment on column DIRKSPZM32.BDE_FA_KOPF."KD_ART_NR" is 'Artikel-Nr. des Kunden';
comment on column DIRKSPZM32.BDE_FA_KOPF."KD_BEST_NR" is 'Bestell-Nr. des Kunden';
comment on column DIRKSPZM32.BDE_FA_KOPF."KD_BEST_POS" is 'Positions-Nr. der Kunden-Bestellung';
comment on column DIRKSPZM32.BDE_FA_KOPF."KD_BEST_TEXT1" is 'Text der Kunden-Bestellung';
comment on column DIRKSPZM32.BDE_FA_KOPF."KD_BEST_TEXT2" is 'Text der Kunden-Bestellung';
comment on column DIRKSPZM32.BDE_FA_KOPF."KD_BEST_TEXT3" is 'Text der Kunden-Bestellung';
comment on column DIRKSPZM32.BDE_FA_KOPF."KUNDEN_NR" is 'Kunden-Nr.';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL1" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL10" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL2" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL3" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL4" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL5" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL6" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL7" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL8" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LAM_SEL9" is 'Parameter zusätzliche Selectionsparameter für Endprodukt';
comment on column DIRKSPZM32.BDE_FA_KOPF."LOHN_ARBEIT" is 'Ist der Auftrag Lohnarbeit ''T''=True, ''F''=False  -> verlängerte Werkbank, soll beforzugt KONSI-Bestände des Kunden verwenden ';
comment on column DIRKSPZM32.BDE_FA_KOPF."MENGE" is 'Artikel-Menge';
comment on column DIRKSPZM32.BDE_FA_KOPF."PROD_PARAMS" is 'Prod Parameter mit Semikolon getrennt, Beispiel TL=1;TH=5;STW=2;';
comment on column DIRKSPZM32.BDE_FA_KOPF."SERIE_AUTO_INC" is '"T" = Serien ID automatisch inkrementieren, "F" = nur SERIE_ID übernehmen';
comment on column DIRKSPZM32.BDE_FA_KOPF."SERIE_ID" is 'Seriennummer für die nächste Fertigungseinheit';
comment on column DIRKSPZM32.BDE_FA_KOPF."SID" is 'SID';
comment on column DIRKSPZM32.BDE_FA_KOPF."SOLL_BETRIEBSART" is 'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus';
comment on column DIRKSPZM32.BDE_FA_KOPF."STATUS" is 'N = Neu, ''B''=Auftrag im BDE begonnen,  F = Auftrag fertig, FH = Auftrag fertig und an Host übertragen';
comment on column DIRKSPZM32.BDE_FA_KOPF."TERMIN_ENDE" is 'fester End-Termin';
comment on column DIRKSPZM32.BDE_FA_KOPF."TERMIN_SOLL_START" is 'geplanter Start-Termin';
comment on column DIRKSPZM32.BDE_FA_KOPF."UNIQUE_HASH" is 'Unikatsschlüssel für Fertigungsaufträge mit gleichem Inhalt (zur Definition von gleichen Fertigartikeln)';
comment on column DIRKSPZM32.BDE_FA_KOPF."ZEICHNUNG" is 'Zeichnungs-Nr.';
comment on column DIRKSPZM32.BDE_FA_KOPF."ZEICHNUNG_INDEX" is 'Zeichnungs-Index';



-- sqlcl_snapshot {"hash":"a33664ee5a9538f552a6c9bfdd5ab2075840e447","type":"COMMENT","name":"bde_fa_kopf","schemaName":"dirkspzm32","sxml":""}