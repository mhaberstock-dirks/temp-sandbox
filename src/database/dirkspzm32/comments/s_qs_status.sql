comment on table dirkspzm32.s_qs_status is
    'Bestellungen und Ladelisten die zur Verladung anstehen';

comment on column dirkspzm32.s_qs_status.created_date is
    'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';

comment on column dirkspzm32.s_qs_status.created_login_id is
    'Id des Benutzers der diesen Datensatz erstellt hat';

comment on column dirkspzm32.s_qs_status.fehler_code is
    'Host-Übertragung Fehlernummer';

comment on column dirkspzm32.s_qs_status.fehler_text is
    'Host-Übertragung Fehlertext';

comment on column dirkspzm32.s_qs_status.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.s_qs_status.laborstatus is
    'Q = Quarantäne (Muss noch geprüft werden)
F = Frei (Kann geliefert werden)
G = Gesperrt (Geprüft und gesperrt)';

comment on column dirkspzm32.s_qs_status.labortext is
    'Zusatztext aus Laborergebnis (Bsp. Ware darf nur zu einem bestimmten Kunden). Hier wird z.B. übergeben, ob Ware an allen, nur ein einer oder an MIAs verarbeitet werden kann. Dafür wird folgende Formatierung eingesetzt
Nur für [MIA1;MIA2]';

comment on column dirkspzm32.s_qs_status.last_change_date is
    'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';

comment on column dirkspzm32.s_qs_status.last_change_login_id is
    'Id des Benutzers der diesen Datensatz zuletzt geändert hat';

comment on column dirkspzm32.s_qs_status.lte_id is
    'LTE_ID / Paletten_ID';

comment on column dirkspzm32.s_qs_status.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.s_qs_status.status is
    'ISIPlus Status für die Schnittstellenübertragenung,
N = Host Neu (neuer oder geänderter Satz im COMUL),
U = Host Update läuft (ISIPlus überträgt aus Schnittstelle in ISIPlus-Struktur),
UE = Insert oder Update von ISIPlus übernommen,
ERR = Fehler (Fehler bei der Übernahme in ISI)';


-- sqlcl_snapshot {"hash":"aa9a8aecc514ff655d3fb21cfce3c3e5f1f8600f","type":"COMMENT","name":"s_qs_status","schemaName":"dirkspzm32","sxml":""}