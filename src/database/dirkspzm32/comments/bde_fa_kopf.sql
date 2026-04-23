comment on table dirkspzm32.bde_fa_kopf is
    'Kopf eine Fertigungsauftrags';

comment on column dirkspzm32.bde_fa_kopf.adress_id is
    'Verlängerte Werkbank, Eigetümer der Rohstoffe und Fertigware';

comment on column dirkspzm32.bde_fa_kopf.aend_datum is
    'wann wurde der Datensatz verändert';

comment on column dirkspzm32.bde_fa_kopf.aend_login_id is
    'von wem wurde der Datensatz verändert';

comment on column dirkspzm32.bde_fa_kopf.arb_plan_id is
    'Mit welchem Arbeitsplan soll dieser Auftrag produziert werden';

comment on column dirkspzm32.bde_fa_kopf.artikel_id is
    '(Artikel_ID) der FertigungsMaterialNr -> Artikel_ID ';

comment on column dirkspzm32.bde_fa_kopf.erzeuger is
    'ISI = in ISIPlus (intern) erzeugt, HOST = über eine Schnittstelle angelegt';

comment on column dirkspzm32.bde_fa_kopf.erz_datum is
    'wann wurde der Datensatz erzeugt';

comment on column dirkspzm32.bde_fa_kopf.erz_login_id is
    'von wem wurde der Datensatz erzeugt';

comment on column dirkspzm32.bde_fa_kopf.fa_gruppe is
    'Gruppierungsmerkmal / -schlüssel um Fertigungsaufträge gruppieren zu können';

comment on column dirkspzm32.bde_fa_kopf.fa_nr is
    'eindeutige Nummer, Fertigungsauftrags-Nr. (LEITZAHL in AG) ISIPlus PPS';

comment on column dirkspzm32.bde_fa_kopf.fa_nr_ext is
    'Optional: eindeutige Nummer aus einem externen System (z.B. Fertigungsauftrags-Nr. SAP)';

comment on column dirkspzm32.bde_fa_kopf.firma_nr is
    'Firma-Nr.';

comment on column dirkspzm32.bde_fa_kopf.kd_art_nr is
    'Artikel-Nr. des Kunden';

comment on column dirkspzm32.bde_fa_kopf.kd_best_nr is
    'Bestell-Nr. des Kunden';

comment on column dirkspzm32.bde_fa_kopf.kd_best_pos is
    'Positions-Nr. der Kunden-Bestellung';

comment on column dirkspzm32.bde_fa_kopf.kd_best_text1 is
    'Text der Kunden-Bestellung';

comment on column dirkspzm32.bde_fa_kopf.kd_best_text2 is
    'Text der Kunden-Bestellung';

comment on column dirkspzm32.bde_fa_kopf.kd_best_text3 is
    'Text der Kunden-Bestellung';

comment on column dirkspzm32.bde_fa_kopf.kunden_nr is
    'Kunden-Nr.';

comment on column dirkspzm32.bde_fa_kopf.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter für Endprodukt';

comment on column dirkspzm32.bde_fa_kopf.lohn_arbeit is
    'Ist der Auftrag Lohnarbeit ''T''=True, ''F''=False  -> verlängerte Werkbank, soll beforzugt KONSI-Bestände des Kunden verwenden '
    ;

comment on column dirkspzm32.bde_fa_kopf.menge is
    'Artikel-Menge';

comment on column dirkspzm32.bde_fa_kopf.prod_params is
    'Prod Parameter mit Semikolon getrennt, Beispiel TL=1;TH=5;STW=2;';

comment on column dirkspzm32.bde_fa_kopf.serie_auto_inc is
    '"T" = Serien ID automatisch inkrementieren, "F" = nur SERIE_ID übernehmen';

comment on column dirkspzm32.bde_fa_kopf.serie_id is
    'Seriennummer für die nächste Fertigungseinheit';

comment on column dirkspzm32.bde_fa_kopf.sid is
    'SID';

comment on column dirkspzm32.bde_fa_kopf.soll_betriebsart is
    'NULL = nicht relevant, ''A'' = Automatik, ''M'' = Manuell, ''TESTA'' = Testmodus-Automatik, ''TESTM'' = Testmodus-Manuell, ''TEACH'' = Teachmodus'
    ;

comment on column dirkspzm32.bde_fa_kopf.status is
    'N = Neu, ''B''=Auftrag im BDE begonnen,  F = Auftrag fertig, FH = Auftrag fertig und an Host übertragen';

comment on column dirkspzm32.bde_fa_kopf.termin_ende is
    'fester End-Termin';

comment on column dirkspzm32.bde_fa_kopf.termin_soll_start is
    'geplanter Start-Termin';

comment on column dirkspzm32.bde_fa_kopf.unique_hash is
    'Unikatsschlüssel für Fertigungsaufträge mit gleichem Inhalt (zur Definition von gleichen Fertigartikeln)';

comment on column dirkspzm32.bde_fa_kopf.zeichnung is
    'Zeichnungs-Nr.';

comment on column dirkspzm32.bde_fa_kopf.zeichnung_index is
    'Zeichnungs-Index';


-- sqlcl_snapshot {"hash":"45543a52428dc23a8058c58ff923e713de10c39a","type":"COMMENT","name":"bde_fa_kopf","schemaName":"dirkspzm32","sxml":""}