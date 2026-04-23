comment on table dirkspzm32.pzm_konten_bh is
    'Buchungshistorie der PZM Konten';

comment on column dirkspzm32.pzm_konten_bh.abt_id is
    'ID der Abteilung';

comment on column dirkspzm32.pzm_konten_bh.buch_datum is
    'Datum der Buchung';

comment on column dirkspzm32.pzm_konten_bh.bus is
    'Buchungsschlüssel (1 = Zugang [haben], 2 = Abgang [soll], 3 = Zugang storniert, 4 = Abgang storniert)';

comment on column dirkspzm32.pzm_konten_bh.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_konten_bh.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_konten_bh.created_user is
    'User - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_konten_bh.einheit is
    'Einheit der Buchung (HH24 =Stunden , DD= Tage)';

comment on column dirkspzm32.pzm_konten_bh.firma_nr is
    'Firmennummer standortsbezogen z.B. Standort1 = 1, Standort2 = 2 (Primary-Key)';

comment on column dirkspzm32.pzm_konten_bh.info is
    'Infotext';

comment on column dirkspzm32.pzm_konten_bh.konten_bh_id is
    'Buchungs-ID';

comment on column dirkspzm32.pzm_konten_bh.konto_nr is
    'Kontonummer für künftige Referenzen (Primary-Key)';

comment on column dirkspzm32.pzm_konten_bh.kst_id is
    'Kostenstelle';

comment on column dirkspzm32.pzm_konten_bh.pers_nr is
    'Personal-ID (PZM_PERSONAL !!! Nicht als Foreign-Key definiert !!!)';

comment on column dirkspzm32.pzm_konten_bh.sid is
    'ID (Primary-Key)';

comment on column dirkspzm32.pzm_konten_bh.storno_konten_bh_id is
    'Buchungs ID, die Storniert wurde';

comment on column dirkspzm32.pzm_konten_bh.typ is
    'B = normale Buchung, S = Stornobuchung (Buchung rückgängig), G = manuelle Gutschrift, K = Korrektur';

comment on column dirkspzm32.pzm_konten_bh.wert is
    'Wert dessen Einheit sich auf EINHEIT bezieht';

comment on column dirkspzm32.pzm_konten_bh.zk_aa_id is
    'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';

comment on column dirkspzm32.pzm_konten_bh.zk_start is
    'Start der Abwesenheit im Bezug auf die Abwesenheitsart';


-- sqlcl_snapshot {"hash":"78ae050b74e4d61bbbb68d0019b2c972117296f5","type":"COMMENT","name":"pzm_konten_bh","schemaName":"dirkspzm32","sxml":""}