comment on column dirkspzm32.pzm_abteilungen.abt_adress_id is
    'Adress-ID der Abteilung (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';

comment on column dirkspzm32.pzm_abteilungen.abt_id is
    'Abteilung-ID (Primary Key)';

comment on column dirkspzm32.pzm_abteilungen.abt_info is
    'Beschreibung zur Abteilung';

comment on column dirkspzm32.pzm_abteilungen.abt_kst_id is
    'Kostenstelle der Abteilung (Foreign-Key PZM_LZ_KST)';

comment on column dirkspzm32.pzm_abteilungen.abt_kurz_name is
    'Kurzname der Abteilung';

comment on column dirkspzm32.pzm_abteilungen.abt_name is
    'Name der Abteilung';

comment on column dirkspzm32.pzm_abteilungen.abt_parent_abt_id is
    'Übergeordnete Abteilung';

comment on column dirkspzm32.pzm_abteilungen.abt_pb_id is
    'Produktionsbereich (Foreign-Key PZM_PRODUKTIONSBEREICHE)';

comment on column dirkspzm32.pzm_abteilungen.abt_personal_abt_id is
    'Zugehörige Personalabteilung';

comment on column dirkspzm32.pzm_abteilungen.abt_pzm_bde_typ_continue is
    'F = Normal mit täglicher Anmeldung des Fertigungs- Serviceauftrags, T = Der angemeldete Auftrag läuft am Folgetag weiter';

comment on column dirkspzm32.pzm_abteilungen.abt_standard_sm_name is
    'Standard-Schichtmodellname';

comment on column dirkspzm32.pzm_abteilungen.abt_typ is
    'Typ der Organisationseinheit (Abteilung, Team, etc.) - Combobox mit festen Werte - Enum';

comment on column dirkspzm32.pzm_abteilungen.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_abteilungen.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_abteilungen.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_abteilungen.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_abteilungen.tarif_name is
    'Zugeordneter Tarif';


-- sqlcl_snapshot {"hash":"397da3c19483e62d970f4865b755a15dad84bf39","type":"COMMENT","name":"pzm_abteilungen","schemaName":"dirkspzm32","sxml":""}