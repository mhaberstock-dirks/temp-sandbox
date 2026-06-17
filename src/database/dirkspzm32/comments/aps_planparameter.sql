comment on table DIRKSPZM32.APS_PLANPARAMETER is 'Planparameter für den Ganttplan (APS)';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ANZAHLERGEBNISSE" is 'Anzahl von Ergebnissen, die im GanttPlan-Leitstand angezeigt werden können';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ANZAHLOPTIMIERUNGEN" is 'Anzahl der Optimierungsdurchläufe';
comment on column DIRKSPZM32.APS_PLANPARAMETER."CHK_LGR_EIGENPROD" is 'Prüfen, ob Bestand an eigengefertigtem Material vorhanden ist (Einplanung eines Vorgangs nur wenn Material verfügbar). Materialbeziehungen
zwischen vorhandenen Objekten werden erstellt.
Wahrheitstyp
0 = nein, 1 = ja';
comment on column DIRKSPZM32.APS_PLANPARAMETER."CHK_LGR_ZUKAUF" is 'Prüfen, ob Bestand an fremdbezogenem Material vorhanden ist (Einplanung eines Vorgangs nur wenn Material verfügbar). Materialbeziehungen
zwischen vorhandenen Objekten werden erstellt.
Wahrheitstyp
0 = nein, 1 = ja';
comment on column DIRKSPZM32.APS_PLANPARAMETER."DAUERSTABILERZEITRAUM" is 'Dauer in Minuten des Stabilen Zeitraum ab IstLinie';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ID" is 'eindeutige ID des Planparametersatzes';
comment on column DIRKSPZM32.APS_PLANPARAMETER."LOSGROESSENOPTIMIERUNG" is 'Losgrößen-Optimierung: Zusammenfassen von Fertigungsaufträgen
Wahrheitstyp
0 = nein, 1 = ja';
comment on column DIRKSPZM32.APS_PLANPARAMETER."MRP_GEN_FA_AUFTRAG" is 'Anlegen und Löschen von Fertigungsaufträgen, wenn Material nicht ausreicht bzw. nicht benötigt wird
Wahrheitstyp
0 = nein, 1 = ja';
comment on column DIRKSPZM32.APS_PLANPARAMETER."NAME" is 'Bezeichnung des Planparametersatzes';
comment on column DIRKSPZM32.APS_PLANPARAMETER."PLANUNGSART" is 'Wie werden die gewählten/ nicht gewählten Auftragstypen entsprechend der Planungstypen verplant 1=neueinplanen
2=umplanen';
comment on column DIRKSPZM32.APS_PLANPARAMETER."PLANUNGSTYPEN" is '1=standard
2=vollwertige Anfrage
4=Zusatzanfrage ASAP
8=Zusatzanfrage ALAP (Zu übergeben ist die Summe aller zu planenden Typen)';
comment on column DIRKSPZM32.APS_PLANPARAMETER."TERMINIERUNG" is 'Grundlegende Terminierungsstrategie 0=Vorwärtsterminierung, 1=Engpassterminierung';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ZFPARAMDLZ" is '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Durchlaufzeit';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ZFPARAMFERTIGUNG" is '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Fertigungskosten';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ZFPARAMKAPAZITAETSAUSLASTUNG" is '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Kapazitätsauslastung';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ZFPARAMKAPITALBINDUNG" is '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Kapitalbindungskosten';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ZFPARAMPERSONAL" is '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Personalkosten';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ZFPARAMRUESTEN" is '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Rüstkosten';
comment on column DIRKSPZM32.APS_PLANPARAMETER."ZFPARAMVERZUG" is '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Termintreue (Verzugskosten)';



-- sqlcl_snapshot {"hash":"5c10ee91e22cb84f6f214a9b2dd8a0d185c11138","type":"COMMENT","name":"aps_planparameter","schemaName":"dirkspzm32","sxml":""}