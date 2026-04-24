comment on table dirkspzm32.isi_firma is
    'Irmenstammdaten Adresse etc.';

comment on column dirkspzm32.isi_firma.adress_id is
    '--> ISI_ADRESSEN.ADRESS_ID Adresse in der Adress ID';

comment on column dirkspzm32.isi_firma.anz_etikett_je_lte is
    'Anzahl gleicher Etiketten die pro Palette gedruckt werden müssen';

comment on column dirkspzm32.isi_firma.bde_prod_2w is
    'Wird 2. Wahl eingegeben ''T'' = Ja, ''F'' = False';

comment on column dirkspzm32.isi_firma.bde_prod_schrott is
    'Wird Schrott eingegeben ''T'' = Ja, ''F'' = False';

comment on column dirkspzm32.isi_firma.bde_ruest_2w is
    'Wird 2. Wahl eingegeben ''T'' = Ja, ''F'' = False';

comment on column dirkspzm32.isi_firma.bde_ruest_schrott is
    'Wird Schrott eingegeben ''T'' = Ja, ''F'' = False';

comment on column dirkspzm32.isi_firma.bezeichnung is
    'Bezeichnung (Name für Statuszeile)';

comment on column dirkspzm32.isi_firma.default_lang_id is
    'Standardsprache für einen Mandanten (die einzelnen Benutzer können auch noch individuelle Sprachen haben)';

comment on column dirkspzm32.isi_firma.ext_etiketten_druck is
    'Ist die Funktion für externen Etikettedruck für diese Firma freigeschaltet (NULL -> übernimmt den Wert aus ISI_SID; ''F'' -> verbietet es explizit; ''T'' -> erlaubt es wenn in ISI_SID freigeschaltet)'
    ;

comment on column dirkspzm32.isi_firma.firma_nr is
    'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';

comment on column dirkspzm32.isi_firma.fw_res_artikel is
    'Reservierung der Lagerplätze über Artikel (Achtung, FW Artikel kann auch HW sein (Arbeitsgang) darum auch FA_AG mit abspeichern'
    ;

comment on column dirkspzm32.isi_firma.fw_res_charge is
    'Reservierung der Lagerplätze über Charge (Chargenrein)';

comment on column dirkspzm32.isi_firma.fw_res_fa_auftrag is
    'Reservierung der Lagerplätze über Auftragsnummer';

comment on column dirkspzm32.isi_firma.fw_res_kunde is
    'Reservierung der Lagerplätze über Kunde';

comment on column dirkspzm32.isi_firma.fw_res_mhd is
    'Reservierung der Lagerplätze über MHD';

comment on column dirkspzm32.isi_firma.fw_res_mhd_tage is
    'Reservierung der Lagerplätze über MHD Wie lange werden MHD''s als gleich betrachtet';

comment on column dirkspzm32.isi_firma.fw_res_serie is
    'Reservierung der Lagerplätze über Seriennummer';

comment on column dirkspzm32.isi_firma.hw_res_artikel is
    'Reservierung der Lagerplätze über Artikel auch FA_AG mit abspeichern';

comment on column dirkspzm32.isi_firma.hw_res_charge is
    'Reservierung der Lagerplätze über Charge (Chargenrein)';

comment on column dirkspzm32.isi_firma.hw_res_fa_auftrag is
    'Reservierung der Lagerplätze über Auftragsnummer';

comment on column dirkspzm32.isi_firma.hw_res_kunde is
    'Reservierung der Lagerplätze über Kunde';

comment on column dirkspzm32.isi_firma.hw_res_mhd is
    'Reservierung der Lagerplätze über MHD';

comment on column dirkspzm32.isi_firma.hw_res_mhd_tage is
    'Reservierung der Lagerplätze über MHD Wie lange werden MHD''s als gleich betrachtet';

comment on column dirkspzm32.isi_firma.hw_res_serie is
    'Reservierung der Lagerplätze über Seriennummer';

comment on column dirkspzm32.isi_firma.info is
    'Info / Kommentar';

comment on column dirkspzm32.isi_firma.labor_status_anbruch is
    'Laborstatis die bei Anbruchpaletten den ResString aus dem Wert aus RES_STRING_ANBRUCH bekommt NULL = Alle';

