comment on table dirkspzm32.pzm_ze_pers_kst_monat_ab is
    'Aufteilung der Stunden auf Kostenstellen aus bde_pd_pers_zeit_kst';

comment on column dirkspzm32.pzm_ze_pers_kst_monat_ab.datum is
    'Datum (Immer letzter Tag des Monats) (Primary-Key)';

comment on column dirkspzm32.pzm_ze_pers_kst_monat_ab.firma_nr is
    'Firmennummer in der Datenbank (Primary-Key)';

comment on column dirkspzm32.pzm_ze_pers_kst_monat_ab.kst is
    'Kostenstelle (Primary-Key)';

comment on column dirkspzm32.pzm_ze_pers_kst_monat_ab.kst_proz is
    'Anteil in Prozent';

comment on column dirkspzm32.pzm_ze_pers_kst_monat_ab.kst_std is
    'Stunde für diese Kostenstelle';

comment on column dirkspzm32.pzm_ze_pers_kst_monat_ab.kst_std_u is
    'Stunde für diese Kostenstelle ohne Fehlerbereinigung';

comment on column dirkspzm32.pzm_ze_pers_kst_monat_ab.lohnart is
    'Lohnart (Primary-Key)';

comment on column dirkspzm32.pzm_ze_pers_kst_monat_ab.pers_nr is
    'Personalnummer des Mitarbeiters (Primary-Key)';

comment on column dirkspzm32.pzm_ze_pers_kst_monat_ab.sid is
    'Datenbank für Konsolidierung (Primary-Key)';


-- sqlcl_snapshot {"hash":"50e2389b02837109eca18c70f5af458549922bd7","type":"COMMENT","name":"pzm_ze_pers_kst_monat_ab","schemaName":"dirkspzm32","sxml":""}