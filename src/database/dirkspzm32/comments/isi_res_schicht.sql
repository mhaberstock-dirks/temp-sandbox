comment on table dirkspzm32.isi_res_schicht is
    'Schicht einer Produktionslinie';

comment on column dirkspzm32.isi_res_schicht.abzug_produktions_zeit_sek is
    'Anzahl Sekunden, die von der Produktionszeit abgezogen werden.';

comment on column dirkspzm32.isi_res_schicht.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.isi_res_schicht.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.isi_res_schicht.ende_date_time is
    'Ende der  Schicht, Pause';

comment on column dirkspzm32.isi_res_schicht.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.isi_res_schicht.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.isi_res_schicht.parent_id is
    'Bei Schicht_type ''P'' mit Schicht_id der Schicht besetzt. Bei ''S'' mit  Schicht_id besetzt';

comment on column dirkspzm32.isi_res_schicht.prod_takt_id is
    '->ISI_RES_PROD_TAKT.PROD_TAKT_ID verweiss auf die Taktvariante';

comment on column dirkspzm32.isi_res_schicht.res_id is
    '[->ISI_RESOURCE.RES_ID] Schicht gilt für Produktionslinie ';

comment on column dirkspzm32.isi_res_schicht.schicht_ende_variabel is
    '(T) )= Schichtende kann überzogen werden, wenn keine Folgeschicht folgt. (F''= Letzte Takt muss in Schicht passen.!';

comment on column dirkspzm32.isi_res_schicht.schicht_id is
    '[PK]';

comment on column dirkspzm32.isi_res_schicht.schicht_name is
    'Name der Schicht, Pause';

comment on column dirkspzm32.isi_res_schicht.schicht_type is
    '(''S'' = Schicht , ''P'' = Pause';

comment on column dirkspzm32.isi_res_schicht.soll_takte_pro_schicht is
    'Takte einer Schicht nach Abzug aller Pausen und ABZUG_PRODUKTIONS_ZEIT_SEK';

comment on column dirkspzm32.isi_res_schicht.start_date_time is
    'Begin der  Schicht, Pause';

comment on column dirkspzm32.isi_res_schicht.status is
    '''N''eu , ''U''  Ubertragen in SPS , ''B''egonnen. ''F'' ertig';

comment on column dirkspzm32.isi_res_schicht.takt_zeit_sek is
    'TaktZeit in  Sekunden <> 0';


-- sqlcl_snapshot {"hash":"e515ad5478866c3226247eb7f4b685a062acde99","type":"COMMENT","name":"isi_res_schicht","schemaName":"dirkspzm32","sxml":""}