comment on column dirkspzm32.isi_firma.lhm_barcode_basis is
    'Basis der Nummer (Sequenc oder Tabellenname)';

comment on column dirkspzm32.isi_firma.lhm_barcode_kopf is
    'Basisnummer für den Karton';

comment on column dirkspzm32.isi_firma.lhm_barcode_laenge is
    'Länge des Barcods für Karton icl. Kopf (Basisnummer, SID etc)';

comment on column dirkspzm32.isi_firma.lhm_barcode_type is
    'Typ des Barcode für den Karton (Bsp.: CCG, VDA, NVE etc.)';

comment on column dirkspzm32.isi_firma.lhm_etikett_fw is
    'Name des Etiketts für die Transporteinheit Fertigware';

comment on column dirkspzm32.isi_firma.lhm_etikett_roh is
    'Name des Etiketts für die Transporteinheit Rohstoffe';

comment on column dirkspzm32.isi_firma.lhm_etikett_tf is
    'Name des Etiketts für die Transporteinheit TeilFertig';

comment on column dirkspzm32.isi_firma.lte_barcode_basis is
    'Basis der Nummer (SEQ = Sequence LTE = LVS_LTE LHM = LVS_LTE)';

comment on column dirkspzm32.isi_firma.lte_barcode_kopf is
    'Basisnummer bei Cerealia 34027453 oder SID';

comment on column dirkspzm32.isi_firma.lte_barcode_laenge is
    'Länge des Barcods icl. Kopf (Basisnummer, SID etc)';

comment on column dirkspzm32.isi_firma.lte_barcode_type is
    'Typ des Barcode (Bsp.: CCG, VDA, NVE etc.)';

comment on column dirkspzm32.isi_firma.lte_etikett_anbruch is
    'Name des Etiketts für die Transporteinheit Fertigware und Halbware für Anbruchpaletten';

comment on column dirkspzm32.isi_firma.lte_etikett_fw is
    'Name des Etiketts für die Transporteinheit Fertigware';

comment on column dirkspzm32.isi_firma.lte_etikett_roh is
    'Name des Etiketts für die Transporteinheit Rohstoffe';

comment on column dirkspzm32.isi_firma.lte_etikett_tf is
    'Name des Etiketts für die Transporteinheit TeilFertig';

comment on column dirkspzm32.isi_firma.mhd_berechnung is
    'TA= Taggenau MA= Monatsanfang ME=Monatsende  WE= Wochen Ende WA = WochenAnfang';

comment on column dirkspzm32.isi_firma.proz_anbruch is
    'Prozentsatz, bis wohin eine Palette als Vollpalette gilt';

comment on column dirkspzm32.isi_firma.res_string_anbruch is
    'Reservierungsstring für Anbruchpaletten';

comment on column dirkspzm32.isi_firma.rw_res_artikel is
    'Reservierung der Lagerplätze über Artikel';

comment on column dirkspzm32.isi_firma.rw_res_charge is
    'Reservierung der Lagerplätze über Charge (Chargenrein)';

comment on column dirkspzm32.isi_firma.rw_res_fa_auftrag is
    'Reservierung der Lagerplätze über Auftragsnummer';

comment on column dirkspzm32.isi_firma.rw_res_lieferant is
    'Reservierung der Lagerplätze über Lieferant';

comment on column dirkspzm32.isi_firma.rw_res_mhd is
    'Reservierung der Lagerplätze über MHD';

comment on column dirkspzm32.isi_firma.rw_res_mhd_tage is
    'Reservierung der Lagerplätze über MHD Wie lange werden MHD''s als gleich betrachtet';

comment on column dirkspzm32.isi_firma.rw_res_serie is
    'Reservierung der Lagerplätze über Seriennummer';

comment on column dirkspzm32.isi_firma.sep_nve_kopf is
    'Wenn die Seperate NVE eine LTE gefüllt werden soll ';

comment on column dirkspzm32.isi_firma.sid is
    'Datenbank dieser Firma';


-- sqlcl_snapshot {"hash":"088cb74ee17e3c642107218b843402f10465cb75","type":"COMMENT","name":"isi_firma","schemaName":"dirkspzm32","sxml":""}