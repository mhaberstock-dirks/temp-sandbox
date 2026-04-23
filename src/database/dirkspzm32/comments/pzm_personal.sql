comment on table dirkspzm32.pzm_personal is
    'Grunddaten Personal für die Zeiterfassung';

comment on column dirkspzm32.pzm_personal.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_personal.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_personal.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_personal.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_personal.pers_abt_id is
    'Abteilungs-ID (Foreign-Key PZM_ABTEILUNGEN)';

comment on column dirkspzm32.pzm_personal.pers_anrede is
    'Anrede (Herr/Frau)';

comment on column dirkspzm32.pzm_personal.pers_austrittdatum is
    'Austrittsdatum des Mitarbeiters';

comment on column dirkspzm32.pzm_personal.pers_befristet_bis is
    'Befristungsdatum';

comment on column dirkspzm32.pzm_personal.pers_eintrittsdatum is
    'Eintrittsdatum des Mitarbeiters';

comment on column dirkspzm32.pzm_personal.pers_kappung_me_ab_flx_std is
    'ME = Monatsende';

comment on column dirkspzm32.pzm_personal.pers_kappung_schicht_ende is
    'Darf das Schichtende (Überstunden) gekappt werden (F  = False, T = True)';

comment on column dirkspzm32.pzm_personal.pers_kappung_te_ab_flx_std is
    'TE = Tagesende';

comment on column dirkspzm32.pzm_personal.pers_kennz_zeiterf is
    '1 = Stempeln / 0 = Nicht Stempeln (Steuert zukünftig die Fehlzeiterfassung)';

comment on column dirkspzm32.pzm_personal.pers_kst_id is
    'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';

comment on column dirkspzm32.pzm_personal.pers_land is
    'Land  (Zur Findung Land etc. z.B. für die Zuordnung der korrekten Feiertage)';

comment on column dirkspzm32.pzm_personal.pers_max_freistd is
    'Maximale Anzahl an Freistunden';

comment on column dirkspzm32.pzm_personal.pers_nname is
    'Nachname';

comment on column dirkspzm32.pzm_personal.pers_nr is
    'Personal-ID (Primay-Key)';

comment on column dirkspzm32.pzm_personal.pers_pb_id is
    'Produktionsbereich-ID (Foreign-Key PZM_PRODUKTIONSBEREICHE)';

comment on column dirkspzm32.pzm_personal.pers_personalteilber is
    'Personnalteilbereich (Werk, Tätigkeit bei INFOR etc.)
';

comment on column dirkspzm32.pzm_personal.pers_region_code is
    'Name Bundesland o.ä.  (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';

comment on column dirkspzm32.pzm_personal.pers_schnittstelle is
    '1 = Die Daten müssen in die Schnittstelle / 0 = Nicht übertragen';

comment on column dirkspzm32.pzm_personal.pers_sm_beginn is
    'Schichtmodell Startdatum';

comment on column dirkspzm32.pzm_personal.pers_sm_beginn_woche is
    'Mit dieser Woche beginnt das Schichtmodell (Schichtrhythmus)';

comment on column dirkspzm32.pzm_personal.pers_sm_name is
    'Schichtmodellname';

comment on column dirkspzm32.pzm_personal.pers_startdatum is
    'Startdatum, Erstes Eintrittsdatum des Mitarbeiters';

comment on column dirkspzm32.pzm_personal.pers_taetigkeit is
    'Beschreibung der Tätigkeit';

comment on column dirkspzm32.pzm_personal.pers_urlaub_anspr_aa_id is
    'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';

comment on column dirkspzm32.pzm_personal.pers_urlaub_anspr_wert is
    'Anzahl Urlaubstage';

comment on column dirkspzm32.pzm_personal.pers_ustd_freistd is
    'KF = KONTO_FREIZEIT, AZ = Auszahlung der Überstunden';

comment on column dirkspzm32.pzm_personal.pers_verfall_vorjahr is
    'Verfallsdatum Resturlaub aus Vorjahr';

comment on column dirkspzm32.pzm_personal.pers_vertragsart is
    'Vertragsart-ID (Foreign-Key PZM_VERTRAGSARTEN)';

comment on column dirkspzm32.pzm_personal.pers_vname is
    'Vorname';

comment on column dirkspzm32.pzm_personal.tarif_name is
    'Zugeordneter Tarif';


-- sqlcl_snapshot {"hash":"c944425e06a27eda56b497ae8072f6390e6e04fb","type":"COMMENT","name":"pzm_personal","schemaName":"dirkspzm32","sxml":""}