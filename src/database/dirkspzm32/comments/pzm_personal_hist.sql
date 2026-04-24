comment on table dirkspzm32.pzm_personal_hist is
    'Grunddaten Personal für die Zeiterfassung';

comment on column dirkspzm32.pzm_personal_hist.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_personal_hist.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_personal_hist.old_abt_id is
    'Abteilungs-ID (Foreign-Key PZM_ABTEILUNGEN)';

comment on column dirkspzm32.pzm_personal_hist.old_austrittdatum is
    'Austrittsdatum des Mitarbeiters';

comment on column dirkspzm32.pzm_personal_hist.old_befristet_bis is
    'Befristungsdatum';

comment on column dirkspzm32.pzm_personal_hist.old_eintrittsdatum is
    'Eintrittsdatum des Mitarbeiters';

comment on column dirkspzm32.pzm_personal_hist.old_kst_id is
    'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';

comment on column dirkspzm32.pzm_personal_hist.old_land is
    'Land  (Zur Findung Land etc. z.B. für die Zuordnung der korrekten Feiertage)';

comment on column dirkspzm32.pzm_personal_hist.old_pb_id is
    'Produktionsbereich-ID (Foreign-Key PZM_PRODUKTIONSBEREICHE)';

comment on column dirkspzm32.pzm_personal_hist.old_region_code is
    'Name Bundesland o.ä.  (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';

comment on column dirkspzm32.pzm_personal_hist.old_sm_name is
    'Schichtmodellname';

comment on column dirkspzm32.pzm_personal_hist.old_startdatum is
    'Startdatum, Erstes Eintrittsdatum des Mitarbeiters';

comment on column dirkspzm32.pzm_personal_hist.old_tarif_name is
    'Zugeordneter Tarif';

comment on column dirkspzm32.pzm_personal_hist.old_urlaub_anspr_aa_id is
    'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';

comment on column dirkspzm32.pzm_personal_hist.old_urlaub_anspr_wert is
    'Anzahl Urlaubstage';

comment on column dirkspzm32.pzm_personal_hist.pers_abt_id is
    'Abteilungs-ID (Foreign-Key PZM_ABTEILUNGEN)';

comment on column dirkspzm32.pzm_personal_hist.pers_austrittdatum is
    'Austrittsdatum des Mitarbeiters';

comment on column dirkspzm32.pzm_personal_hist.pers_befristet_bis is
    'Befristungsdatum';

comment on column dirkspzm32.pzm_personal_hist.pers_eintrittsdatum is
    'Eintrittsdatum des Mitarbeiters';

comment on column dirkspzm32.pzm_personal_hist.pers_kst_id is
    'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';

comment on column dirkspzm32.pzm_personal_hist.pers_land is
    'Land  (Zur Findung Land etc. z.B. für die Zuordnung der korrekten Feiertage)';

comment on column dirkspzm32.pzm_personal_hist.pers_nr is
    'Personal-ID (Primay-Key)';

comment on column dirkspzm32.pzm_personal_hist.pers_pb_id is
    'Produktionsbereich-ID (Foreign-Key PZM_PRODUKTIONSBEREICHE)';

comment on column dirkspzm32.pzm_personal_hist.pers_region_code is
    'Name Bundesland o.ä.  (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';

comment on column dirkspzm32.pzm_personal_hist.pers_sm_name is
    'Schichtmodellname';

comment on column dirkspzm32.pzm_personal_hist.pers_startdatum is
    'Startdatum, Erstes Eintrittsdatum des Mitarbeiters';

comment on column dirkspzm32.pzm_personal_hist.pers_urlaub_anspr_aa_id is
    'Abwesenheitsart-ID (PZM_ABWESENHEITSARTEN !!! Nicht als Foreign-Key definiert !!!)';

comment on column dirkspzm32.pzm_personal_hist.pers_urlaub_anspr_wert is
    'Anzahl Urlaubstage';

comment on column dirkspzm32.pzm_personal_hist.tarif_name is
    'Zugeordneter Tarif';


-- sqlcl_snapshot {"hash":"54b06b709c0b87230fded859c09142b5b80c6148","type":"COMMENT","name":"pzm_personal_hist","schemaName":"dirkspzm32","sxml":""}