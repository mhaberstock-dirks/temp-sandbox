comment on table DIRKSPZM32.LVS_FAHRZEUGE is 'Alle Fahrzeuge die für die innerbetrieblichen Transporte zur Verfügung stehen';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."AKT_TRANS_LTE" is 'Anzahl der aktuelle Transportierten LTE''s';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."ANZ_TEST_LTE" is 'Wenn ein Fahrzeug in der Testphase ist, soll dieses erst mal mit dieser Anzahl an LTE''s getestet werden';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."FAHRZEUG_AUSL_OK" is '''T'' = Fahrzeug ist OK und kann benutzt werden, ''F'' = Fahrzeug ist nicht bereit, ''M'' = Fahrzeug ist manuell auf fehler gestellt ''?'' = Fahzeug in der Testphase und soll erst mal nur ANZ_TEST_LTE fahren';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."FAHRZEUG_OK" is '''T'' = Fahrzeug ist OK und kann benutzt werden, ''F'' = Fahrzeug ist nicht bereit, ''M'' = Fahrzeug ist manuell auf fehler gestellt ''?'' = Fahzeug in der Testphase und soll erst mal nur ANZ_TEST_LTE fahren';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."MAX_HOEHE" is 'Maximale Höhe die dieses Fahrzeug erreichen kann (Bsp. Stalper)';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."MAX_KG" is 'Maximales Gewicht das dieses Fahrzeug transportieren kann';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."MAX_LTE" is 'Maximale Anzahl an LTE''s die das Fahrzeug transportieren kann';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."MAX_TRANS_LTE" is '0 = ohne Beschränkung Max.Anz. LTE''s (mit Fahrzeugen gilt Wert immer, ohne nur wenn Fahrzeug_OK auf ''F''alse steht)';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."STAPLER_LS_ID" is 'ID des Leitsystems';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."TRANSP_RICHTUNG" is '''B'' = Beide Richtungen, ''A'' = Nur Auslagern ''E'' = Nur Einlagern';
comment on column DIRKSPZM32.LVS_FAHRZEUGE."TYP" is 'ST = Stapler';



-- sqlcl_snapshot {"hash":"1f973c8e585e230d8c640df056cae4af326b4b77","type":"COMMENT","name":"lvs_fahrzeuge","schemaName":"dirkspzm32","sxml":""}