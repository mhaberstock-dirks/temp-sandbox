comment on table dirkspzm32.aps_modellparameter is
    'Modellparameter für den Ganttplan (APS)';

comment on column dirkspzm32.aps_modellparameter.aufschlagmmb is
    '[%] Aufschlag bei Mehrmaschinenbedienung  (Parameter für automatische Auslastungsberechnung)';

comment on column dirkspzm32.aps_modellparameter.autobdefa is
    'Definiert, ob Vorgänge für die keine Rückmeldung erwartet wird automatisch auf beendet gesetzt werden dürfen 0=nein
1=ja';

comment on column dirkspzm32.aps_modellparameter.autobdesekfa is
    'Definiert, ob Sekundäraufträge von beendet gemeldeten Primär-FA 01219 Dresden ? +49 (0) 351 – 477 91 – 0 www.dualis-it.de dualis@dualis-it.de 80
Vorgängen automatisch auf beendet gesetzt werden dürfen 0=nein
1=ja';

comment on column dirkspzm32.aps_modellparameter.datenabistlinie is
    'Standarddauer für Datenbeachtung nach Istlinie in Min. (200 Tage Def.)';

comment on column dirkspzm32.aps_modellparameter.dzrende is
    'Ende des Datenzeitraums';

comment on column dirkspzm32.aps_modellparameter.fhmplanen is
    'FHM werden geplant';

comment on column dirkspzm32.aps_modellparameter.istlinie is
    'Planungsbezogene aktuelle Zeit';

comment on column dirkspzm32.aps_modellparameter.istliniesystemzeit is
    'Aktuelle Systemzeit wird als aktuelle Planungszeit genutzt 0=nein
1=ja';

comment on column dirkspzm32.aps_modellparameter.kapazitaetabistlinie is
    'Standarddauer für Kapazitätsbereitstellung nach Istlinie in Min. (150 Tage Def.)';

comment on column dirkspzm32.aps_modellparameter.kapazitaetvoristlinie is
    'Standarddauer für Kapazitätsbereitstellung vor Istlinie in Min. (5 tage Def.)';

comment on column dirkspzm32.aps_modellparameter.kapbindzins is
    'Kapitalbindungszins';

comment on column dirkspzm32.aps_modellparameter.kritisch is
    'Aufträge deren Fertigstellungstermin innerhalb dieser Zeitspanne vor dem Liefertermin liegen werden als Kritisch markiert in Min'
    ;

comment on column dirkspzm32.aps_modellparameter.liegenueberlappen is
    'Vorgangsposition „liegen“ darf Vorgänger überlappen 0=nein
1=ja';

comment on column dirkspzm32.aps_modellparameter.maxbedienanteil is
    '[%] Maximale Auslastung beim Bedienen (Parameter für automatische Auslastungsberechnung)';

comment on column dirkspzm32.aps_modellparameter.maxruestanteil is
    '[%] Maximale Auslastung beim Rüsten  (Parameter für automatische Auslastungsberechnung)';

comment on column dirkspzm32.aps_modellparameter.mehrmaschinenbedienung is
    'Mehrmaschinenbedienung erlaubt';

comment on column dirkspzm32.aps_modellparameter.minbedienanteil is
    '[%] Mindestauslastung bei Bedienung  (Parameter für automatische Auslastungsberechnung)';

comment on column dirkspzm32.aps_modellparameter.mindauerbedienintervall is
    'Mindestdauer eines Personalplanungsintervall in Min (Aufeinanderfolgende Bearbeitung (nur durch Pausen unterbrochen) eines Personals muss mindestens so groß sein, damit dieser Intervall von Planung beachtet wird)'
    ;

comment on column dirkspzm32.aps_modellparameter.mindauermehrschicht is
    'Mindestdauer für Mehrschichtbearbeitung in Min';

comment on column dirkspzm32.aps_modellparameter.mindauermmb is
    'Mindestdauer, damit Mehrmaschinenbedienung möglich';

comment on column dirkspzm32.aps_modellparameter.name is
    'Bezeichnung des Planparametersatzes';

comment on column dirkspzm32.aps_modellparameter.personalplanen is
    'Personal wird geplant 0=nein
1=ja';

comment on column dirkspzm32.aps_modellparameter.priolagerbedarf is
    'Definiert, mit welcher Prioritätsdefinition Lagerbedarfe eingeplant werden sollen';

comment on column dirkspzm32.aps_modellparameter.puffermatlief is
    'Sicherheitszeit zwischen Materiallieferung und Verbrauch in Min (2 Tage Def.)';

comment on column dirkspzm32.aps_modellparameter.pzrdzrautomberechnen is
    'DZR/PZR-Start/Ende werden anhand Istzeit und Standards aus Modellparametern berechnet 0=nein
1=ja';

comment on column dirkspzm32.aps_modellparameter.pzrende is
    'Ende des Planungszeitraums';

comment on column dirkspzm32.aps_modellparameter.pzrstart is
    'Start des Planungszeitraums, d.h. der Planungshorizont, für den der Produktionsplan erstellt wird';

comment on column dirkspzm32.aps_modellparameter.ruestueberlappen is
    'Vorgangsposition „rüsten“ darf Vorgänger überlappen 0=nein
1=ja';

comment on column dirkspzm32.aps_modellparameter.sicherheitszeit is
    'Sicherheitszeit zwischen Planende und Bedarfstermin in Min. (2 Tage Def.)';

comment on column dirkspzm32.aps_modellparameter.verspaetet is
    'Aufträge mit dieser Verspätung werden als verspätet markiert in Min.';

comment on column dirkspzm32.aps_modellparameter.zielfunktionstyp is
    'Typ der Zielfunktionsberechnung 0 = Zeit
1 = Kosten';


-- sqlcl_snapshot {"hash":"b8141fd0715bc1c6bcfb3857e38e91c8135f3c07","type":"COMMENT","name":"aps_modellparameter","schemaName":"dirkspzm32","sxml":""}