comment on table dirkspzm32.s_qs_fauf is
    'Bestellungen und Ladelisten die zur Verladung anstehen';

comment on column dirkspzm32.s_qs_fauf.artikel is
    'Artikelnummer';

comment on column dirkspzm32.s_qs_fauf.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.s_qs_fauf.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.s_qs_fauf.fa is
    'Fertigungsauftrag';

comment on column dirkspzm32.s_qs_fauf.fa_ag is
    'Arbeitsgang';

comment on column dirkspzm32.s_qs_fauf.fa_ag_upos is
    'FA Unterposition - Split';

comment on column dirkspzm32.s_qs_fauf.fehler_code is
    'Host-Übertragung Fehlernummer';

comment on column dirkspzm32.s_qs_fauf.fehler_text is
    'Host-Übertragung Fehlertext';

comment on column dirkspzm32.s_qs_fauf.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_qs_fauf.kunde_nr is
    'Kundennummer + Lieferadresse für den Auftrag';

comment on column dirkspzm32.s_qs_fauf.laborstatus is
    'Q = Quarantäne (Muss noch geprüft werden)
F = Frei (Kann geliefert werden)
G = Gesperrt (Geprüft und gesperrt)';

comment on column dirkspzm32.s_qs_fauf.labortext is
    'Zusatztext aus Laborergebnis (Bsp. Ware darf nur zu einem bestimmten Kunden). Hier wird z.B. übergeben, ob Ware an allen, nur ein einer oder an MIAs verarbeitet werden kann. Dafür wird folgende Formatierung eingesetzt
Nur für [MIA1;MIA2]';

comment on column dirkspzm32.s_qs_fauf.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.s_qs_fauf.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.s_qs_fauf.liefermenge is
    'Sollmenge aus dem Fertigungsauftrag (Fertigartikel)';

comment on column dirkspzm32.s_qs_fauf.mengeneinheit is
    'Mengeneinheit
STK = Stück
KG = Kilogramm
L = Liter
M = Meter, M2, M3, PCK = Päckchen';

comment on column dirkspzm32.s_qs_fauf.pruef_nummer is
    'Prue der Prüfung (Bei NULL wird die Nummer in QS-System erzeugt)';

comment on column dirkspzm32.s_qs_fauf.qs_p1 is
    'Von Projektspezifisch 1';

comment on column dirkspzm32.s_qs_fauf.qs_p10 is
    'Von Projektspezifisch 10';

comment on column dirkspzm32.s_qs_fauf.qs_p2 is
    'Von Projektspezifisch 2';

comment on column dirkspzm32.s_qs_fauf.qs_p3 is
    'Von Projektspezifisch 3';

comment on column dirkspzm32.s_qs_fauf.qs_p4 is
    'Von Projektspezifisch 4';

comment on column dirkspzm32.s_qs_fauf.qs_p5 is
    'Von Projektspezifisch 5';

comment on column dirkspzm32.s_qs_fauf.qs_p6 is
    'Von Projektspezifisch 6';

comment on column dirkspzm32.s_qs_fauf.qs_p7 is
    'Von Projektspezifisch 7';

comment on column dirkspzm32.s_qs_fauf.qs_p8 is
    'Von Projektspezifisch 8';

comment on column dirkspzm32.s_qs_fauf.qs_p9 is
    'Von Projektspezifisch 9';

comment on column dirkspzm32.s_qs_fauf.res_ext_name is
    'Externer Name für Maschine etc. im HOST-System';

comment on column dirkspzm32.s_qs_fauf.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.s_qs_fauf.status is
    'ISIPlus Status für die Schnittstellenübertragenung,
N = Host Neu (neuer oder geänderter Satz im COMUL),
U = Host Update läuft (ISIPlus überträgt aus Schnittstelle in ISIPlus-Struktur),
UE = Insert oder Update von ISIPlus übernommen,
ERR = Fehler (Fehler bei der Übernahme in ISI)';


-- sqlcl_snapshot {"hash":"c1a02be0493fd5be4cd766bbd33d6f8e9841bdd2","type":"COMMENT","name":"s_qs_fauf","schemaName":"dirkspzm32","sxml":""}