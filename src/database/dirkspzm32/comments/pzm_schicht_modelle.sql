comment on table dirkspzm32.pzm_schicht_modelle is
    'Schichtmodelle - Enthalten Basisinformationen des Schichtmodells und die Anzahl der Wochen der Schichtperioden';

comment on column dirkspzm32.pzm_schicht_modelle.beginn_gutschr_min is
    'Pauschalgutschrift in Minuten für Kommen am Anfang des Schichttags (z.B. PC starten, etc.)';

comment on column dirkspzm32.pzm_schicht_modelle.calc_basis is
    'FESTZ = feste Zeiten, GLEITZ = Gleitzeit (std_pro_tag is die Basis)';

comment on column dirkspzm32.pzm_schicht_modelle.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_schicht_modelle.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_schicht_modelle.d_arb_std_pro_tag is
    'Durchschnittliche Arbeitszeit pro Tag in diesem Schichtmodell (erf. für Urlaubsberechnung in Std.)';

comment on column dirkspzm32.pzm_schicht_modelle.ende_gutschr_min is
    'Pauschalgutschrift in Minuten für Gehen am Ende des Schichttags (z.B. PC herunterfahren, etc.)';

comment on column dirkspzm32.pzm_schicht_modelle.flex_max_std_pro_woche is
    'Maximal flexible stunden pro Woche (alles was mehr in der Woche ist, wird als Überstd. gewertet)';

comment on column dirkspzm32.pzm_schicht_modelle.kappung_me_ab_flx_std is
    'ME = Monatsende, NULL oder 0 bedeutet, dass keine Kappung durchgefuehrt wird, es sei denn, es ist im Personalstamm hinterlegt';

comment on column dirkspzm32.pzm_schicht_modelle.kappung_schicht_ende is
    'Darf das Schichtende (Überstunden) gekappt werden (F  = False, T = True)';

comment on column dirkspzm32.pzm_schicht_modelle.kappung_te_ab_flx_std is
    'TE = Tagesende';

comment on column dirkspzm32.pzm_schicht_modelle.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_schicht_modelle.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_schicht_modelle.rastermin is
    'In diesem raster wird für dies Schichtmodell die Zeit gerechnet.';

comment on column dirkspzm32.pzm_schicht_modelle.sm_anz_wochen is
    'Anzahl an Wochen';

comment on column dirkspzm32.pzm_schicht_modelle.sm_kurzname is
    'Kurzname des Schichtmodels';

comment on column dirkspzm32.pzm_schicht_modelle.sm_name is
    'Name des Schichtmodels (Primary-Key)';

comment on column dirkspzm32.pzm_schicht_modelle.standard_aa_id is
    'Standard Abwesenheitsart für dieses Schichtmodell (übersteuert die globale Standard Abweseheitsart)';


-- sqlcl_snapshot {"hash":"ffa3d4c59be482eefd011c7cfbec2f1a2e01df45","type":"COMMENT","name":"pzm_schicht_modelle","schemaName":"dirkspzm32","sxml":""}