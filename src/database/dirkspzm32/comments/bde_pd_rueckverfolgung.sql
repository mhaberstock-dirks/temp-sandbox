comment on table dirkspzm32.bde_pd_rueckverfolgung is
    'Tabelle zur Rueckverfolgung in der Produktion';

comment on column dirkspzm32.bde_pd_rueckverfolgung.abfr_id is
    'Nummer der Abfrage';

comment on column dirkspzm32.bde_pd_rueckverfolgung.abfr_parent_zeile is
    'Vaterzeile';

comment on column dirkspzm32.bde_pd_rueckverfolgung.abfr_typ is
    'TD = Top Down Vom Fertigprodukt zum Ursprung BU Vom Ursprung zum Ferrtigprodukt';

comment on column dirkspzm32.bde_pd_rueckverfolgung.abfr_zeile is
    'Ziele in der Abfrage';

comment on column dirkspzm32.bde_pd_rueckverfolgung.artikel_id is
    'Artikel ID in ISI_ARTIKEL';

comment on column dirkspzm32.bde_pd_rueckverfolgung.best_nr is
    'Bestellnummer bei Zukauf';

comment on column dirkspzm32.bde_pd_rueckverfolgung.best_pos is
    'Bestellposition';

comment on column dirkspzm32.bde_pd_rueckverfolgung.change_id is
    'Chargen id dieser LAM';

comment on column dirkspzm32.bde_pd_rueckverfolgung.fa_ag is
    'Aktueller Arbeitsgang der Leitzahl';

comment on column dirkspzm32.bde_pd_rueckverfolgung.fa_upos is
    'Unterposition der Arbeitsgangs';

comment on column dirkspzm32.bde_pd_rueckverfolgung.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.bde_pd_rueckverfolgung.gewicht_kg is
    'Gewicht in KG';

comment on column dirkspzm32.bde_pd_rueckverfolgung.lam_id is
    'Lager Artikel Mengen ID auf die gebucht wurde (Bestands Key)';

comment on column dirkspzm32.bde_pd_rueckverfolgung.leitzahl is
    'Fertigungsauftrag Nr. (Leitzahl)';

comment on column dirkspzm32.bde_pd_rueckverfolgung.lhm_id is
    'LHM_ID beim Zugang';

comment on column dirkspzm32.bde_pd_rueckverfolgung.lieferant_nr is
    'Lieferantennummer (Anlieferung)';

comment on column dirkspzm32.bde_pd_rueckverfolgung.li_nr_lief is
    'Lieferscheinnummer bei der Anlieferung';

comment on column dirkspzm32.bde_pd_rueckverfolgung.lte_id is
    'LTE_ID beim Zugang dieser LAM';

comment on column dirkspzm32.bde_pd_rueckverfolgung.lte_id_lieferant is
    'Packstücknummern des Lieferanten';

comment on column dirkspzm32.bde_pd_rueckverfolgung.menge is
    'Ursprüngliche Menge';

comment on column dirkspzm32.bde_pd_rueckverfolgung.mengeneinheit_basis is
    'Mengeneinheit';

comment on column dirkspzm32.bde_pd_rueckverfolgung.pers_nr is
    'Personalnummer des Maschinenführeres';

comment on column dirkspzm32.bde_pd_rueckverfolgung.prod_datum is
    'Produktionzeitpunkt';

comment on column dirkspzm32.bde_pd_rueckverfolgung.quell_lhm_id is
    'Quell LHM_ID beim Komissionieren';

comment on column dirkspzm32.bde_pd_rueckverfolgung.quell_lte_id is
    'Quell LTE_ID beim Komissionieren';

comment on column dirkspzm32.bde_pd_rueckverfolgung.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk';

comment on column dirkspzm32.bde_pd_rueckverfolgung.serie_id is
    'Seriennummer der LAM';

comment on column dirkspzm32.bde_pd_rueckverfolgung.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.bde_pd_rueckverfolgung.sonst_id_lieferant is
    'Weitere ID des Lieferanten (Nicht weiter spez.) für Rückverfolgung beim Lieferanten';

comment on column dirkspzm32.bde_pd_rueckverfolgung.user_id is
    'Login ID des Erfassers';

comment on column dirkspzm32.bde_pd_rueckverfolgung.zug_datum is
    'Zugangsdatum';


-- sqlcl_snapshot {"hash":"29030e2f5ac1cef03c47f6e2356124e917b69a2b","type":"COMMENT","name":"bde_pd_rueckverfolgung","schemaName":"dirkspzm32","sxml":""}