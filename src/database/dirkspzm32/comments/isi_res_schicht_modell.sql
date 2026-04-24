comment on table dirkspzm32.isi_res_schicht_modell is
    'Schicht Modell für Prod. Linien';

comment on column dirkspzm32.isi_res_schicht_modell.abzug_produktions_zeit_sek is
    'Anzahl Sekunden, die von der Produktionszeit abgezogen werden.';

comment on column dirkspzm32.isi_res_schicht_modell.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.isi_res_schicht_modell.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.isi_res_schicht_modell.ende_time is
    'Uhrzeit Ende Schicht, Pause nur der Zeitwert ist relevant';

comment on column dirkspzm32.isi_res_schicht_modell.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.isi_res_schicht_modell.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.isi_res_schicht_modell.parent_id is
    'Bei Schicht_modell_type ''P'' mit Schicht_modell_id der Schicht besetzt. Bei ''S'' mit  Schicht_modell_id besetzt';

comment on column dirkspzm32.isi_res_schicht_modell.prod_takt_id is
    '->ISI_RES_PROD_TAKT.PROD_TAKT_ID verweiss auf die Taktvariante';

comment on column dirkspzm32.isi_res_schicht_modell.schicht_ende_variabel is
    '(T) )= Schichtende kann überzogen werden, wenn keine Folgeschicht folgt. (F''= Letzte Takt muss in Schicht passen.!';

comment on column dirkspzm32.isi_res_schicht_modell.schicht_modell_id is
    '[PK]';

comment on column dirkspzm32.isi_res_schicht_modell.schicht_modell_name is
    '[UK] Name der Schicht, Pause';

comment on column dirkspzm32.isi_res_schicht_modell.schicht_modell_type is
    '(''S'' = Schicht , ''P'' = Pause';

comment on column dirkspzm32.isi_res_schicht_modell.start_time is
    'Uhrzeit Beginn Schicht, Pause nur der Zeitwert ist relevant';

comment on column dirkspzm32.isi_res_schicht_modell.stk_pro_schicht is
    'Plan Anzahl Stück Pro Schicht';

comment on column dirkspzm32.isi_res_schicht_modell.takte_pro_schicht is
    'Takte einer Schicht nach Abzug aller Pausen und ABZUG_PRODUKTIONS_ZEIT_SEK';

comment on column dirkspzm32.isi_res_schicht_modell.takt_zeit_sek is
    'TaktZeit in  Sekunden <> 0';

comment on column dirkspzm32.isi_res_schicht_modell.wochen_tage is
    'Wochentage mit Prod. (Mo;Di;Mi;Do;Fr;Sa;So;)';


-- sqlcl_snapshot {"hash":"96b4dacefd9d98e48bf4172acf5ff2b07ccfd540","type":"COMMENT","name":"isi_res_schicht_modell","schemaName":"dirkspzm32","sxml":""}