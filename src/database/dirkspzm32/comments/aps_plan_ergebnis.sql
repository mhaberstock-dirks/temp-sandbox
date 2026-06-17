comment on table DIRKSPZM32.APS_PLAN_ERGEBNIS is 'Planergebnis aus APS';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."ABNR" is 'Auftrag Bestätigungsnummer (PLEIT) oder Batch';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."AB_TEXT1" is 'benutzerdefinierter Eintrag';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."AB_TEXT2" is 'benutzerdefinierter Eintrag';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."AB_TEXT3" is 'benutzerdefinierter Eintrag';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."ADR_ID" is 'ID der Kundennummer für diesen Planauftrag';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."AG_BEZ1" is 'Bezeichnung1 des Fertigungsauftrags';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."AG_BEZ2" is 'Bezeichnung1 des Fertigungsauftrags';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."AG_TEXT1" is 'benutzerdefinierter Eintrag';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."AG_TEXT2" is 'benutzerdefinierter Eintrag';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."AG_TEXT3" is 'benutzerdefinierter Eintrag';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."APS_PLAN_AUFTRAG_NR" is 'eindeutige ID des Fertigungsauftrags';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."APS_PLAN_STATUS" is 'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."ARTIKEL_ID" is 'Nummer des Artikels/Materials, der/das mit diesem Fertigungsauftrag zu fertigen ist';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."BEARB_DATUM" is 'Bearbeitungsdatum, zuletzt bearbeitet am';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."DUEDATE" is 'Termin des Produktionsendes des Auftrags, d.h. noch ohne Transportzeit etc.';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."EARLIEST_START_DATE" is 'frühest möglicher Starttermin dieses Auftrags, d.h. der Termin, ab dem der Auftrag zur Fertigung freigegeben ist';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."ERSTELL_DATUM" is 'Erstellungsdatum, erstellt am';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."FEHLER_CODE" is 'Fehlernummer';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."FEHLER_TEXT" is 'Fehlertext';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."FIXED_PROPERTIES" is '"Angabe, ob Termin, Planungstyp und Priorität fest vorgegeben sind (-> keine automatische Berechnung)
Wahrheitstyp
0 = nein, 1 = ja"';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."INFO_DEBUG" is 'internes Informationsfeld';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."LEITZAHL" is 'BDE_FA_LEITZAHL nach der Übertragung in das ISI-System';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."LOCKED" is '"Angabe, ob Fertigungsauftrag für die Planung gesperrt ist
Wahrheitstyp
0 = nein, 1 = ja"';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."PLANNING_TYPE" is '"Es können Anfragen an die Planung, z.B. um Aussagen über die Machbarkeit von Kundenaufträgen zu bekommen, gestellt werden. Angabe, um welche Art von
Anfragen es sich handelt.
Planungstyp
Wert Bezeichnung Beschreibung
0 undefiniert
1 normaler Auftrag (Optimierung) Auftrag zur Deckung eines Bedarfs, Einplanung optimal entsprechend den Optimierungsparametern
2 vollwertige Anfrage Anfrage mit gleicher Behandlung wie normaler Auftrag
4 Zusatzanfrage ohne Termin Einplanung des Auftrags nach der Optimierung so früh wie möglich
8 Zusatzanfrage mit Termin Einplanung des Auftrags nach der Optimierung so nahe wie möglich am Liefertermin des Bedarfs"';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."PRIORITY" is 'Nummer der Priorität des Auftrags';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."ROUTING_ID" is 'eindeutige ID des Arbeitsplans, mit dem dieser Fertigungsauftrag gefertigt werden soll';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."SCHEDULING_STATUS" is '"Planstatus des Auftrags
Planstatustyp
Wert Bezeichnung Beschreibung
1 nicht geplant FA ist nicht oder nur zum Teil eingeplant.
4 verspätet FA ist komplett geplant, aber verspätet.
8 kritisch FA ist komplett geplant und pünktlich.
16 ok FA ist komplett geplant und überpünktlich."';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."SOLL_MENGE" is 'Menge (ohne Ausschuss), die mit diesem Fertigungsauftrag zu fertigen ist';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."STATUS" is '"Fertigungszustand des Auftrags
Fertigungsauftragsstatustyp
Wert Bezeichnung Beschreibung
1 Ungeplant
2 Teilgeplant Nur für Fertigungsaufträge gültig.
4 Geplant
8 Gestartet
16 Teilrückgemeldet Nur für Fertigungsauftragsvorgänge gültig.
32 Beendet"';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."TERMIN_ENDE_GEPL" is 'Geplantes Ende des Auftrags';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."TERMIN_START_GEPL" is 'Geplantes Ende des Auftrags';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."TRANSFER_STATUS" is 'Übertragung Status; N=Neu, U=In Übertragung in BDE_FA_AUFTRAG, UE=erfolgreich übertragen, F=Fehler';
comment on column DIRKSPZM32.APS_PLAN_ERGEBNIS."VALUE_PRODUCTION" is '"Kosten für eigene Herstellung für Auftragsmenge [€]
Falls <0, wird aus Material übernommen"';



-- sqlcl_snapshot {"hash":"251a408e4edc3617d74fac5362d87618f8b215ab","type":"COMMENT","name":"aps_plan_ergebnis","schemaName":"dirkspzm32","sxml":""}