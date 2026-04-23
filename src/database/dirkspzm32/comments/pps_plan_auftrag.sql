comment on column dirkspzm32.pps_plan_auftrag.aend_datum is
    'wann wurde der Datensatz verändert';

comment on column dirkspzm32.pps_plan_auftrag.aend_login_id is
    'von wem wurde der Datensatz verändert';

comment on column dirkspzm32.pps_plan_auftrag.arb_plan_id is
    'Mit welchem Arbeitsplan soll dieser Auftrag produziert werden';

comment on column dirkspzm32.pps_plan_auftrag.artikel_id is
    '(Artikel_ID) der FertigungsMaterialNr -> Artikel_ID ';

comment on column dirkspzm32.pps_plan_auftrag.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_plan_auftrag.erzeuger is
    'ISI = in ISIPlus (intern) erzeugt, HOST = über eine Schnittstelle angelegt';

comment on column dirkspzm32.pps_plan_auftrag.erz_datum is
    'wann wurde der Datensatz erzeugt';

comment on column dirkspzm32.pps_plan_auftrag.erz_login_id is
    'von wem wurde der Datensatz erzeugt';

comment on column dirkspzm32.pps_plan_auftrag.fa_gruppe is
    'Gruppierungsmerkmal / -schlüssel um Fertigungsaufträge gruppieren zu können';

comment on column dirkspzm32.pps_plan_auftrag.firma_nr is
    'Firma-Nr.';

comment on column dirkspzm32.pps_plan_auftrag.kd_art_nr is
    'Artikel-Nr. des Kunden';

comment on column dirkspzm32.pps_plan_auftrag.kd_best_nr is
    'Bestell-Nr. des Kunden';

comment on column dirkspzm32.pps_plan_auftrag.kd_best_pos is
    'Positions-Nr. der Kunden-Bestellung';

comment on column dirkspzm32.pps_plan_auftrag.kd_best_text1 is
    'Text der Kunden-Bestellung';

comment on column dirkspzm32.pps_plan_auftrag.kd_best_text2 is
    'Text der Kunden-Bestellung';

comment on column dirkspzm32.pps_plan_auftrag.kd_best_text3 is
    'Text der Kunden-Bestellung';

comment on column dirkspzm32.pps_plan_auftrag.kunden_nr is
    'Kunden-Nr.';

comment on column dirkspzm32.pps_plan_auftrag.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_plan_auftrag.menge is
    'Artikel-Menge';

comment on column dirkspzm32.pps_plan_auftrag.plan_auf_id is
    'eindeutige Nummer, Fertigungsauftrags-Nr. ISIPlus PPS';

comment on column dirkspzm32.pps_plan_auftrag.plan_auf_id_ext is
    'Optional: eindeutige Nummer aus einem externen System (z.B. Fertigungsauftrags-Nr. SAP)';

comment on column dirkspzm32.pps_plan_auftrag.prod_params is
    'Prod Parameter mit Semikolon getrennt, Beispiel TL=1;TH=5;STW=2;';

comment on column dirkspzm32.pps_plan_auftrag.serie_auto_inc is
    '"T" = Serien ID automatisch inkrementieren, "F" = nur SERIE_ID übernehmen';

comment on column dirkspzm32.pps_plan_auftrag.serie_id is
    'Startseriennummer für den Seriennummernkreis im Auftrag';

comment on column dirkspzm32.pps_plan_auftrag.sid is
    'SID';

comment on column dirkspzm32.pps_plan_auftrag.soll_betriebsart is
    'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus'
    ;

comment on column dirkspzm32.pps_plan_auftrag.status is
    'N = Neu, ''T''= Grobterminiert PPS, ''UBDE''=Uebergeben an BDE, ''B''=Auftrag im BDE begonnen,  F = Auftrag fertig, FH = Auftrag fertig und an Host übertragen'
    ;

comment on column dirkspzm32.pps_plan_auftrag.termin_ende is
    'fester End-Termin';

comment on column dirkspzm32.pps_plan_auftrag.termin_soll_start is
    'geplanter Start-Termin';

comment on column dirkspzm32.pps_plan_auftrag.unique_hash is
    'Unikatsschlüssel für Fertigungsaufträge mit gleichem Inhalt (zur Definition von gleichen Fertigartikeln)';

comment on column dirkspzm32.pps_plan_auftrag.zeichnung is
    'Zeichnungs-Nr.';

comment on column dirkspzm32.pps_plan_auftrag.zeichnung_index is
    'Zeichnungs-Index';


-- sqlcl_snapshot {"hash":"4f9266a810102011d55cd2dacd639d6609555277","type":"COMMENT","name":"pps_plan_auftrag","schemaName":"dirkspzm32","sxml":""}