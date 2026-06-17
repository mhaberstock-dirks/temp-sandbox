comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_ABSCHALT_FEIN" is 'Absch. Fein';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_ABSCHALT_GROB" is 'Absch. Grob';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_ABSCHALT_MITTEL" is 'Absch. Mittel';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_BRUTTO" is 'Istmenge für der Abfüllung Brutto';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_IST" is 'Sollmenge für die Abfüllung';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_SILO" is 'Silo für Abfüllung';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_SOLL" is 'Sollmenge für die Abfüllung';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_TARA" is 'Istmenge für der Abfüllung TARA';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_TOLERANZ_MINUS" is 'Toleranz Minus';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."ABFUELL_TOLERANZ_PLUS" is 'Toleranz Plus';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."AKT_AUFGABE" is 'Akt. Aufgabe P=Produzieren R=Rüsten NULL=Kein Auftrag angemeldtet';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."AKT_AUFGABE_SEIT" is 'Seit wann ist die Aufgabe angemeldtet';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."AKT_SEQUENZ_SEIT" is 'Datum Uhrzeit, wann die aktuelle Sequenz auf dieser Resource begonnen wurde';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."AKT_TERMINAL" is 'An welchem Termial wurder der Auftrag angemeldet (Für Etikettendruck)';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."AUFTRAG_STATUS" is 'Auftrags Online Status:
Neu nur gesendet, noch nicht begonnen = ''G'';
Frei=''F''  Kein Auftrag Resource ist Leer !;
Daten=''D'' Resource hat Daten;
AuftrLaeuft=''L'' Resource mit Auftag Gestartet;
AuftrStop  =''S'' Auftrag vom Bediener gestoppt  (Nur bei Absackwaagen ! );
AuftrEnde  =''E'' Resource Fertig produziert! Soll>=Ist ;
AuftrBeenden =''B'' Recource beendet. Aktueller Zustand z.B. Leerfahren !;
Error ''E'' = Error';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."FA_AG" is 'Aktueller Arbeitsgang der Leitzahl';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."FA_SEIT" is 'Zeitpunkt, wann ein AG angemeldet wurde, oder wann das letzte Paket die Maschine verlassen hat, um den Produktionsbeginn des nächsten Pakets zu bestimmen';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."FA_UPOS" is 'Unterposition des AG bei Gruppenarbeit';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."FEHLER_RES_ID" is 'Konkrete eingebaute Resource an der ein Fehler aufgetreten ist';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."FERT_LAM_ID" is 'LAM_ID der aktuellen LAM_ID, die in diesem Moment gefertigt wird';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."LEITZAHL" is 'Fertigungsauftrag Nr. (Leitzahl)';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."LS_LOGIN_ID" is 'Aktuelles Login auf dieser Maschine für Link zum Scanner';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."LTE_ID" is 'Aktueller Ladungsträger auf dem die Produktion gestellt wird';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."MDE_COMMUNICATION" is 'F = Keine MDE Erfassung;
T = MDE-Daten sollen erfaast werden
O = MDE-Daten werden erfasst. MDE-Schnittstelle ist online
E = MDE-Daten sollen erfaast werden, MDE ist OFFLINE (Error)';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."PERS_NR" is 'Personalnummer des Maschinenführeres';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."PROD_PARAMS" is 'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."P_PLAN_NR" is 'Prüfplannummer zur Prüfplanreferenz (GTP zum Rezept)';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."P_PLAN_REF" is 'Referenz zum Prüfplan (GTP-Rezept)';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."STATUS_ID" is 'Akt Status ID';
comment on column DIRKSPZM32.ISI_RESOURCE_ZUST_AKT."STATUS_SEIT" is 'Akt. Status seit (Datum Zeit)';



-- sqlcl_snapshot {"hash":"9ef33875b4be69523efcbb9a8a45ff91e5222447","type":"COMMENT","name":"isi_resource_zust_akt","schemaName":"dirkspzm32","sxml":""}