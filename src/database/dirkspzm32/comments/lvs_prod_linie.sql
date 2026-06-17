comment on table DIRKSPZM32.LVS_PROD_LINIE is 'Liniendaten für die Etikettenerzeugung';
comment on column DIRKSPZM32.LVS_PROD_LINIE."ADRESS_ID" is 'Werkszugehörigkeit der Linie (kann ein eigenes weiteres Werk sein kann aber auch ein Lieferant sein)';
comment on column DIRKSPZM32.LVS_PROD_LINIE."AUTO_DEPAL" is 'Automatisches depaletieren möglich? FALSE: nicht möglich, LAGE: Nur Lagenweise depaletieren möglich, LHM: LHM weise depaletierbar, NULL: Status ist unbekannt';
comment on column DIRKSPZM32.LVS_PROD_LINIE."ERSTELLEN_MIT_TRANSPORT" is 'Transporteinheit, welche aus der Produktionslinie erstellt wird, wird automatisch eingelagert. Das heißt, es erfolgt nach der Erstellung eine Lagerplatzsuche und der dazugehörige Transport wird generiert.';
comment on column DIRKSPZM32.LVS_PROD_LINIE."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LINIE_AKTIV" is 'Aktive 1 = Ja, 0 = Nein';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LINIE_LAGERORT" is 'Ziellagerort';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LINIE_NAME" is 'Linien Name';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LINIE_NR" is 'Linie für Ware';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LINIE_PRODUKTIONSDATUM" is 'Produktionsdatum der hier zu Produzierenden Ware';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LTE_ETI_DRUCK_STATUS" is 'NULL = Kein Etikett drucken, SD= Soll Drucken (etikett muss noch gedruckt werden)';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LTE_NAME" is 'Art, Name des LTE''s Bsp.: EURO als Europalette';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LTE_VOL_BREITE" is 'Breite des LTE';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LTE_VOL_HOEHE" is 'Höhe des LTE';
comment on column DIRKSPZM32.LVS_PROD_LINIE."LTE_VOL_TIEFE" is 'Länge des LTE';
comment on column DIRKSPZM32.LVS_PROD_LINIE."PACKSCHEMA_KOPF_ID" is 'ID / Name des Packschemas';
comment on column DIRKSPZM32.LVS_PROD_LINIE."RES_ID" is 'Res_id aus ISI_RESOURCE';
comment on column DIRKSPZM32.LVS_PROD_LINIE."RES_STRING" is 'Reservierungsstring für LTE wenn null autmatische Berechnung nutzen  sonst diese';
comment on column DIRKSPZM32.LVS_PROD_LINIE."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.LVS_PROD_LINIE."WICKELPROGRAMM" is 'Wickel Programm Nr. mit der die LTE aktuell gewickelt werden soll';
comment on column DIRKSPZM32.LVS_PROD_LINIE."WICKELPROGRAMM_EINL" is 'Wickel Programm Nr. wie die LTE eingelagert werden soll';



-- sqlcl_snapshot {"hash":"bad138adc776c09aaa084d285f8be976023f8c60","type":"COMMENT","name":"lvs_prod_linie","schemaName":"dirkspzm32","sxml":""}