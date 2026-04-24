comment on table dirkspzm32.isi_user is
    'Alle für ISIPlus eingetragenen User';

comment on column dirkspzm32.isi_user.adress_id is
    'Definiert die Firmenzugehörigkeit (Anhand von adr_art in isi_adressen kann ermittelt werden, ob der Benutzer ein externer oder ein interner ist)'
    ;

comment on column dirkspzm32.isi_user.email is
    'E-Mail Adresse des Benutzers';

comment on column dirkspzm32.isi_user.fax is
    'Fax-Nummer des Benutzers';

comment on column dirkspzm32.isi_user.kuerzel is
    'Namenskürzel (z.B. Initialien)';

comment on column dirkspzm32.isi_user.login_id is
    'Laufende Nummer des Benutzers';

comment on column dirkspzm32.isi_user.pers_nr is
    'Personalnummer des Benutzers (Bei integriertem PZM wir die Personalnumme und die Kontaktdaten von PZM übersteuert (Trigger im PZM)'
    ;

comment on column dirkspzm32.isi_user.security_level is
    'Sicherheitslevel (!! WICHTIG hier wird der Sicherheitslevel der Gruppe überschrieben).';

comment on column dirkspzm32.isi_user.sprache is
    'Sprache des Users bzw. der gesamten Software';

comment on column dirkspzm32.isi_user.transponder is
    'Transponder bzw. Chipkartennummer';

comment on column dirkspzm32.isi_user.username is
    'Benutzername der bei der Anmeldung im ISIPlus-System verwendet wird';


-- sqlcl_snapshot {"hash":"70383c75d62d2eb8be9bfaf4fe2b4ca56828a60a","type":"COMMENT","name":"isi_user","schemaName":"dirkspzm32","sxml":""}