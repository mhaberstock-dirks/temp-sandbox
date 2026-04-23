comment on column dirkspzm32.pzm_konten.abschluss_saldo is
    'Kontostand beim letzten Abschluss';

comment on column dirkspzm32.pzm_konten.aktiv is
    'Ist das Konto aktiv (T = True, F = False)';

comment on column dirkspzm32.pzm_konten.anspruch is
    'Anspruch in Tagen';

comment on column dirkspzm32.pzm_konten.buch_einheit is
    'bei ZK: Tage (DD), Stunden (HH24), ... im Oracle-Format';

comment on column dirkspzm32.pzm_konten.firma_nr is
    'Firmennummer standortsbezogen z.B. Standort1 = 1, Standort2 = 2 (Primary-Key)';

comment on column dirkspzm32.pzm_konten.info is
    'Infotext';

comment on column dirkspzm32.pzm_konten.konto_nr is
    'Kontonummer für künftige Referenzen (Primary-Key)';

comment on column dirkspzm32.pzm_konten.letzter_abschluss_am is
    'Zeitpunkt der letzten Abrechnung';

comment on column dirkspzm32.pzm_konten.letzte_buchung is
    'Zeitpunkt der letzten Buchung auf das Konto';

comment on column dirkspzm32.pzm_konten.max_saldo is
    'Positiver Übertrag';

comment on column dirkspzm32.pzm_konten.min_saldo is
    'Negativer Übertrag';

comment on column dirkspzm32.pzm_konten.name is
    'Kontoname';

comment on column dirkspzm32.pzm_konten.name_kurz is
    'Kurzname für Konto für Refrenzen aus z.B. Abwesenheitsarten (UK = Urlaubskonto, FK = Freistundenkonto, ...)';

comment on column dirkspzm32.pzm_konten.pers_nr is
    'Personal-ID (Foreign-Key PZM_PERSONAL)';

comment on column dirkspzm32.pzm_konten.saldo is
    'Aktueller Kontostand';

comment on column dirkspzm32.pzm_konten.sid is
    'ID (Primary-Key)';

comment on column dirkspzm32.pzm_konten.typ is
    'Typ des Zeitkontos (ZK = Zeitkonto)';


-- sqlcl_snapshot {"hash":"6a370541bf62d515daeabe3a42eb7f27ac11dc23","type":"COMMENT","name":"pzm_konten","schemaName":"dirkspzm32","sxml":""}