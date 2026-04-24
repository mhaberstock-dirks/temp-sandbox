comment on table dirkspzm32.pzm_schicht_perioden is
    'Die Schichtperioden stellen die Verbindung von den Schichtmodelle zu den Schichtarten da';

comment on column dirkspzm32.pzm_schicht_perioden.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_schicht_perioden.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_schicht_perioden.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_schicht_perioden.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_schicht_perioden.sp_ges_std_pro_wo is
    'Gestammtstunden pro Woche';

comment on column dirkspzm32.pzm_schicht_perioden.sp_sa_wot_di is
    'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';

comment on column dirkspzm32.pzm_schicht_perioden.sp_sa_wot_do is
    'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';

comment on column dirkspzm32.pzm_schicht_perioden.sp_sa_wot_fr is
    'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';

comment on column dirkspzm32.pzm_schicht_perioden.sp_sa_wot_mi is
    'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';

comment on column dirkspzm32.pzm_schicht_perioden.sp_sa_wot_mo is
    'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';

comment on column dirkspzm32.pzm_schicht_perioden.sp_sa_wot_sa is
    'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';

comment on column dirkspzm32.pzm_schicht_perioden.sp_sa_wot_so is
    'Verlinkung welche Schichtart für diesen Tag gilt (Foreign-Key PZM_SCHICHTARTEN)';

comment on column dirkspzm32.pzm_schicht_perioden.sp_sm_name is
    'Schichtperiode Name (Primary-Key)';

comment on column dirkspzm32.pzm_schicht_perioden.sp_woche_nr is
    'Schichtperiode-ID (Primary-Key)';


-- sqlcl_snapshot {"hash":"de4ca7dcd9058f060fe10920b825e19cf395ba91","type":"COMMENT","name":"pzm_schicht_perioden","schemaName":"dirkspzm32","sxml":""}