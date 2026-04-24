comment on column dirkspzm32.pzm_ze_loa_ausw.aa_id is
    'Mit welcher Abwesenheitsart wurde diese LOA gebucht';

comment on column dirkspzm32.pzm_ze_loa_ausw.passiv_loa is
    'T = keine Kontobuchungen ausführen, diese LOA is nur ein "Anhängsel"';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_aa_id_alt is
    'Alte Abwesenheitsart mit welcher die LOA gebucht wurde';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_datum is
    'Zeitpunkt der Lohnauswertung (Primary-Key)';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_korr_datum is
    'Zeitpunkt der letzten Änderung';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_korr_pers_nr is
    'Personal-ID der die Änderung vorgenommen hat (Foreign-Key PZM_PERSONAL)';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_kst_id is
    'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_lz_id is
    'ID Der Lohnart. Diese ID ist die referenz in der Lohnbuchhaltung';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_lz_loa_grp is
    'Lohnauswertung Gruppe';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_lz_loa_std is
    'Anzahl an Stunden';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_lz_lohnart is
    'Lohnart (Primary-Key)';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_pb_id is
    'Eindeutige ID des Produktionsbereiches (Primary-Key)';

comment on column dirkspzm32.pzm_ze_loa_ausw.zeaw_pers_nr is
    'zeaw = ZE Auswertung (Primary-Key)';


-- sqlcl_snapshot {"hash":"a268e6523490ec3443e7a64906e023485b784461","type":"COMMENT","name":"pzm_ze_loa_ausw","schemaName":"dirkspzm32","sxml":""}