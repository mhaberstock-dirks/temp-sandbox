comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."AEND_DATUM" is 'wann wurde der Datensatz verändert';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."AEND_LOGIN_ID" is 'von wem wurde der Datensatz verändert';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."ARB_PLAN_ID" is 'Mit welchem Arbeitsplan soll dieser Auftrag produziert werden';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."ARTIKEL_ID" is '(Artikel_ID) der FertigungsMaterialNr -> Artikel_ID ';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."ERZEUGER" is 'ISI = in ISIPlus (intern) erzeugt, HOST = über eine Schnittstelle angelegt';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."ERZ_DATUM" is 'wann wurde der Datensatz erzeugt';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."ERZ_LOGIN_ID" is 'von wem wurde der Datensatz erzeugt';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."FA_GRUPPE" is 'Gruppierungsmerkmal / -schlüssel um Fertigungsaufträge gruppieren zu können';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."FIRMA_NR" is 'Firma-Nr.';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."KD_ART_NR" is 'Artikel-Nr. des Kunden';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."KD_BEST_NR" is 'Bestell-Nr. des Kunden';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."KD_BEST_POS" is 'Positions-Nr. der Kunden-Bestellung';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."KD_BEST_TEXT1" is 'Text der Kunden-Bestellung';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."KD_BEST_TEXT2" is 'Text der Kunden-Bestellung';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."KD_BEST_TEXT3" is 'Text der Kunden-Bestellung';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."KUNDEN_NR" is 'Kunden-Nr.';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."MENGE" is 'Artikel-Menge';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."PLAN_AUF_ID" is 'eindeutige Nummer, Fertigungsauftrags-Nr. ISIPlus PPS';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."PLAN_AUF_ID_EXT" is 'Optional: eindeutige Nummer aus einem externen System (z.B. Fertigungsauftrags-Nr. SAP)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."PROD_PARAMS" is 'Prod Parameter mit Semikolon getrennt, Beispiel TL=1;TH=5;STW=2;';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."SERIE_AUTO_INC" is '"T" = Serien ID automatisch inkrementieren, "F" = nur SERIE_ID übernehmen';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."SERIE_ID" is 'Startseriennummer für den Seriennummernkreis im Auftrag';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."SID" is 'SID';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."SOLL_BETRIEBSART" is 'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."STATUS" is 'N = Neu, ''T''= Grobterminiert PPS, ''UBDE''=Uebergeben an BDE, ''B''=Auftrag im BDE begonnen,  F = Auftrag fertig, FH = Auftrag fertig und an Host übertragen';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."TERMIN_ENDE" is 'fester End-Termin';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."TERMIN_SOLL_START" is 'geplanter Start-Termin';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."UNIQUE_HASH" is 'Unikatsschlüssel für Fertigungsaufträge mit gleichem Inhalt (zur Definition von gleichen Fertigartikeln)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."ZEICHNUNG" is 'Zeichnungs-Nr.';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG."ZEICHNUNG_INDEX" is 'Zeichnungs-Index';



-- sqlcl_snapshot {"hash":"a82919cdf497d1ef5ef4fa84d7205dfe282262c2","type":"COMMENT","name":"pps_plan_auftrag","schemaName":"dirkspzm32","sxml":""}