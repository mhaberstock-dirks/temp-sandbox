comment on table DIRKSPZM32.LVS_LTE is 'Transporteinheiten';
comment on column DIRKSPZM32.LVS_LTE."ABC" is 'A = Schnell B = Mittel C = Langsam';
comment on column DIRKSPZM32.LVS_LTE."AKT_INVENTUR_ID" is 'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR';
comment on column DIRKSPZM32.LVS_LTE."ANZ_UML" is 'Anzahl der Umlagerungen ';
comment on column DIRKSPZM32.LVS_LTE."AUTO_DEPAL" is 'Automatisches depaletieren möglich?
 T = True, F = False und NULL Unbekannt ob möglich oder nicht';
comment on column DIRKSPZM32.LVS_LTE."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_LTE."GEFAHREN_KLASSE" is '0 = Klein, 99 = Hoch';
comment on column DIRKSPZM32.LVS_LTE."KOMM_MENGE_KONTROLLE" is 'TK = Die Menge muss auf einem Komm-Platz kontrolliert werden, N oder TD LTE kann dierekt zum Ziel, wenn diese komplett benötigt wird';
comment on column DIRKSPZM32.LVS_LTE."LETZTE_INVENTUR_DATUM" is 'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';
comment on column DIRKSPZM32.LVS_LTE."LETZTE_INVENTUR_ID" is 'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';
comment on column DIRKSPZM32.LVS_LTE."LETZTE_INVENTUR_LOGIN_ID" is 'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die Inventur hier durchgeführt';
comment on column DIRKSPZM32.LVS_LTE."LGR_PLATZ" is 'Lagerplatz auf dem die TE steht';
comment on column DIRKSPZM32.LVS_LTE."LKW_NR" is 'Gruppiert mehrere Touren (Vorgänge)';
comment on column DIRKSPZM32.LVS_LTE."LS_LOGIN_ID" is 'Login ID des Erfassers';
comment on column DIRKSPZM32.LVS_LTE."LTE_AKT_KG" is 'Aktuelles Gewicht der Waren auf dieser Transporteinheit in KG';
comment on column DIRKSPZM32.LVS_LTE."LTE_AKT_LHM" is 'Anzahl der LHM''s auf diesem LTE';
comment on column DIRKSPZM32.LVS_LTE."LTE_ETI_DRUCK_STATUS" is 'NULL = Kein Etikett gedruckt, SD= Soll Drucken (etikett muss noch gedruckt werden), D=Etikett gedruckt und vorhanden';
comment on column DIRKSPZM32.LVS_LTE."LTE_ID" is 'Transporteinheit ID (PID Paletten ID)';
comment on column DIRKSPZM32.LVS_LTE."LTE_INV_STATUS" is 'Inventurstatus';
comment on column DIRKSPZM32.LVS_LTE."LTE_LETZTE_BUCHUNG" is 'Datum und Zeit der letzten Buchung';
comment on column DIRKSPZM32.LVS_LTE."LTE_NAME" is 'Art, Name der Transporteinheit';
comment on column DIRKSPZM32.LVS_LTE."LTE_OFFSET_X" is 'X-Position Y-Position Offset zum Mittelpunkt des Lagerplatz in mm (Lagerplatzmittelpunkt)';
comment on column DIRKSPZM32.LVS_LTE."LTE_OFFSET_Y" is 'Y-Position Offset zum Mittelpunkt des Lagerplatz in mm (Lagerplatzmittelpunkt)';
comment on column DIRKSPZM32.LVS_LTE."LTE_OFFSET_Z" is 'Z Position der LTE (Absolut)';
comment on column DIRKSPZM32.LVS_LTE."LTE_STATUS" is 'Z,B. ''BS'' = Wird befüllt, ''BF'' Befüller fertig, kann transportiert werden .... Siehe C.LTE_xx_STAT';
comment on column DIRKSPZM32.LVS_LTE."LTE_VOL" is 'Volumen in m3';
comment on column DIRKSPZM32.LVS_LTE."LTE_VOLL" is 'A = Anbruch, V = Voll (Std-Menge, oder Angelieferte Menge bei Rohware)';
comment on column DIRKSPZM32.LVS_LTE."LTE_VOL_BREITE" is 'Gesamtbreite der Transporteinheit in mm';
comment on column DIRKSPZM32.LVS_LTE."LTE_VOL_HOEHE" is 'Gesamthoehe der Transporteinheit in mm';
comment on column DIRKSPZM32.LVS_LTE."LTE_VOL_TIEFE" is 'Gesamttiefe der Transporteinheit in mm';
comment on column DIRKSPZM32.LVS_LTE."MAX_TEMP" is 'maximale temperatur der ware';
comment on column DIRKSPZM32.LVS_LTE."MIN_TEMP" is 'Minimale temperatur der Ware';
comment on column DIRKSPZM32.LVS_LTE."NVE_NR" is 'Eindeutigen Nummer aus Vergabe';
comment on column DIRKSPZM32.LVS_LTE."ORDER_AUF_ID" is 'Auf_ID aus der ISI-Order';
comment on column DIRKSPZM32.LVS_LTE."ORDER_VORGANG_ID" is 'Kopf der ISI-Order, wenn Ware auf  dieser LTE  für diese Order reserviert ist sont  null';
comment on column DIRKSPZM32.LVS_LTE."PACKSCHEMA_KOPF_ID" is 'ID / Name des Packschemas';
comment on column DIRKSPZM32.LVS_LTE."RES_ARTIKEL_ID" is 'Artikel_ID als String, kann auch ''MP'' für Mischpaltette sein';
comment on column DIRKSPZM32.LVS_LTE."RES_LOGIN_ID" is 'User, für den diese LTE reserviert ist. Nicht zwingend für Lieferschein/Verladung-Order';
comment on column DIRKSPZM32.LVS_LTE."RES_MHD" is 'Gleich, solange gleiche Tage im Firmenstamm';
comment on column DIRKSPZM32.LVS_LTE."RES_STRING" is 'Lagerplatzreservierung für Bsp. Artikel, Charge oder FA + FA_AG + Charge etc.';
comment on column DIRKSPZM32.LVS_LTE."RES_STRING_STATISCH" is 'Reservierungsstring für LTE wenn null autmatische Berechnung nutzen  sonst diese';
comment on column DIRKSPZM32.LVS_LTE."RES_ZIEL_LGR_PLATZ" is 'Reservierte Ware soll zum Ziel-Lagerplatz';
comment on column DIRKSPZM32.LVS_LTE."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.LVS_LTE."TRANSPORT_GRUPPE" is 'Beladereihenfolge für einen LKW Tournummer im MFR';
comment on column DIRKSPZM32.LVS_LTE."WAREN_TYP" is 'RW = Rohware, HW = Teilfertig/Halbfertigware (Zwischenprodukt), FW Fertigware, MP mischpalette LP leerpalette';
comment on column DIRKSPZM32.LVS_LTE."WERT_KLASSE" is '0 = Klein, 99 = Hoch';
comment on column DIRKSPZM32.LVS_LTE."WICKELPROGRAMM" is 'Wickel Programm Nr. mit der die LTE aktuell gewickelt werden soll';
comment on column DIRKSPZM32.LVS_LTE."WICKELPROGRAMM_EINL" is 'Wickel Programm Nr. wie die LTE eingelagert werden soll';
comment on column DIRKSPZM32.LVS_LTE."ZIEL_LGR_ORT" is 'Ziel Lagerort';
comment on column DIRKSPZM32.LVS_LTE."ZIEL_LGR_ORT_N_FREIF" is 'Ziel Lagerort der nach dem Freifahern wieder gesetzt werde soll';
comment on column DIRKSPZM32.LVS_LTE."ZIEL_LGR_PLATZ" is 'Ziel Lagerplatz';
comment on column DIRKSPZM32.LVS_LTE."ZIEL_LGR_PLATZ_N_FREIF" is 'Ziel Lagerplatz der nach dem Freifahern wieder gesetzt werde soll';



-- sqlcl_snapshot {"hash":"8e86679b6148504f254ecee8c986137dc16b1778","type":"COMMENT","name":"lvs_lte","schemaName":"dirkspzm32","sxml":""}