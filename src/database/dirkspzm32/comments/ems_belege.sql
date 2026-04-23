comment on table dirkspzm32.ems_belege is
    'Leergut Belege (Lieferung, ...)';

comment on column dirkspzm32.ems_belege.aend_datum is
    'Datum, an dem dieser Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.ems_belege.aend_login_id is
    'LoginID des Benutzers, der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.ems_belege.beleg_datum_zeit is
    'Zeitpunkt des Belegs';

comment on column dirkspzm32.ems_belege.beleg_notiz is
    'freier Text für Notizen';

comment on column dirkspzm32.ems_belege.beleg_nr_ext is
    'ext. Belegnummer';

comment on column dirkspzm32.ems_belege.beleg_nr_ext2 is
    'ext. Belegnummer 2';

comment on column dirkspzm32.ems_belege.beleg_nr_fracht is
    'Fracht-Belegnummer Lieferscheinnummer';

comment on column dirkspzm32.ems_belege.b_adress_id is
    'Buchungsadresse (Kunde, Lieferant) für diesen Beleg';

comment on column dirkspzm32.ems_belege.b_ems_konto_nr is
    'Buchungskonto für diesen Beleg';

comment on column dirkspzm32.ems_belege.ems_beleg_nr is
    'Eindeutige Belegnummer aus ISIPlus';

comment on column dirkspzm32.ems_belege.ems_beleg_typ is
    'L = Lieferung';

comment on column dirkspzm32.ems_belege.erz_datum is
    'Datum, an dem dieser Datensatz angelegt wurde';

comment on column dirkspzm32.ems_belege.erz_login_id is
    'LoginID des Benutzers, der diesen Datensatz angelegt hat';

comment on column dirkspzm32.ems_belege.gb_adress_id is
    'Buchungsadresse (Kunde, Lieferant) für Gegenbuchung für diesen Beleg';

comment on column dirkspzm32.ems_belege.gb_ems_beleg_nr is
    'Belegnummer der Gegenbuchung';

comment on column dirkspzm32.ems_belege.gb_ems_konto_nr is
    'Buchungskonto für Gegenbuchung für diesen Beleg';

comment on column dirkspzm32.ems_belege.k_adress_id is
    'Adresse des Kunden';

comment on column dirkspzm32.ems_belege.ldst_adress_id is
    'ggf. Adresse der Ladestelle';

comment on column dirkspzm32.ems_belege.pruef_datum is
    'Datum, an dem dieser Beleg geprüft wurde';

comment on column dirkspzm32.ems_belege.pruef_login_id is
    'LoginID des Benutzers, der diesen Beleg geprüft hat';

comment on column dirkspzm32.ems_belege.storno_datum is
    'Datum, an dem dieser Beleg storniert wurde';

comment on column dirkspzm32.ems_belege.storno_login_id is
    'LoginID des Benutzers, der diesen Beleg storniert hat';

comment on column dirkspzm32.ems_belege.t_adress_id is
    'Adresse des Transportunternehmers';

comment on column dirkspzm32.ems_belege.t_fahrzeug is
    'Fahrzeugkennung des Transportunternehmers';

comment on column dirkspzm32.ems_belege.vorgang_id is
    'Zugehoerige Tournummer aus ISI_ORDER';


-- sqlcl_snapshot {"hash":"db9f85ec13b35948c33581fee51c74cf4a2d38fd","type":"COMMENT","name":"ems_belege","schemaName":"dirkspzm32","sxml":""}