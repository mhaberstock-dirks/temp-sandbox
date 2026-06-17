comment on table DIRKSPZM32.S_QS_STATUS is 'Bestellungen und Ladelisten die zur Verladung anstehen';
comment on column DIRKSPZM32.S_QS_STATUS."CREATED_DATE" is 'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';
comment on column DIRKSPZM32.S_QS_STATUS."CREATED_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz erstellt hat';
comment on column DIRKSPZM32.S_QS_STATUS."FEHLER_CODE" is 'Host-Übertragung Fehlernummer';
comment on column DIRKSPZM32.S_QS_STATUS."FEHLER_TEXT" is 'Host-Übertragung Fehlertext';
comment on column DIRKSPZM32.S_QS_STATUS."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.S_QS_STATUS."LABORSTATUS" is 'Q = Quarantäne (Muss noch geprüft werden)
F = Frei (Kann geliefert werden)
G = Gesperrt (Geprüft und gesperrt)';
comment on column DIRKSPZM32.S_QS_STATUS."LABORTEXT" is 'Zusatztext aus Laborergebnis (Bsp. Ware darf nur zu einem bestimmten Kunden). Hier wird z.B. übergeben, ob Ware an allen, nur ein einer oder an MIAs verarbeitet werden kann. Dafür wird folgende Formatierung eingesetzt
Nur für [MIA1;MIA2]';
comment on column DIRKSPZM32.S_QS_STATUS."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.S_QS_STATUS."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.S_QS_STATUS."LTE_ID" is 'LTE_ID / Paletten_ID';
comment on column DIRKSPZM32.S_QS_STATUS."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.S_QS_STATUS."STATUS" is 'ISIPlus Status für die Schnittstellenübertragenung,
N = Host Neu (neuer oder geänderter Satz im COMUL),
U = Host Update läuft (ISIPlus überträgt aus Schnittstelle in ISIPlus-Struktur),
UE = Insert oder Update von ISIPlus übernommen,
ERR = Fehler (Fehler bei der Übernahme in ISI)';



-- sqlcl_snapshot {"hash":"8d4bb83844b4eabd99f51de17ca6e2abc1c47816","type":"COMMENT","name":"s_qs_status","schemaName":"dirkspzm32","sxml":""}