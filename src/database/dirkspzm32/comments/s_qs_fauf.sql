comment on table DIRKSPZM32.S_QS_FAUF is 'Bestellungen und Ladelisten die zur Verladung anstehen';
comment on column DIRKSPZM32.S_QS_FAUF."ARTIKEL" is 'Artikelnummer';
comment on column DIRKSPZM32.S_QS_FAUF."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.S_QS_FAUF."CREATED_LOGIN_ID" is 'login id of the user creating this dataset';
comment on column DIRKSPZM32.S_QS_FAUF."FA" is 'Fertigungsauftrag';
comment on column DIRKSPZM32.S_QS_FAUF."FA_AG" is 'Arbeitsgang';
comment on column DIRKSPZM32.S_QS_FAUF."FA_AG_UPOS" is 'FA Unterposition - Split';
comment on column DIRKSPZM32.S_QS_FAUF."FEHLER_CODE" is 'Host-Übertragung Fehlernummer';
comment on column DIRKSPZM32.S_QS_FAUF."FEHLER_TEXT" is 'Host-Übertragung Fehlertext';
comment on column DIRKSPZM32.S_QS_FAUF."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.S_QS_FAUF."KUNDE_NR" is 'Kundennummer + Lieferadresse für den Auftrag';
comment on column DIRKSPZM32.S_QS_FAUF."LABORSTATUS" is 'Q = Quarantäne (Muss noch geprüft werden)
F = Frei (Kann geliefert werden)
G = Gesperrt (Geprüft und gesperrt)';
comment on column DIRKSPZM32.S_QS_FAUF."LABORTEXT" is 'Zusatztext aus Laborergebnis (Bsp. Ware darf nur zu einem bestimmten Kunden). Hier wird z.B. übergeben, ob Ware an allen, nur ein einer oder an MIAs verarbeitet werden kann. Dafür wird folgende Formatierung eingesetzt
Nur für [MIA1;MIA2]';
comment on column DIRKSPZM32.S_QS_FAUF."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.S_QS_FAUF."LAST_CHANGE_LOGIN_ID" is 'login id of the user changing this dataset';
comment on column DIRKSPZM32.S_QS_FAUF."LIEFERMENGE" is 'Sollmenge aus dem Fertigungsauftrag (Fertigartikel)';
comment on column DIRKSPZM32.S_QS_FAUF."MENGENEINHEIT" is 'Mengeneinheit
STK = Stück
KG = Kilogramm
L = Liter
M = Meter, M2, M3, PCK = Päckchen';
comment on column DIRKSPZM32.S_QS_FAUF."PRUEF_NUMMER" is 'Prue der Prüfung (Bei NULL wird die Nummer in QS-System erzeugt)';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P1" is 'Von Projektspezifisch 1';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P10" is 'Von Projektspezifisch 10';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P2" is 'Von Projektspezifisch 2';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P3" is 'Von Projektspezifisch 3';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P4" is 'Von Projektspezifisch 4';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P5" is 'Von Projektspezifisch 5';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P6" is 'Von Projektspezifisch 6';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P7" is 'Von Projektspezifisch 7';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P8" is 'Von Projektspezifisch 8';
comment on column DIRKSPZM32.S_QS_FAUF."QS_P9" is 'Von Projektspezifisch 9';
comment on column DIRKSPZM32.S_QS_FAUF."RES_EXT_NAME" is 'Externer Name für Maschine etc. im HOST-System';
comment on column DIRKSPZM32.S_QS_FAUF."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.S_QS_FAUF."STATUS" is 'ISIPlus Status für die Schnittstellenübertragenung,
N = Host Neu (neuer oder geänderter Satz im COMUL),
U = Host Update läuft (ISIPlus überträgt aus Schnittstelle in ISIPlus-Struktur),
UE = Insert oder Update von ISIPlus übernommen,
ERR = Fehler (Fehler bei der Übernahme in ISI)';



-- sqlcl_snapshot {"hash":"32eabe7576d30863cc3b4b2248f5766740297d6f","type":"COMMENT","name":"s_qs_fauf","schemaName":"dirkspzm32","sxml":""}