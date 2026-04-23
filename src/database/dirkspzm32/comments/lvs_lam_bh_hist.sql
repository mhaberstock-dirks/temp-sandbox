comment on table dirkspzm32.lvs_lam_bh_hist is
    'Lager Artikel Menge Buchungs Historie';

comment on column dirkspzm32.lvs_lam_bh_hist.abnr is
    'Auftragsbestätigungsnummer des Kundenauftragsbestätigung';

comment on column dirkspzm32.lvs_lam_bh_hist.abnr_extern is
    'Auftrag Bestätigungsnummer (PLEIT)';

comment on column dirkspzm32.lvs_lam_bh_hist.artikel_id is
    'Artikel ID in ISI_ARTIKEL';

comment on column dirkspzm32.lvs_lam_bh_hist.buch_datum is
    'Buchungsdatum';

comment on column dirkspzm32.lvs_lam_bh_hist.bus is
    'Buchungsschlüssel (Zugang, Abgang, Inventur etc.)';

comment on column dirkspzm32.lvs_lam_bh_hist.change_menge is
    'Menge die geändert wurde';

comment on column dirkspzm32.lvs_lam_bh_hist.charge_id is
    'ID der Charge';

comment on column dirkspzm32.lvs_lam_bh_hist.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.lvs_lam_bh_hist.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.lvs_lam_bh_hist.fa_ag is
    'Arbeitsgang des Auftrags';

comment on column dirkspzm32.lvs_lam_bh_hist.fa_upos is
    'Unterposition des Arbeitsgangs';

comment on column dirkspzm32.lvs_lam_bh_hist.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lam_bh_hist.lam_bh_id is
    'Buchungsnummer ID';

comment on column dirkspzm32.lvs_lam_bh_hist.lam_bh_kg is
    'Aktuelles Gewicht der Waren in KG';

comment on column dirkspzm32.lvs_lam_bh_hist.lam_bh_kg_einheit is
    'Gewicht der Ware je Einheit';

comment on column dirkspzm32.lvs_lam_bh_hist.lam_id is
    'Lager Artikel Mengen ID auf die gebucht wurde (Bestands Key)';

comment on column dirkspzm32.lvs_lam_bh_hist.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.lvs_lam_bh_hist.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.lvs_lam_bh_hist.leitzahl is
    'Leitzahl des Fertigungsauftrags (KLEIT)';

comment on column dirkspzm32.lvs_lam_bh_hist.lgr_platz is
    'Bebuchter Lagerplatz';

comment on column dirkspzm32.lvs_lam_bh_hist.lhm_id is
    'ID des Lagerhilfsmittel für diese Buchung';

comment on column dirkspzm32.lvs_lam_bh_hist.li_nr is
    'Lieferscheinnummer der Auslieferung';

comment on column dirkspzm32.lvs_lam_bh_hist.li_pos_nr is
    'Lieferscheinpositionsnummer der Auslieferung';

comment on column dirkspzm32.lvs_lam_bh_hist.ls_login_id is
    'Login ID des Erfassers';

comment on column dirkspzm32.lvs_lam_bh_hist.lte_id is
    'ID der Transporteinheit für diese Buchung';

comment on column dirkspzm32.lvs_lam_bh_hist.menge is
    'Aktuelle gebuchte Menge im Lager';

comment on column dirkspzm32.lvs_lam_bh_hist.owner_address_id is
    'Aktueller Eigentümer bei Ausführung der Buchung (gilt auch für normale Bewegungen im Lager) für Auswertungen';

comment on column dirkspzm32.lvs_lam_bh_hist.owner_address_id_new is
    'Neuer Eigentümer bei Umbuchung von Konsignationsware für Auswertungen';

comment on column dirkspzm32.lvs_lam_bh_hist.res_id is
    'Mit welcher Resource wurde diese Buchung (TRANSPORT) durchgeführt';

comment on column dirkspzm32.lvs_lam_bh_hist.serie_id is
    'ID Der Serie';

comment on column dirkspzm32.lvs_lam_bh_hist.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lam_bh_hist.vorgang_id is
    'Tour der Auslieferung';

comment on column dirkspzm32.lvs_lam_bh_hist.vorg_id is
    'Vorgangs ID Bsp.: Eine Umlagerung sind zei Buchungen aber ein Vorgang';

comment on column dirkspzm32.lvs_lam_bh_hist.vorg_typ is
    'Art der Vorgangs (LZ, LA, INventur, DIspo etc)';


-- sqlcl_snapshot {"hash":"48cd2345563805ae5e28d87c43f7fca1e126df0e","type":"COMMENT","name":"lvs_lam_bh_hist","schemaName":"dirkspzm32","sxml":""}