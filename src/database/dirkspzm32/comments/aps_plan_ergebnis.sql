comment on table dirkspzm32.aps_plan_ergebnis is
    'Planergebnis aus APS';

comment on column dirkspzm32.aps_plan_ergebnis.abnr is
    'Auftrag Bestätigungsnummer (PLEIT) oder Batch';

comment on column dirkspzm32.aps_plan_ergebnis.ab_text1 is
    'benutzerdefinierter Eintrag';

comment on column dirkspzm32.aps_plan_ergebnis.ab_text2 is
    'benutzerdefinierter Eintrag';

comment on column dirkspzm32.aps_plan_ergebnis.ab_text3 is
    'benutzerdefinierter Eintrag';

comment on column dirkspzm32.aps_plan_ergebnis.adr_id is
    'ID der Kundennummer für diesen Planauftrag';

comment on column dirkspzm32.aps_plan_ergebnis.ag_bez1 is
    'Bezeichnung1 des Fertigungsauftrags';

comment on column dirkspzm32.aps_plan_ergebnis.ag_bez2 is
    'Bezeichnung1 des Fertigungsauftrags';

comment on column dirkspzm32.aps_plan_ergebnis.ag_text1 is
    'benutzerdefinierter Eintrag';

comment on column dirkspzm32.aps_plan_ergebnis.ag_text2 is
    'benutzerdefinierter Eintrag';

comment on column dirkspzm32.aps_plan_ergebnis.ag_text3 is
    'benutzerdefinierter Eintrag';

comment on column dirkspzm32.aps_plan_ergebnis.aps_plan_auftrag_nr is
    'eindeutige ID des Fertigungsauftrags';

comment on column dirkspzm32.aps_plan_ergebnis.aps_plan_status is
    'PS = Planung gestartet PE = Ende Planung fertig mit Ergebnis, PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt - RET = Rettung letzer Planungslauf mit Status Fertig'
    ;

comment on column dirkspzm32.aps_plan_ergebnis.artikel_id is
    'Nummer des Artikels/Materials, der/das mit diesem Fertigungsauftrag zu fertigen ist';

comment on column dirkspzm32.aps_plan_ergebnis.bearb_datum is
    'Bearbeitungsdatum, zuletzt bearbeitet am';

comment on column dirkspzm32.aps_plan_ergebnis.duedate is
    'Termin des Produktionsendes des Auftrags, d.h. noch ohne Transportzeit etc.';

comment on column dirkspzm32.aps_plan_ergebnis.earliest_start_date is
    'frühest möglicher Starttermin dieses Auftrags, d.h. der Termin, ab dem der Auftrag zur Fertigung freigegeben ist';

comment on column dirkspzm32.aps_plan_ergebnis.erstell_datum is
    'Erstellungsdatum, erstellt am';

comment on column dirkspzm32.aps_plan_ergebnis.fehler_code is
    'Fehlernummer';

comment on column dirkspzm32.aps_plan_ergebnis.fehler_text is
    'Fehlertext';

comment on column dirkspzm32.aps_plan_ergebnis.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.aps_plan_ergebnis.fixed_properties is
    '"Angabe, ob Termin, Planungstyp und Priorität fest vorgegeben sind (-> keine automatische Berechnung)
Wahrheitstyp
0 = nein, 1 = ja"';

comment on column dirkspzm32.aps_plan_ergebnis.info_debug is
    'internes Informationsfeld';

comment on column dirkspzm32.aps_plan_ergebnis.leitzahl is
    'BDE_FA_LEITZAHL nach der Übertragung in das ISI-System';

comment on column dirkspzm32.aps_plan_ergebnis.locked is
    '"Angabe, ob Fertigungsauftrag für die Planung gesperrt ist
Wahrheitstyp
0 = nein, 1 = ja"';

comment on column dirkspzm32.aps_plan_ergebnis.planning_type is
    '"Es können Anfragen an die Planung, z.B. um Aussagen über die Machbarkeit von Kundenaufträgen zu bekommen, gestellt werden. Angabe, um welche Art von
Anfragen es sich handelt.
Planungstyp
Wert Bezeichnung Beschreibung
0 undefiniert
1 normaler Auftrag (Optimierung) Auftrag zur Deckung eines Bedarfs, Einplanung optimal entsprechend den Optimierungsparametern
2 vollwertige Anfrage Anfrage mit gleicher Behandlung wie normaler Auftrag
4 Zusatzanfrage ohne Termin Einplanung des Auftrags nach der Optimierung so früh wie möglich
8 Zusatzanfrage mit Termin Einplanung des Auftrags nach der Optimierung so nahe wie möglich am Liefertermin des Bedarfs"';

comment on column dirkspzm32.aps_plan_ergebnis.priority is
    'Nummer der Priorität des Auftrags';

comment on column dirkspzm32.aps_plan_ergebnis.routing_id is
    'eindeutige ID des Arbeitsplans, mit dem dieser Fertigungsauftrag gefertigt werden soll';

comment on column dirkspzm32.aps_plan_ergebnis.scheduling_status is
    '"Planstatus des Auftrags
Planstatustyp
Wert Bezeichnung Beschreibung
1 nicht geplant FA ist nicht oder nur zum Teil eingeplant.
4 verspätet FA ist komplett geplant, aber verspätet.
8 kritisch FA ist komplett geplant und pünktlich.
16 ok FA ist komplett geplant und überpünktlich."';

comment on column dirkspzm32.aps_plan_ergebnis.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.aps_plan_ergebnis.soll_menge is
    'Menge (ohne Ausschuss), die mit diesem Fertigungsauftrag zu fertigen ist';

comment on column dirkspzm32.aps_plan_ergebnis.status is
    '"Fertigungszustand des Auftrags
Fertigungsauftragsstatustyp
Wert Bezeichnung Beschreibung
1 Ungeplant
2 Teilgeplant Nur für Fertigungsaufträge gültig.
4 Geplant
8 Gestartet
16 Teilrückgemeldet Nur für Fertigungsauftragsvorgänge gültig.
32 Beendet"';

comment on column dirkspzm32.aps_plan_ergebnis.termin_ende_gepl is
    'Geplantes Ende des Auftrags';

comment on column dirkspzm32.aps_plan_ergebnis.termin_start_gepl is
    'Geplantes Ende des Auftrags';

comment on column dirkspzm32.aps_plan_ergebnis.transfer_status is
    'Übertragung Status; N=Neu, U=In Übertragung in BDE_FA_AUFTRAG, UE=erfolgreich übertragen, F=Fehler';

comment on column dirkspzm32.aps_plan_ergebnis.value_production is
    '"Kosten für eigene Herstellung für Auftragsmenge [€]
Falls <0, wird aus Material übernommen"';


-- sqlcl_snapshot {"hash":"7632076b16737d7ff7a2f68c07672469d37278b7","type":"COMMENT","name":"aps_plan_ergebnis","schemaName":"dirkspzm32","sxml":""}