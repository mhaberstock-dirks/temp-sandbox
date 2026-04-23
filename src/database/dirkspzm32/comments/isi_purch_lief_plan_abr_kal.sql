comment on table dirkspzm32.isi_purch_lief_plan_abr_kal is
    'Lieferplanabruf Kalender';

comment on column dirkspzm32.isi_purch_lief_plan_abr_kal.lief_datum is
    'Exakter Liefertag bei Lieferperiode T, Ungefähr geplanter Lieferzeitraum bei Lieferperiode W oder M';

comment on column dirkspzm32.isi_purch_lief_plan_abr_kal.lief_menge is
    'Geplante Liefermenge für die definierte Lieferperiode';

comment on column dirkspzm32.isi_purch_lief_plan_abr_kal.lief_periode is
    'Lieferperiode: T = exakter Tag, W = Kalenderwoche, M = Monat';

comment on column dirkspzm32.isi_purch_lief_plan_abr_kal.lief_plan_abruf_id is
    'Unique ID (GUID/UUID) des zugeordneten Lieferplanabrufs';

comment on column dirkspzm32.isi_purch_lief_plan_abr_kal.lief_plan_abr_kal_id is
    'Unique ID (GUID/UUID) des Lieferplanabruf-Kalendereintrags';


-- sqlcl_snapshot {"hash":"4add72a0ffd13aedc60f174a17c335bf5e5e306c","type":"COMMENT","name":"isi_purch_lief_plan_abr_kal","schemaName":"dirkspzm32","sxml":""}