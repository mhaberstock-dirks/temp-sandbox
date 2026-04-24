comment on table dirkspzm32.pzm_ze_bde_zeiten is
    'Hier wird der tagessatz für einen Mitarbeiter eingetragen';

comment on column dirkspzm32.pzm_ze_bde_zeiten.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_ze_bde_zeiten.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_ze_bde_zeiten.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_ze_bde_zeiten.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_basis is
    'Basis der Buchung BDE oder PZM (Primary-Key)';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_datum is
    'Datum des Eintrags = Startzeitpunkt initial (Primary-Key)';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_day_ist_ende is
    'Zeitpunkt des Endes';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_day_ist_start is
    'Zeitpunkt des Anfangs';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_dwh_datum is
    'Data Warehouse Datum';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_dwh_ret_code is
    'Data Warehouse Return Code';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_dwh_status is
    'Transfer Status Data Warehouse: N=Neu, U=In Ubetragung, UE=Uebertragen, ERR=Fehler';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_dwh_status_text is
    'Data Warehouse Status/Fehlertext';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_fa_ag is
    'Kostenstelle (FA)';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_fa_upos is
    'Kostenstelle (FA)';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_leitzahl is
    'Kostenstelle (FA)';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_personalteilber is
    'Personnalteilbereich (Werk, Tätigkeit bei INFOR etc.)
';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_pers_nr is
    'Personal-ID (Primary-Key)';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_ret_code is
    '0 = OK, sonst Fehlercode';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_sa_kurzname is
    'Kurzname des Schichtart';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_status_text is
    'Status/Fehlertext der Übertragung';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_verbucht_datum is
    'Zeitpunkt der Verbuchung';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_verbucht_status is
    'Status des datensatz N=Neu, U=In Übetragung, UE=Übetragen(Fertig), ERR=Fehler';

comment on column dirkspzm32.pzm_ze_bde_zeiten.ze_bde_zeit_min is
    'Aufgelaufene Zeit für den Mitarbeiter in Minuten auf diesem Arbeitsgang';


-- sqlcl_snapshot {"hash":"7beb632d9e67be8349c55637fb6b86215cbba1ac","type":"COMMENT","name":"pzm_ze_bde_zeiten","schemaName":"dirkspzm32","sxml":""}