comment on table DIRKSPZM32.ISI_USER is 'Alle für ISIPlus eingetragenen User';
comment on column DIRKSPZM32.ISI_USER."ADRESS_ID" is 'Definiert die Firmenzugehörigkeit (Anhand von adr_art in isi_adressen kann ermittelt werden, ob der Benutzer ein externer oder ein interner ist)';
comment on column DIRKSPZM32.ISI_USER."EMAIL" is 'E-Mail Adresse des Benutzers';
comment on column DIRKSPZM32.ISI_USER."FAX" is 'Fax-Nummer des Benutzers';
comment on column DIRKSPZM32.ISI_USER."KUERZEL" is 'Namenskürzel (z.B. Initialien)';
comment on column DIRKSPZM32.ISI_USER."LOGIN_ID" is 'Laufende Nummer des Benutzers';
comment on column DIRKSPZM32.ISI_USER."PERS_NR" is 'Personalnummer des Benutzers (Bei integriertem PZM wir die Personalnumme und die Kontaktdaten von PZM übersteuert (Trigger im PZM)';
comment on column DIRKSPZM32.ISI_USER."SECURITY_LEVEL" is 'Sicherheitslevel (!! WICHTIG hier wird der Sicherheitslevel der Gruppe überschrieben).';
comment on column DIRKSPZM32.ISI_USER."SPRACHE" is 'Sprache des Users bzw. der gesamten Software';
comment on column DIRKSPZM32.ISI_USER."TRANSPONDER" is 'Transponder bzw. Chipkartennummer';
comment on column DIRKSPZM32.ISI_USER."USERNAME" is 'Benutzername der bei der Anmeldung im ISIPlus-System verwendet wird';



-- sqlcl_snapshot {"hash":"b4e872d09c266b54f6cfd38ea556599a53600e80","type":"COMMENT","name":"isi_user","schemaName":"dirkspzm32","sxml":""}