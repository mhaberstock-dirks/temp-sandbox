comment on table dirkspzm32.aps_order_auftr_pos is
    'Aufträge für die Planung';

comment on column dirkspzm32.aps_order_auftr_pos.adress_id_liefer is
    'ID der Lieferadresse';

comment on column dirkspzm32.aps_order_auftr_pos.adress_id_rechn is
    'ID, wer hat diese Bestellung erstellt (Rechnungsadresse)';

comment on column dirkspzm32.aps_order_auftr_pos.aend_datum is
    'Bearbeitungsdatum, zuletzt bearbeitet am';

comment on column dirkspzm32.aps_order_auftr_pos.aend_login_id is
    'ID des Bearbeiters';

comment on column dirkspzm32.aps_order_auftr_pos.anbruch is
    'T = True Erlaubt, F = False Verboten, A = Vozugsweise Anbruch, V = Vorzugsweise Volle, I = Egal ignorieren';

comment on column dirkspzm32.aps_order_auftr_pos.aps_plan_status is
    'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig'
    ;

comment on column dirkspzm32.aps_order_auftr_pos.artikel_id is
    'Artikel_ID Ref. zur Artikelnummer in ISI_ARTIKEL';

comment on column dirkspzm32.aps_order_auftr_pos.auftrag_nr is
    'Auftragsnummer';

comment on column dirkspzm32.aps_order_auftr_pos.auftr_datum is
    'Generierungsdatum des Auftrags';

comment on column dirkspzm32.aps_order_auftr_pos.besteller is
    'LVS, HOST, BDE ...';

comment on column dirkspzm32.aps_order_auftr_pos.best_nr_kunde is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.aps_order_auftr_pos.charge_id is
    'Charge';

comment on column dirkspzm32.aps_order_auftr_pos.erz_datum is
    'Erstellungsdatum, erstellt am';

comment on column dirkspzm32.aps_order_auftr_pos.erz_login_id is
    'ID des Erstellers';

comment on column dirkspzm32.aps_order_auftr_pos.fehler_text is
    'Fehlertext';

comment on column dirkspzm32.aps_order_auftr_pos.fertig_datum is
    'Abgeschlossen am';

comment on column dirkspzm32.aps_order_auftr_pos.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.aps_order_auftr_pos.freigabe is
    'M = Manuelle Freigabe, A = Automatisch Freigeben zum Datum, E = Paletten Einzelanforderung';

comment on column dirkspzm32.aps_order_auftr_pos.freigabe_datum is
    'FREIGABE = M --> Erst dann freizugeben, A --> Automatische Freigabe genau am';

comment on column dirkspzm32.aps_order_auftr_pos.freigegeben_datum is
    'Freigegeban am';

comment on column dirkspzm32.aps_order_auftr_pos.hersteller_kuerzel_liste is
    'Herstellerkürzel Liste Bsp P; ';

comment on column dirkspzm32.aps_order_auftr_pos.ist_menge is
    'Ist Menge (Bereits verladen)';

comment on column dirkspzm32.aps_order_auftr_pos.jis_impuls_bereich is
    '(54) K100, Manufacturing Department, Fertigungsbereich';

comment on column dirkspzm32.aps_order_auftr_pos.jis_impuls_datum is
    'Melde-Datum';

comment on column dirkspzm32.aps_order_auftr_pos.jis_lfdnr is
    'Sequenz auf der Linie';

comment on column dirkspzm32.aps_order_auftr_pos.jis_linie is
    'Linie der Meldung';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.aps_order_auftr_pos.liefer_datum is
    'Gewünsches Liefer/Transportdatum';

comment on column dirkspzm32.aps_order_auftr_pos.li_nr is
    'Vorgegebene Lieferscheinnummer';

comment on column dirkspzm32.aps_order_auftr_pos.li_pos_nr is
    'Vorgegebene Lieferschein Positionsnummer';

comment on column dirkspzm32.aps_order_auftr_pos.lvs_info is
    'für Informationen vom LVS';

comment on column dirkspzm32.aps_order_auftr_pos.mengeneinheit is
    'Mengeneinheit aus Menge Basis';

comment on column dirkspzm32.aps_order_auftr_pos.menge_basis is
    'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';

comment on column dirkspzm32.aps_order_auftr_pos.mhd is
    'MHD Welches MHD soll genommen werden (Filter nur Ware mit diesem MHD darf genommen werden)';

comment on column dirkspzm32.aps_order_auftr_pos.min_mhd_tage is
    'Mindest MHD-Tage für die Ware (Filter)';

comment on column dirkspzm32.aps_order_auftr_pos.min_reifezeit is
    'Mindest Reifezeit für diesen Artikel (Filter)';

comment on column dirkspzm32.aps_order_auftr_pos.nachricht_ursprg is
    'Ursprungsdatei, z.B. M100_r0011239.d01.txt';

comment on column dirkspzm32.aps_order_auftr_pos.order_info is
    'Info für Kommissionierer';

comment on column dirkspzm32.aps_order_auftr_pos.planreihenfolge is
    'Sequenzreihenfolge in der Planung';

comment on column dirkspzm32.aps_order_auftr_pos.pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.aps_order_auftr_pos.prioritaet is
    'Priorität (0..9), 9: hohe Priorität - Zu bilden aus den Planvorgaben ';

comment on column dirkspzm32.aps_order_auftr_pos.quell_lagerorte is
    'Lagerorte aus denen diese Ware entnommen werden kann';

comment on column dirkspzm32.aps_order_auftr_pos.seriennr_id is
    'Serien-Nummer';

comment on column dirkspzm32.aps_order_auftr_pos.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.aps_order_auftr_pos.soll_menge is
    'Soll-Menge';

comment on column dirkspzm32.aps_order_auftr_pos.strategie is
    'FIFO, LIFO ...';

comment on column dirkspzm32.aps_order_auftr_pos.upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';

comment on column dirkspzm32.aps_order_auftr_pos.zeichnung_index is
    'Zeichnungsindex (Filter)';

comment on column dirkspzm32.aps_order_auftr_pos.ziel is
    'WA wenn Auslagerung';


-- sqlcl_snapshot {"hash":"8dc28c19235614ff4f6630af0eb01f2448502a41","type":"COMMENT","name":"aps_order_auftr_pos","schemaName":"dirkspzm32","sxml":""}