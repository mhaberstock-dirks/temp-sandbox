comment on table dirkspzm32.ems_konten_art_bh is
    'Buchungen zum Konto Salden und Informationen zu Leergutartikeln';

comment on column dirkspzm32.ems_konten_art_bh.aend_datum is
    'Datum, an dem dieser Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.ems_konten_art_bh.aend_login_id is
    'LoginID des Benutzers, der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.ems_konten_art_bh.bel_menge_netto is
    'Belastung Kunde/Spedition';

comment on column dirkspzm32.ems_konten_art_bh.ems_art_name is
    'Referenz auf Leergutartikel (EMS_ARTIKEL)';

comment on column dirkspzm32.ems_konten_art_bh.ems_beleg_nr is
    'Belegnummer aus einem vorhandenen Beleg (EMS_BELEGE)';

comment on column dirkspzm32.ems_konten_art_bh.ems_konten_art_bh_id is
    'Eindeutige ID aus Sequence';

comment on column dirkspzm32.ems_konten_art_bh.ems_konto_nr is
    'Referenz auf Kontonummer (EMS_KONTEN)';

comment on column dirkspzm32.ems_konten_art_bh.entl_menge_brutto is
    'Entlastung Kunde/Spedition Brutto';

comment on column dirkspzm32.ems_konten_art_bh.entl_menge_defekt is
    'Entlastung Kunde/Spedition um diese Menge reduzieren';

comment on column dirkspzm32.ems_konten_art_bh.entl_menge_netto is
    'Entlastung Kunde/Spedition Netto';

comment on column dirkspzm32.ems_konten_art_bh.erz_datum is
    'Datum, an dem dieser Datensatz angelegt, gebucht wurde';

comment on column dirkspzm32.ems_konten_art_bh.erz_login_id is
    'LoginID des Benutzers, der die Buchung erstellt hat';

comment on column dirkspzm32.ems_konten_art_bh.info is
    'freier Text';

comment on column dirkspzm32.ems_konten_art_bh.saldo is
    'Endsaldo nach der Buchung';

comment on column dirkspzm32.ems_konten_art_bh.saldo_vortrag is
    'Anfangssaldo vor der Buchung';

comment on column dirkspzm32.ems_konten_art_bh.summe_menge is
    'Summe dieser Buchung Entlastung - Belastung';


-- sqlcl_snapshot {"hash":"ac59d23209ace849963d9b6dceb54279303c51f5","type":"COMMENT","name":"ems_konten_art_bh","schemaName":"dirkspzm32","sxml":""}