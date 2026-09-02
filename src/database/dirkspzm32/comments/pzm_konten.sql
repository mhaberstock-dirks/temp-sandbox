comment on column PZM_KONTEN."ABSCHLUSS_SALDO" is 'Kontostand beim letzten Abschluss';
comment on column PZM_KONTEN."AKTIV" is 'Ist das Konto aktiv (T = True, F = False)';
comment on column PZM_KONTEN."ANSPRUCH" is 'Anspruch in Tagen';
comment on column PZM_KONTEN."BUCH_EINHEIT" is 'bei ZK: Tage (DD), Stunden (HH24), ... im Oracle-Format';
comment on column PZM_KONTEN."FIRMA_NR" is 'Firmennummer standortsbezogen z.B. Standort1 = 1, Standort2 = 2 (Primary-Key)';
comment on column PZM_KONTEN."INFO" is 'Infotext';
comment on column PZM_KONTEN."KONTO_NR" is 'Kontonummer für künftige Referenzen (Primary-Key)';
comment on column PZM_KONTEN."LETZTE_BUCHUNG" is 'Zeitpunkt der letzten Buchung auf das Konto';
comment on column PZM_KONTEN."LETZTER_ABSCHLUSS_AM" is 'Zeitpunkt der letzten Abrechnung';
comment on column PZM_KONTEN."MAX_SALDO" is 'Positiver Übertrag';
comment on column PZM_KONTEN."MIN_SALDO" is 'Negativer Übertrag';
comment on column PZM_KONTEN."NAME" is 'Kontoname';
comment on column PZM_KONTEN."NAME_KURZ" is 'Kurzname für Konto für Refrenzen aus z.B. Abwesenheitsarten (UK = Urlaubskonto, FK = Freistundenkonto, ...)';
comment on column PZM_KONTEN."PERS_NR" is 'Personal-ID (Foreign-Key PZM_PERSONAL)';
comment on column PZM_KONTEN."SALDO" is 'Aktueller Kontostand';
comment on column PZM_KONTEN."SID" is 'ID (Primary-Key)';
comment on column PZM_KONTEN."TYP" is 'Typ des Zeitkontos (ZK = Zeitkonto)';



-- sqlcl_snapshot {"hash":"eb517e729f3b266d5846e6d3b3fbaab681070a60","type":"COMMENT","name":"pzm_konten","schemaName":"dirkspzm32","sxml":""}