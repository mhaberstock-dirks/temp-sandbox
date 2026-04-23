comment on column dirkspzm32.pzm_konten_cfg.aktiv is
    'Ist das Konto aktiv (T = True, F = False)';

comment on column dirkspzm32.pzm_konten_cfg.buch_einheit is
    'Einheit der Buchung (HH24 = Stunden, DD= Tag)';

comment on column dirkspzm32.pzm_konten_cfg.def_max_saldo is
    'Maximum positiver Überschuss';

comment on column dirkspzm32.pzm_konten_cfg.def_min_saldo is
    'Maximum negativer Überschuss';

comment on column dirkspzm32.pzm_konten_cfg.firma_nr is
    'Firmennummer standortsbezogen z.B. Standort1 = 1, Standort2 = 2 (Primary-Key)';

comment on column dirkspzm32.pzm_konten_cfg.info is
    'Infotext';

comment on column dirkspzm32.pzm_konten_cfg.konto_mit_anspruch is
    'Kann man beim Konto einen Anspruch hinterlegen (T = True, F = False)';

comment on column dirkspzm32.pzm_konten_cfg.name is
    'Name des Zeitkontos';

comment on column dirkspzm32.pzm_konten_cfg.name_kurz is
    'Kurzname des Zeitkontos';

comment on column dirkspzm32.pzm_konten_cfg.sid is
    'ID (Primary-Key)';

comment on column dirkspzm32.pzm_konten_cfg.typ is
    'Typ des Zeitkontos (ZK = Zeitkonto)';


-- sqlcl_snapshot {"hash":"43cb6b470af409d55eb3924f2bdcbbbdb568f4d1","type":"COMMENT","name":"pzm_konten_cfg","schemaName":"dirkspzm32","sxml":""}