comment on table dirkspzm32.lvs_prod_linie_waren is
    'Waren für die Liniendaten für die Etikettenerzeugung (Welcher Artikel wird auf der Linie erzeugt)';

comment on column dirkspzm32.lvs_prod_linie_waren.anzahl_lhm is
    'Anzahl LHMs auf der LTE mit selbem Artikel und selbe Menge pro LHM';

comment on column dirkspzm32.lvs_prod_linie_waren.artikel_id is
    'Artikel id';

comment on column dirkspzm32.lvs_prod_linie_waren.auftragsnr is
    'Auftragsnummer zu der Ware';

comment on column dirkspzm32.lvs_prod_linie_waren.best_nr is
    'Bestellnummer';

comment on column dirkspzm32.lvs_prod_linie_waren.best_pos is
    'Bestellposition';

comment on column dirkspzm32.lvs_prod_linie_waren.charge is
    'Charge der Ware';

comment on column dirkspzm32.lvs_prod_linie_waren.charge_suffix is
    'Suffix für Charge ';

comment on column dirkspzm32.lvs_prod_linie_waren.fa_pos is
    'FA Arbeitsgang';

comment on column dirkspzm32.lvs_prod_linie_waren.fa_upos is
    'FA Unterposition bei Gruppenarbeit';

comment on column dirkspzm32.lvs_prod_linie_waren.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_prod_linie_waren.hersteller_kuerzel_liste is
    'Liste der Hersteller als Kürzel mit Semikolon getrennt';

comment on column dirkspzm32.lvs_prod_linie_waren.kd_art_nr is
    'Kundenartikelnummer';

comment on column dirkspzm32.lvs_prod_linie_waren.kunden_nr is
    'Kunde für den gefertigt wurde';

comment on column dirkspzm32.lvs_prod_linie_waren.labor_status is
    'Laborvorgabestatus U = Unfrei (Muss noch geprüft werden), F = Frei (Kann geliefert werden), G = Gesperrt (Geprüft und gesperrt)'
    ;

comment on column dirkspzm32.lvs_prod_linie_waren.labor_text is
    'Zusatztext aus Laborergebnis (Bsp. Ware darf nur zu einem bestimmten Kunden)';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p1 is
    'Parameter P1';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p10 is
    'Parameter P10';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p2 is
    'Parameter P2';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p3 is
    'Parameter P3';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p4 is
    'Parameter P4';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p5 is
    'Parameter P5';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p6 is
    'Parameter P6';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p7 is
    'Parameter P7';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p8 is
    'Parameter P8';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_p9 is
    'Parameter P9';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.lvs_prod_linie_waren.lam_text is
    'Freier Zusatztext (Bemerkung)';

comment on column dirkspzm32.lvs_prod_linie_waren.leitzahl is
    'Produktionsauftragsnummer ';

comment on column dirkspzm32.lvs_prod_linie_waren.lhm_eti_druck_status is
    'NULL = Kein Etikett drucken, SD= Soll Drucken (etikett muss noch gedruckt werden), RM=Falls vorhanden, soll nur das Restmengen-LHM etikettiert werden'
    ;

comment on column dirkspzm32.lvs_prod_linie_waren.lhm_id is
    'Genau diese LHM-ID soll angelegt werden (Wird aus AVISE gefüllt)';

comment on column dirkspzm32.lvs_prod_linie_waren.lieferant_nr is
    'Lieferantennummer der Ware z.B. Externer Einlagerung';

comment on column dirkspzm32.lvs_prod_linie_waren.linie_nr is
    'Ware für Linie';

comment on column dirkspzm32.lvs_prod_linie_waren.li_nr_lief is
    'Lieferscheinnummer des Lieferanten';

comment on column dirkspzm32.lvs_prod_linie_waren.lte_id is
    'Diese LTE-ID soll angelegt werden (Wird aus AVISE gefüllt)';

comment on column dirkspzm32.lvs_prod_linie_waren.lte_id_lieferant is
    'Packstücknummern des Lieferanten';

comment on column dirkspzm32.lvs_prod_linie_waren.menge is
    'Menge der Ware für diesen Eintrag';

comment on column dirkspzm32.lvs_prod_linie_waren.menge_je_karton is
    'Anzahl je Karton';

comment on column dirkspzm32.lvs_prod_linie_waren.mhd is
    'MHD der Ware';

comment on column dirkspzm32.lvs_prod_linie_waren.owner_address_id is
    'ID in der ISI_ADRESSEN für KONSI. Ist der Wert != NULL dann ist die Adresse dieser ID Eigentümer der Ware';

comment on column dirkspzm32.lvs_prod_linie_waren.produktionsdatum is
    'Produktionsdatum der ware';

comment on column dirkspzm32.lvs_prod_linie_waren.qs_status is
    'NULL = nicht definiert, 1 = 1. Wahl (A-Ware), 2 = 2. Wahl (B-Ware), S = Schrott, [M = Musterware, ...]';

comment on column dirkspzm32.lvs_prod_linie_waren.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_prod_linie_waren.sonst_id_lieferant is
    'Weitere ID des Lieferanten (Nicht weiter spez.) für Rückverfolgung beim Lieferanten';

comment on column dirkspzm32.lvs_prod_linie_waren.waren_nr is
    'ware 1..n für Linie';

comment on column dirkspzm32.lvs_prod_linie_waren.zeichnung is
    'Externe Zeichnung';

comment on column dirkspzm32.lvs_prod_linie_waren.zeichnung_index is
    'Zeichnungsindex / Änderungsindex';


-- sqlcl_snapshot {"hash":"be5822a844131ed12a9e216fc76a19c586f10b47","type":"COMMENT","name":"lvs_prod_linie_waren","schemaName":"dirkspzm32","sxml":""}