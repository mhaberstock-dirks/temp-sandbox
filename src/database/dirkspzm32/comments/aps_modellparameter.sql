comment on table DIRKSPZM32.APS_MODELLPARAMETER is 'Modellparameter für den Ganttplan (APS)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."AUFSCHLAGMMB" is '[%] Aufschlag bei Mehrmaschinenbedienung  (Parameter für automatische Auslastungsberechnung)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."AUTOBDEFA" is 'Definiert, ob Vorgänge für die keine Rückmeldung erwartet wird automatisch auf beendet gesetzt werden dürfen 0=nein
1=ja';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."AUTOBDESEKFA" is 'Definiert, ob Sekundäraufträge von beendet gemeldeten Primär-FA 01219 Dresden ? +49 (0) 351 – 477 91 – 0 www.dualis-it.de dualis@dualis-it.de 80
Vorgängen automatisch auf beendet gesetzt werden dürfen 0=nein
1=ja';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."DATENABISTLINIE" is 'Standarddauer für Datenbeachtung nach Istlinie in Min. (200 Tage Def.)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."DZRENDE" is 'Ende des Datenzeitraums';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."FHMPLANEN" is 'FHM werden geplant';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."ISTLINIE" is 'Planungsbezogene aktuelle Zeit';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."ISTLINIESYSTEMZEIT" is 'Aktuelle Systemzeit wird als aktuelle Planungszeit genutzt 0=nein
1=ja';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."KAPAZITAETABISTLINIE" is 'Standarddauer für Kapazitätsbereitstellung nach Istlinie in Min. (150 Tage Def.)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."KAPAZITAETVORISTLINIE" is 'Standarddauer für Kapazitätsbereitstellung vor Istlinie in Min. (5 tage Def.)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."KAPBINDZINS" is 'Kapitalbindungszins';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."KRITISCH" is 'Aufträge deren Fertigstellungstermin innerhalb dieser Zeitspanne vor dem Liefertermin liegen werden als Kritisch markiert in Min';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."LIEGENUEBERLAPPEN" is 'Vorgangsposition „liegen“ darf Vorgänger überlappen 0=nein
1=ja';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."MAXBEDIENANTEIL" is '[%] Maximale Auslastung beim Bedienen (Parameter für automatische Auslastungsberechnung)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."MAXRUESTANTEIL" is '[%] Maximale Auslastung beim Rüsten  (Parameter für automatische Auslastungsberechnung)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."MEHRMASCHINENBEDIENUNG" is 'Mehrmaschinenbedienung erlaubt';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."MINBEDIENANTEIL" is '[%] Mindestauslastung bei Bedienung  (Parameter für automatische Auslastungsberechnung)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."MINDAUERBEDIENINTERVALL" is 'Mindestdauer eines Personalplanungsintervall in Min (Aufeinanderfolgende Bearbeitung (nur durch Pausen unterbrochen) eines Personals muss mindestens so groß sein, damit dieser Intervall von Planung beachtet wird)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."MINDAUERMEHRSCHICHT" is 'Mindestdauer für Mehrschichtbearbeitung in Min';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."MINDAUERMMB" is 'Mindestdauer, damit Mehrmaschinenbedienung möglich';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."NAME" is 'Bezeichnung des Planparametersatzes';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."PERSONALPLANEN" is 'Personal wird geplant 0=nein
1=ja';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."PRIOLAGERBEDARF" is 'Definiert, mit welcher Prioritätsdefinition Lagerbedarfe eingeplant werden sollen';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."PUFFERMATLIEF" is 'Sicherheitszeit zwischen Materiallieferung und Verbrauch in Min (2 Tage Def.)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."PZRDZRAUTOMBERECHNEN" is 'DZR/PZR-Start/Ende werden anhand Istzeit und Standards aus Modellparametern berechnet 0=nein
1=ja';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."PZRENDE" is 'Ende des Planungszeitraums';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."PZRSTART" is 'Start des Planungszeitraums, d.h. der Planungshorizont, für den der Produktionsplan erstellt wird';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."RUESTUEBERLAPPEN" is 'Vorgangsposition „rüsten“ darf Vorgänger überlappen 0=nein
1=ja';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."SICHERHEITSZEIT" is 'Sicherheitszeit zwischen Planende und Bedarfstermin in Min. (2 Tage Def.)';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."VERSPAETET" is 'Aufträge mit dieser Verspätung werden als verspätet markiert in Min.';
comment on column DIRKSPZM32.APS_MODELLPARAMETER."ZIELFUNKTIONSTYP" is 'Typ der Zielfunktionsberechnung 0 = Zeit
1 = Kosten';



-- sqlcl_snapshot {"hash":"4649c92773c94b2a3814bbfee86d4495140df781","type":"COMMENT","name":"aps_modellparameter","schemaName":"dirkspzm32","sxml":""}