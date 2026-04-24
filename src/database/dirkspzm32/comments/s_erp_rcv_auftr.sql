comment on table dirkspzm32.s_erp_rcv_auftr is
    'Bestellungen und Ladelisten die zur Verladung anstehen';

comment on column dirkspzm32.s_erp_rcv_auftr.adr_art is
    'K = Kunde L = Lieferant';

comment on column dirkspzm32.s_erp_rcv_auftr.adr_liefer is
    'Lieferadresse bei Kunden aus ADR';

comment on column dirkspzm32.s_erp_rcv_auftr.adr_nr is
    'Kunden oder Lieferanten-Nummer aus ADR';

comment on column dirkspzm32.s_erp_rcv_auftr.arbeitsplatz_id is
    'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';

comment on column dirkspzm32.s_erp_rcv_auftr.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_erp_rcv_auftr.auftrag is
    'Auftragsnummer / Bestellung im SAP';

comment on column dirkspzm32.s_erp_rcv_auftr.auf_id is
    'eindeutige Sequenz-Nummer';

comment on column dirkspzm32.s_erp_rcv_auftr.best_nr_kunde is
    'Bestellnummer des Kunden';

comment on column dirkspzm32.s_erp_rcv_auftr.best_term is
    'Bestätigter Liefertermin';

comment on column dirkspzm32.s_erp_rcv_auftr.charge is
    'Charge';

comment on column dirkspzm32.s_erp_rcv_auftr.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';

comment on column dirkspzm32.s_erp_rcv_auftr.created_login_id is
    'Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.s_erp_rcv_auftr.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_erp_rcv_auftr.ist_menge is
    'Ist Menge';

comment on column dirkspzm32.s_erp_rcv_auftr.kom_info is
    'zus. Info für Kommissionierer';

comment on column dirkspzm32.s_erp_rcv_auftr.kom_lgr_orte is
    'Lagerorte aus aus denen für die Kommissionierung ware entnommen werden darf';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel1 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel10 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel2 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel3 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel4 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel5 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel6 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel7 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel8 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.lam_sel9 is
    'Parameter zusätzliche Selectionsparameter';

comment on column dirkspzm32.s_erp_rcv_auftr.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.s_erp_rcv_auftr.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.s_erp_rcv_auftr.leitzahl is
    'Leitzahl Fertigungsauftrag';

comment on column dirkspzm32.s_erp_rcv_auftr.li_nr is
    'Lieferschein Nummer';

comment on column dirkspzm32.s_erp_rcv_auftr.li_pos_nr is
    'Lieferscheinposition -Nummer';

comment on column dirkspzm32.s_erp_rcv_auftr.lvs_info is
    'für Informationen vom LVS';

comment on column dirkspzm32.s_erp_rcv_auftr.mhd is
    'MHD';

comment on column dirkspzm32.s_erp_rcv_auftr.pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.s_erp_rcv_auftr.prioritaet is
    'Priorität (0..9), 9: hohe Priorität';

comment on column dirkspzm32.s_erp_rcv_auftr.prod_params is
    'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';

comment on column dirkspzm32.s_erp_rcv_auftr.satzart is
    'BE = Bestellung (Achtung M1.1 bis M1.3)
LI = Anstehende Lieferung Lieferschein
BL = Beistelllieferung zur Bestellung
';

comment on column dirkspzm32.s_erp_rcv_auftr.seriennr is
    'Serien-Nummer';

comment on column dirkspzm32.s_erp_rcv_auftr.soll_mg is
    'Soll-Menge';

comment on column dirkspzm32.s_erp_rcv_auftr.status is
    'N = Noch nicht angefangen V = In Vorbereitung F = Fertig A = AngefangenL = Löschen';

comment on column dirkspzm32.s_erp_rcv_auftr.strategie is
    'FIFO, LIFO';

comment on column dirkspzm32.s_erp_rcv_auftr.tour is
    'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';

comment on column dirkspzm32.s_erp_rcv_auftr.upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';

comment on column dirkspzm32.s_erp_rcv_auftr.vorgang is
    'Nummer um die Positionen zu Klammern';

comment on column dirkspzm32.s_erp_rcv_auftr.wa_ziel is
    'SPED = Spedition SELB = Selbstabholer UPS = UPS DPAD = Paketversand';


-- sqlcl_snapshot {"hash":"337d6a89e7dc706fa8dd8873bf87a0919a23ec16","type":"COMMENT","name":"s_erp_rcv_auftr","schemaName":"dirkspzm32","sxml":""}