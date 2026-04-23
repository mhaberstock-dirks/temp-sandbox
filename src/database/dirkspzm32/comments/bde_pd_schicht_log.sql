comment on table dirkspzm32.bde_pd_schicht_log is
    'Schicht-Logbuch';

comment on column dirkspzm32.bde_pd_schicht_log.acknowledged_by_login_id is
    'Login ID des Benutzers der den Log-Eintrag quittiert hat';

comment on column dirkspzm32.bde_pd_schicht_log.created_by_hostname is
    'Name des Computers über den der Log-Eintrag erfasst wurde';

comment on column dirkspzm32.bde_pd_schicht_log.created_by_logic is
    'Name der Logik über der Log-Eintrag erfasst wurde';

comment on column dirkspzm32.bde_pd_schicht_log.created_by_login_id is
    'Login ID des Benutzers der den Log-Eintrag erzeugt hat';

comment on column dirkspzm32.bde_pd_schicht_log.fa_ag is
    'Arbeitsgang des Fertigungsauftrags zu der der Log-Eintrag zugeordnet ist';

comment on column dirkspzm32.bde_pd_schicht_log.fa_ag_ist_menge is
    'IST-Menge des Arbeitsgangs zum Zeitpunkt  des Log-Eintrags';

comment on column dirkspzm32.bde_pd_schicht_log.fa_nr is
    'Fertigungsauftrag Nr. zu der der Log-Eintrag zugeordnet ist';

comment on column dirkspzm32.bde_pd_schicht_log.fa_upos is
    'Production Step';

comment on column dirkspzm32.bde_pd_schicht_log.log_data is
    'Log-Daten (freier Text)';

comment on column dirkspzm32.bde_pd_schicht_log.log_status is
    'N = Neu, R=Gelesen, A=Quittiert/Fertig/Bearbeitet (Acknowledged)';

comment on column dirkspzm32.bde_pd_schicht_log.log_time is
    'Zeitstempel des Log-Eintrags';

comment on column dirkspzm32.bde_pd_schicht_log.log_typ is
    'I = Info, W = Warning, E = Error';

comment on column dirkspzm32.bde_pd_schicht_log.read_by_login_id is
    'Login ID des Benutzers der den Log-Eintrag als erster gelesen hat';

comment on column dirkspzm32.bde_pd_schicht_log.res_id is
    'Resource/Maschine zu der ein Log-Eintrag zugeordnet ist';

comment on column dirkspzm32.bde_pd_schicht_log.sa_kurzname is
    'Kurzname der Schicht, in der der Log-Eintrag erfasst wurde';

comment on column dirkspzm32.bde_pd_schicht_log.schicht_log_id is
    'Eindeutige ID des Log-Eintrags';


-- sqlcl_snapshot {"hash":"748981bb6dc718282942905db87a08737358d86b","type":"COMMENT","name":"bde_pd_schicht_log","schemaName":"dirkspzm32","sxml":""}