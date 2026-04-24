comment on column dirkspzm32.isi_contact.adress_id is
    '-> ISI_ADRESSE.ADRESS_ID';

comment on column dirkspzm32.isi_contact.aktiv is
    '''T'' = True ''F'' = False';

comment on column dirkspzm32.isi_contact.anrede is
    'Anrede Herr Frau Fräulein ..';

comment on column dirkspzm32.isi_contact.fax is
    'Faxnummer';

comment on column dirkspzm32.isi_contact.login_id is
    'Benutzer Id mit dem sich dieser Kontakt bei ISIPlus anmelden darf (und die Kontaktdaten vorgeblendet werden)';

comment on column dirkspzm32.isi_contact.pers_nr is
    'Personalnummer des Benutzers (Bei integriertem PZM wird die Personalnummer und die Kontaktdaten von PZM übersteuert (Trigger im PZM)'
    ;


-- sqlcl_snapshot {"hash":"650c2fca967784d36bdf5b0c77390ac8eb97f16b","type":"COMMENT","name":"isi_contact","schemaName":"dirkspzm32","sxml":""}