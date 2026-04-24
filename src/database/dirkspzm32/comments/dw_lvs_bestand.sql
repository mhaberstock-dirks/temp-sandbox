comment on table dirkspzm32.dw_lvs_bestand is
    'Data-Warehouse Lager-Bestand';

comment on column dirkspzm32.dw_lvs_bestand.anz_lam is
    'Anzahl der Behälter';

comment on column dirkspzm32.dw_lvs_bestand.anz_lte is
    'Anzahl der LTEs. Bei Mischpal. z.B. zwei Artikel auf einer LTE SUM_LTE = 0,5';

comment on column dirkspzm32.dw_lvs_bestand.artikel_id is
    'Artikel';

comment on column dirkspzm32.dw_lvs_bestand.basis_lte_name is
    'Basistyp der LTE';

comment on column dirkspzm32.dw_lvs_bestand.charge_id is
    'Chargen-Nr.';

comment on column dirkspzm32.dw_lvs_bestand.dw_stat_id is
    'Laufende Nummer';

comment on column dirkspzm32.dw_lvs_bestand.erfasst_am is
    'Zeitpunkt der Erfassung';

comment on column dirkspzm32.dw_lvs_bestand.fa_ag is
    'Arbeitsgang';

comment on column dirkspzm32.dw_lvs_bestand.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.dw_lvs_bestand.labor_status is
    'Laborstatus';

comment on column dirkspzm32.dw_lvs_bestand.leitzahl is
    'Leitzahl';

comment on column dirkspzm32.dw_lvs_bestand.lgr_ort is
    'Lagerort';

comment on column dirkspzm32.dw_lvs_bestand.lte_name is
    'Beschreibung / Text der LTE';

comment on column dirkspzm32.dw_lvs_bestand.lte_status is
    'Status der LTE (z.B. LF)';

comment on column dirkspzm32.dw_lvs_bestand.mengeneinheit_basis is
    'Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE';

comment on column dirkspzm32.dw_lvs_bestand.menge_basis is
    'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';

comment on column dirkspzm32.dw_lvs_bestand.mhd is
    'Mindest-Haltbarkeits-Datum';

comment on column dirkspzm32.dw_lvs_bestand.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.dw_lvs_bestand.stat_name is
    'Name der Statistik z.B. HUF_DW_STATISITIK';

comment on column dirkspzm32.dw_lvs_bestand.sum_menge is
    'Anzahl der Teile';

comment on column dirkspzm32.dw_lvs_bestand.wert_datum is
    'Wert Datum nicht verwechseln mit Erfasst_am';

comment on column dirkspzm32.dw_lvs_bestand.wert_datum_ende is
    'Wert Datum ende falls eine Zeitraum von Buchungen gemeint sind';


-- sqlcl_snapshot {"hash":"e28eb36a3dd799f03820425adae1d6cdc8de4988","type":"COMMENT","name":"dw_lvs_bestand","schemaName":"dirkspzm32","sxml":""}