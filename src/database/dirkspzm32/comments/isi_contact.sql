comment on column ISI_CONTACT."ADRESS_ID" is '-> ISI_ADRESSE.ADRESS_ID';
comment on column ISI_CONTACT."AKTIV" is '''T'' = True ''F'' = False';
comment on column ISI_CONTACT."ANREDE" is 'Anrede Herr Frau Fräulein ..';
comment on column ISI_CONTACT."FAX" is 'Faxnummer';
comment on column ISI_CONTACT."LOGIN_ID" is 'Benutzer Id mit dem sich dieser Kontakt bei ISIPlus anmelden darf (und die Kontaktdaten vorgeblendet werden)';
comment on column ISI_CONTACT."PERS_NR" is 'Personalnummer des Benutzers (Bei integriertem PZM wird die Personalnummer und die Kontaktdaten von PZM übersteuert (Trigger im PZM)';



-- sqlcl_snapshot {"hash":"c2909f1be0aa3d43771dce745094bc6dd854aead","type":"COMMENT","name":"isi_contact","schemaName":"dirkspzm32","sxml":""}