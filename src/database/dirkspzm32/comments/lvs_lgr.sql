comment on table DIRKSPZM32.LVS_LGR is 'Lagerplätze im ISIPlus LVS';
comment on column DIRKSPZM32.LVS_LGR."ABC" is 'ABC Typ 1= A Schnelldreher 2=B Mitteldreher 3 = C Langsamdreher';
comment on column DIRKSPZM32.LVS_LGR."AKTIVIERUNG_PRIO" is 'Prio für den Transport für diese Ziel. Wenn Die Prio im Transport hoeher ist, bleibt die höhere bestehen.';
comment on column DIRKSPZM32.LVS_LGR."AKT_INVENTUR_ID" is 'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR';
comment on column DIRKSPZM32.LVS_LGR."ANZ_UML" is 'Max Anzahl an Umlagerungen ';
comment on column DIRKSPZM32.LVS_LGR."CHANGE_DATE" is 'Datum letzte Änderung';
comment on column DIRKSPZM32.LVS_LGR."CHANGE_LOGIN_ID" is 'Login ID letzte Änderung (Wird z.Zt. nicht gefüllt)';
comment on column DIRKSPZM32.LVS_LGR."EINL_ORT_DEFAULT_LISTE" is 'Liste der Einlagerorte, die als default auf diesem Platz genommen werden. Bsp.: 001;101;201; = In dieser Reihenfloge sollen die Platzsuche erfolgen. Also erst in 1 dann in 101 und dann in ';
comment on column DIRKSPZM32.LVS_LGR."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_LGR."FLAECHEN_STELLPLATZ" is 'Ist dieser Lagerplatz ein Flächenstellplatz (dann können hier auch Spezialpaletten abgestellt werden). Siehe LTE_CFG';
comment on column DIRKSPZM32.LVS_LGR."GEFAHREN_KLASSE" is 'Klasse für Gefahrenkennzeichen, Gefahrenklasse des Artikel muss <= sein';
comment on column DIRKSPZM32.LVS_LGR."GESPERRT" is 'F = Freigegeben, G = Gesperrt';
comment on column DIRKSPZM32.LVS_LGR."GESP_GRUND" is 'Grund für die Sperre';
comment on column DIRKSPZM32.LVS_LGR."GRUPPE" is 'Gruppierungskennzeichen Lagerplatz z.B. ein Kanal oder eine Gruppe von Plätzen die Strategisch zusammen geführt werden können [Satelitengasse im SAT_EPL oder dynamische Kanaltiefen])';
comment on column DIRKSPZM32.LVS_LGR."HRL_LAG_MAX_PAL_A" is 'Anzahl Euro Pal. je Kanal';
comment on column DIRKSPZM32.LVS_LGR."HRL_LAG_MAX_PAL_I" is 'Anzahl Indu Pal. je Kanal';
comment on column DIRKSPZM32.LVS_LGR."LETZTE_INVENTUR_DATUM" is 'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';
comment on column DIRKSPZM32.LVS_LGR."LETZTE_INVENTUR_ID" is 'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';
comment on column DIRKSPZM32.LVS_LGR."LETZTE_INVENTUR_LOGIN_ID" is 'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die Inventur hier durchgeführt';
comment on column DIRKSPZM32.LVS_LGR."LGR_AKT_KG" is 'Aktuelles Gewicht der Waren auf diesem Lagerplatz in KG';
comment on column DIRKSPZM32.LVS_LGR."LGR_AKT_TE" is 'Anzahl der Transporteinheiten die aktuell auf diesem Lagerplatz stehen';
comment on column DIRKSPZM32.LVS_LGR."LGR_DAT_ERSTELLT" is 'Datum der Erstellung';
comment on column DIRKSPZM32.LVS_LGR."LGR_DAT_ERST_BELEGT" is 'Datum der ersten Belegung mit Ware';
comment on column DIRKSPZM32.LVS_LGR."LGR_DAT_L_INVENTUR" is 'Datum der letzten Inventur -- NICHT BENUTZT!! LÖSCHEN KLÄREN';
comment on column DIRKSPZM32.LVS_LGR."LGR_DIM_E" is 'Logische Ebene im Regal oder Stapelhöhe bei Bodenlagerung';
comment on column DIRKSPZM32.LVS_LGR."LGR_DIM_FIFO_NR" is 'Identisch mit LGR_DIM_T oder LGR_DIM_E';
comment on column DIRKSPZM32.LVS_LGR."LGR_DIM_G" is 'Logischer Lagergang';
comment on column DIRKSPZM32.LVS_LGR."LGR_DIM_P" is 'Logischer Lagerplatz (Zwingend minimum im LGR_PLATZ)';
comment on column DIRKSPZM32.LVS_LGR."LGR_DIM_PLATZ" is 'Logische Platz Beschreibung aus GGGG+RRRR+PPPP+EEEE+TTTT';
comment on column DIRKSPZM32.LVS_LGR."LGR_DIM_R" is 'Logisches Regal';
comment on column DIRKSPZM32.LVS_LGR."LGR_DIM_T" is 'Logische Tiefe im Regal oder Position der Palette vom Platzende';
comment on column DIRKSPZM32.LVS_LGR."LGR_DISPO_EINL_FREI_HOEHE" is 'Höhen die für Einlagerung aktuell für diesen Lagerplatz disponiert sind';
comment on column DIRKSPZM32.LVS_LGR."LGR_DISPO_EINL_KG" is 'Geplanter Zugang in KG für diesen Lagerplatz';
comment on column DIRKSPZM32.LVS_LGR."LGR_DISPO_EINL_TE" is 'Anzahl der Transporteinheiten aktuell für diesen Lagerplatz disponiert';
comment on column DIRKSPZM32.LVS_LGR."LGR_EINL_TE_VERFUEG" is 'LGR_max_TE-LGR_AKT_TE-LGR_DISPO_EINL_TE';
comment on column DIRKSPZM32.LVS_LGR."LGR_EINL_TE_VERFUEG_GRUPPE" is 'LGR_max_TE-LGR_AKT_TE-LGR_DISPO_EINL_TE der ges. LGR_PLATZ_GRUPPE';
comment on column DIRKSPZM32.LVS_LGR."LGR_FREI_BREITE" is 'Freie Breite des Lagerplatz in mm';
comment on column DIRKSPZM32.LVS_LGR."LGR_FREI_HOEHE" is 'Freie Hoehe des Lagerplatz in mm';
comment on column DIRKSPZM32.LVS_LGR."LGR_FREI_TIEFE" is 'Freie Tiefe des Lagerplatz in mm';
comment on column DIRKSPZM32.LVS_LGR."LGR_GRUPPE_ID" is 'ID Der Gruppe (Gruppe für die Zuordnung von Fahrzeugen)';
comment on column DIRKSPZM32.LVS_LGR."LGR_KG_GRUPPE" is 'Gruppe für Prozentsatz in KG die eingelagert werden dürfen (Wird beim Anlegen mit DIM_GANG, Regal und Platz gefüllt)';
comment on column DIRKSPZM32.LVS_LGR."LGR_MAX_KG" is 'Maximale Tragfähigkeit des Lagerplatzes in KG';
comment on column DIRKSPZM32.LVS_LGR."LGR_MAX_TE" is 'Anzahl der Transporteinheiten Maximal';
comment on column DIRKSPZM32.LVS_LGR."LGR_MIN_LTE_BREITE" is 'Minimale Breite der LTE in diesem Lagerplatz in mm';
comment on column DIRKSPZM32.LVS_LGR."LGR_MIN_LTE_HOEHE" is 'Minimale Hoehe der LTE in diesem Lagerplatz in mm';
comment on column DIRKSPZM32.LVS_LGR."LGR_MIN_LTE_TIEFE" is 'Minimale Tiefe der LTE in diesem Lagerplatz in mm';
comment on column DIRKSPZM32.LVS_LGR."LGR_ORDER_RES_TE" is 'Anzahl der LTE''s die für eine Order Reserviert sind';
comment on column DIRKSPZM32.LVS_LGR."LGR_ORT" is 'Referenz zum Lagerort';
comment on column DIRKSPZM32.LVS_LGR."LGR_PLATZ" is 'Lagerplatz ID gebildet aus Vorgabe im Lagerort';
comment on column DIRKSPZM32.LVS_LGR."LGR_PLATZ_ETI_PFEIL_RICHT" is 'Pfeilrichtung auf dem Lagerplatzetikett (o/u/r/l zeigt nach oben, unten, rechts oder linkks)';
comment on column DIRKSPZM32.LVS_LGR."LGR_PLATZ_GRUPPE" is 'Gruppe des Platzes (Fifo struktur)';
comment on column DIRKSPZM32.LVS_LGR."LGR_PLATZ_GRUPPE_GEGENUEBER" is 'gegenüberliegender Lagerplatzgruppe bei Gängen mit zwei seiten';
comment on column DIRKSPZM32.LVS_LGR."LGR_POS_X" is 'X-Position der Lagerplatz in mm (Lagerplatzmittelpunkt)';
comment on column DIRKSPZM32.LVS_LGR."LGR_POS_Y" is 'X-Position der Lagerplatz in mm (Lagerplatzmittelpunkt)';
comment on column DIRKSPZM32.LVS_LGR."LGR_RES_STRAT" is 'Reservierung über (A)= Anzahl TE Artikel / Reservirungsstring (O) = Oder / Auftragsbezogen RES_String = Ordernummer im Lager';
comment on column DIRKSPZM32.LVS_LGR."LGR_TEMP" is 'Temperatur des Lagers';
comment on column DIRKSPZM32.LVS_LGR."LGR_TYP" is 'BLK1, SAT1, KANAL1, KANAL_BLOCK1, REG_FACH1 .....';
comment on column DIRKSPZM32.LVS_LGR."LGR_USR_ID_ERSTELLT" is 'LS_LOGIN_ID des Erstellers';
comment on column DIRKSPZM32.LVS_LGR."LGR_VERWENDUNG" is 'WE, WA, Lager, Puffer etc., WEP Wareneingang für Palletierer, LagerP = Paletierplatz';
comment on column DIRKSPZM32.LVS_LGR."LGR_VERWENDUNG_PROJ" is 'Für Projekte individuell verwendbar (Keine Std. Logik verwendet dieses Feld)';
comment on column DIRKSPZM32.LVS_LGR."LGR_VOL_BREITE" is 'Gesamtbreite des Lagerplatz in mm';
comment on column DIRKSPZM32.LVS_LGR."LGR_VOL_HOEHE" is 'Gesamthoehe des Lagerplatz in mm';
comment on column DIRKSPZM32.LVS_LGR."LGR_VOL_TIEFE" is 'Gesamttiefe des Lagerplatz in mm';
comment on column DIRKSPZM32.LVS_LGR."LTE_NAMEN" is 'Aktuell erlaubte TEs die eingelagert werden dürfen   ''Keine''  = Lagerplatz nicht verwendbar;  Null = Alle LteNamen';
comment on column DIRKSPZM32.LVS_LGR."LTE_NAMEN_CFG" is 'Vorgabe der TE die generell z.B. wenn Leer eingelagert werden dürfen';
comment on column DIRKSPZM32.LVS_LGR."OWNER_ADDRESS_ID" is 'ID in der ISI_ADRESSEN für KONSI. Ist der Wert != NULL dann ist die Adresse dieser ID Eigentümer der Ware';
comment on column DIRKSPZM32.LVS_LGR."RES_ARTIKEL_ID" is 'Lagerplatz ist für diese Artikel_ID Statisch reserviert';
comment on column DIRKSPZM32.LVS_LGR."RES_ART_STATISCH" is 'Reservierung Statisch = Dauerhaft =''T'' sonst ''F'' ';
comment on column DIRKSPZM32.LVS_LGR."RES_LS_LOGIN_NAME" is 'Lagerplatz ist Reserviert für User';
comment on column DIRKSPZM32.LVS_LGR."RES_RES_STRING_STATISCH" is 'Reservierung von Res_String Statisch (Bediener) =''T'' sonst ''F''';
comment on column DIRKSPZM32.LVS_LGR."RES_STRING" is 'Lagerplatzreservierung für Bsp. Artikel, Charge oder FA + FA_AG + Charge etc.';
comment on column DIRKSPZM32.LVS_LGR."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.LVS_LGR."TRANSPORT_EINHEIT" is 'Transportierte Ware
 ''LTE'' = Alle LTE_CFG,
 ''LHM'' = Alle LHM_CFG,
 ''LTE_LTE'' = LTE_CFG vom Transporttyp LTE
 ''LTE_LHM'' = LTE_CFG vom Transporttyp LHM
