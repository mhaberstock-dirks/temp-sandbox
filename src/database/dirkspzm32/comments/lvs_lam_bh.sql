comment on table dirkspzm32.lvs_lam_bh is
    'Lager Artikel Menge Buchungs Historie';

comment on column dirkspzm32.lvs_lam_bh.abnr is
    'Auftragsbestätigungsnummer des Kundenauftragsbestätigung';

comment on column dirkspzm32.lvs_lam_bh.abnr_extern is
    'Auftrag Bestätigungsnummer (PLEIT)';

comment on column dirkspzm32.lvs_lam_bh.artikel_id is
    'Artikel ID in ISI_ARTIKEL';

comment on column dirkspzm32.lvs_lam_bh.buch_datum is
    'Buchungsdatum';

comment on column dirkspzm32.lvs_lam_bh.bus is
    'Buchungsschlüssel (Zugang, Abgang, Inventur etc.)';

comment on column dirkspzm32.lvs_lam_bh.change_menge is
    'Menge die geändert wurde';

comment on column dirkspzm32.lvs_lam_bh.charge_id is
    'ID der Charge';

comment on column dirkspzm32.lvs_lam_bh.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.lvs_lam_bh.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.lvs_lam_bh.fa_ag is
    'Arbeitsgang des Auftrags';

comment on column dirkspzm32.lvs_lam_bh.fa_upos is
    'Unterposition des Arbeitsgangs';

comment on column dirkspzm32.lvs_lam_bh.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lam_bh.lam_bh_id is
    'Buchungsnummer ID';

comment on column dirkspzm32.lvs_lam_bh.lam_bh_kg is
    'Aktuelles Gewicht der Waren in KG';

comment on column dirkspzm32.lvs_lam_bh.lam_bh_kg_einheit is
    'Gewicht der Ware je Einheit';

comment on column dirkspzm32.lvs_lam_bh.lam_id is
    'Lager Artikel Mengen ID auf die gebucht wurde (Bestands Key)';

comment on column dirkspzm32.lvs_lam_bh.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.lvs_lam_bh.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.lvs_lam_bh.leitzahl is
    'Leitzahl des Fertigungsauftrags (KLEIT)';

comment on column dirkspzm32.lvs_lam_bh.lgr_platz is
    'Bebuchter Lagerplatz';

comment on column dirkspzm32.lvs_lam_bh.lhm_id is
    'ID des Lagerhilfsmittel für diese Buchung';

comment on column dirkspzm32.lvs_lam_bh.li_nr is
    'Lieferscheinnummer der Auslieferung';

comment on column dirkspzm32.lvs_lam_bh.li_pos_nr is
    'Lieferscheinpositionsnummer der Auslieferung';

comment on column dirkspzm32.lvs_lam_bh.ls_login_id is
    'Login ID des Erfassers';

comment on column dirkspzm32.lvs_lam_bh.lte_id is
    'ID der Transporteinheit für diese Buchung';

comment on column dirkspzm32.lvs_lam_bh.menge is
    'Aktuelle gebuchte Menge im Lager';

comment on column dirkspzm32.lvs_lam_bh.owner_address_id is
    'Aktueller Eigentümer bei Ausführung der Buchung (gilt auch für normale Bewegungen im Lager) für Auswertungen';

comment on column dirkspzm32.lvs_lam_bh.owner_address_id_new is
    'Neuer Eigentümer bei Umbuchung von Konsignationsware für Auswertungen';

comment on column dirkspzm32.lvs_lam_bh.res_id is
    'Mit welcher Resource wurde diese Buchung (TRANSPORT) durchgeführt';

comment on column dirkspzm32.lvs_lam_bh.serie_id is
    'ID Der Serie';

comment on column dirkspzm32.lvs_lam_bh.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lam_bh.vorgang_id is
    'Tour der Auslieferung';

comment on column dirkspzm32.lvs_lam_bh.vorg_id is
    'Vorgangs ID Bsp.: Eine Umlagerung sind zei Buchungen aber ein Vorgang';

comment on column dirkspzm32.lvs_lam_bh.vorg_typ is
    'Art der Vorgangs (LZ, LA, INventur, DIspo etc)';


-- sqlcl_snapshot {"hash":"6d562d12405acbc7c2f6cce9f2ffbf677db2b4c1","type":"COMMENT","name":"lvs_lam_bh","schemaName":"dirkspzm32","sxml":""}