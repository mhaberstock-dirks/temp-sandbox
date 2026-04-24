comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.adr_art is
    'K = Kunde L = Lieferant';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.adr_liefer is
    'Lieferadresse bei Kunden aus ADR';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.adr_nr is
    'Kunden oder Lieferanten-Nummer aus ADR';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.anbruch is
    'T = True Erlaubt, F = False Verboten, A = Vozugsweise Anbruch, V = Vorzugsweise Volle, I = Egal ignorieren';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.arbeitsplatz_id is
    'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.auftrag is
    'Auftragsnummer';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.besteller is
    'LVS, HOST, BDE ...';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.best_nr_kunde is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.charge is
    'Charge';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.fa_ag is
    'Arbeitsgang der Leitzahl (Filter nur diesen FA benutzen)';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.fa_nr is
    'Leitzahl Fertigungsauftrag (Filter nur diesen FA benutzen)';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.fa_upos is
    'Unterposition (gruppenarbeit) um eine Maschine zu selectieren';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.fehler_code is
    'Fehlercode siehe Schnittstellenbeschreibung';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.fehler_text is
    'Fehlertext';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.fertig_datum is
    'Abgeschlossen am';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.freigabe is
    'M = Manuelle Freigabe, A = Automatisch Freigeben zum Datum, E = Paletten Einzelanforderung';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.freigabe_datum is
    'FREIGABE = M --> Erst dann freizugeben, A --> Automatische Freigabe genau am';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.freigegeben_datum is
    'Freigegeban am';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.kom_info is
    'zus. Info für Kommissionierer';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.liefer_datum is
    'Gewünsches Liefer/Transportdatum';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.li_nr is
    'Vorgegebene Lieferscheinnummer';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.li_pos_nr is
    'Vorgegebene Lieferschein-Positionsnummer';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.login_id is
    'ID des Erstellers';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.mengeneinheit is
    'Mengeneinheit aus Menge Basis';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.mhd is
    'MHD Welches MHD soll genommen werden (Filter nur Ware mit diesem MHD darf genommen werden)';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.min_mhd_tage is
    'Mindest MHD-Tage für die Ware (Filter)';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.min_reifezeit is
    'Mindest Reifezeit für diesen Artikel (Filter)';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.order_datum is
    'Generierungsdatum';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.prioritaet is
    'Priorität (0..9), 9: hohe Priorität';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.prod_params is
    'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.seriennr is
    'Serien-Nummer';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.soll_menge is
    'Soll-Menge';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.status is
    'ISIPlus Status,
N=Host Neu,
U=Host Update läuft,
D=bereits vom Host übernommen (deleted),
UE= von ISIPlus übernommen,
DF=Freigabe zum Löschen,
ERR=Fehler (Fehler bei der Übernahme in ISI)';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.strategie is
    'FIFO, LIFO ...';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.wae_ziel is
    'SPED = Spedition SELB = Selbstabholer UPS = UPS DPAD = Paketversand, MASCH = Maschine, LAGER = Lager';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.zeichnung_index is
    'Zeichnungsindex (Filter)';

comment on column dirkspzm32.s_erp_rcv_kunden_auftr_pos.ziel is
    'WA wenn Auslagerung';


-- sqlcl_snapshot {"hash":"0b2d8b34229fb6e9a82c0e86fb0a8a6e0526424b","type":"COMMENT","name":"s_erp_rcv_kunden_auftr_pos","schemaName":"dirkspzm32","sxml":""}