';
comment on column DIRKSPZM32.LVS_LGR."UML_ERLAUBT" is 'T = Erlaubt R = Umlagern nur im gleichen Regal F = Gasseninternse Umlagern nicht erlaubt';
comment on column DIRKSPZM32.LVS_LGR."WAREN_TYPEN_CFG" is 'welche warentypen ''FW'',HW'',''RW'' darf hier hinein!';
comment on column DIRKSPZM32.LVS_LGR."WA_MENGE_UEBERLIEF" is 'Bei Lieferbestellungen an diesen WA darf bei T auch zu viel geliefert werden,
wenn dadurch auf eine Kommissionierung verzichtet werden kann.';
comment on column DIRKSPZM32.LVS_LGR."WA_TYP" is 'NULL = Funktion wie bisher, LDPR = Bereitstellung, LDPO = Verladepunkt LTE wird sofort ausgelagert BDEPUSH=BDE-PUSCH Normal kann auch im Typ Lager eingetragen werden (Dann Quelle für BDE-Resevierung und in ISI-Firma eingeschaltet), BDEICEPUSH = BDE-Pusch Express';
comment on column DIRKSPZM32.LVS_LGR."WERT_KLASSE" is 'Klasse für Warenwert, Wertklasse des Artikels muss <= diesem sein';



-- sqlcl_snapshot {"hash":"ffa4df56e3099f41812c1ba1cc4f94d9b7650b89","type":"COMMENT","name":"lvs_lgr","schemaName":"dirkspzm32","sxml":""}