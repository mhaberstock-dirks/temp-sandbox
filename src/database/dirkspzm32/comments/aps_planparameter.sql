comment on table dirkspzm32.aps_planparameter is
    'Planparameter für den Ganttplan (APS)';

comment on column dirkspzm32.aps_planparameter.anzahlergebnisse is
    'Anzahl von Ergebnissen, die im GanttPlan-Leitstand angezeigt werden können';

comment on column dirkspzm32.aps_planparameter.anzahloptimierungen is
    'Anzahl der Optimierungsdurchläufe';

comment on column dirkspzm32.aps_planparameter.chk_lgr_eigenprod is
    'Prüfen, ob Bestand an eigengefertigtem Material vorhanden ist (Einplanung eines Vorgangs nur wenn Material verfügbar). Materialbeziehungen
zwischen vorhandenen Objekten werden erstellt.
Wahrheitstyp
0 = nein, 1 = ja';

comment on column dirkspzm32.aps_planparameter.chk_lgr_zukauf is
    'Prüfen, ob Bestand an fremdbezogenem Material vorhanden ist (Einplanung eines Vorgangs nur wenn Material verfügbar). Materialbeziehungen
zwischen vorhandenen Objekten werden erstellt.
Wahrheitstyp
0 = nein, 1 = ja';

comment on column dirkspzm32.aps_planparameter.dauerstabilerzeitraum is
    'Dauer in Minuten des Stabilen Zeitraum ab IstLinie';

comment on column dirkspzm32.aps_planparameter.id is
    'eindeutige ID des Planparametersatzes';

comment on column dirkspzm32.aps_planparameter.losgroessenoptimierung is
    'Losgrößen-Optimierung: Zusammenfassen von Fertigungsaufträgen
Wahrheitstyp
0 = nein, 1 = ja';

comment on column dirkspzm32.aps_planparameter.mrp_gen_fa_auftrag is
    'Anlegen und Löschen von Fertigungsaufträgen, wenn Material nicht ausreicht bzw. nicht benötigt wird
Wahrheitstyp
0 = nein, 1 = ja';

comment on column dirkspzm32.aps_planparameter.name is
    'Bezeichnung des Planparametersatzes';

comment on column dirkspzm32.aps_planparameter.planungsart is
    'Wie werden die gewählten/ nicht gewählten Auftragstypen entsprechend der Planungstypen verplant 1=neueinplanen
2=umplanen';

comment on column dirkspzm32.aps_planparameter.planungstypen is
    '1=standard
2=vollwertige Anfrage
4=Zusatzanfrage ASAP
8=Zusatzanfrage ALAP (Zu übergeben ist die Summe aller zu planenden Typen)';

comment on column dirkspzm32.aps_planparameter.terminierung is
    'Grundlegende Terminierungsstrategie 0=Vorwärtsterminierung, 1=Engpassterminierung';

comment on column dirkspzm32.aps_planparameter.zfparamdlz is
    '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Durchlaufzeit';

comment on column dirkspzm32.aps_planparameter.zfparamfertigung is
    '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Fertigungskosten';

comment on column dirkspzm32.aps_planparameter.zfparamkapazitaetsauslastung is
    '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Kapazitätsauslastung';

comment on column dirkspzm32.aps_planparameter.zfparamkapitalbindung is
    '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Kapitalbindungskosten';

comment on column dirkspzm32.aps_planparameter.zfparampersonal is
    '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Personalkosten';

comment on column dirkspzm32.aps_planparameter.zfparamruesten is
    '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Rüstkosten';

comment on column dirkspzm32.aps_planparameter.zfparamverzug is
    '[%] 0 - 100 Gewichtung des Zielfunktionswertes für Termintreue (Verzugskosten)';


-- sqlcl_snapshot {"hash":"dd04b642d7800dddfa407da453419b880ba239f1","type":"COMMENT","name":"aps_planparameter","schemaName":"dirkspzm32","sxml":""}