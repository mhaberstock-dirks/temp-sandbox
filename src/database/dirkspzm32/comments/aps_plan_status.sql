comment on table DIRKSPZM32.APS_PLAN_STATUS is 'Status der Planung (APS)';
comment on column DIRKSPZM32.APS_PLAN_STATUS."AEND_DATUM" is 'Bearbeitungsdatum, zuletzt bearbeitet am';
comment on column DIRKSPZM32.APS_PLAN_STATUS."AEND_LOGIN_ID" is 'ID des Bearbeiters';
comment on column DIRKSPZM32.APS_PLAN_STATUS."APS_COMMAND" is 'StartAuto = Startet die zyklische Verarbeitung.
StopAuto  = Beendet die zyklische Verarbeitung (die laufende Planung wird zuende durchgeführt).
Run       = Startet die Planung.
Abort     = Abbrechen der laufenden Planung, Rollback der akuell geplanten Elemente.
Reset     = Abbrechen der laufenden Planung, wenn diese noch läuft mit Rollback der aktuell geplanten Elemente,
            anschließend Löschen der bereits vorher geplanten Elemente.
            Zus. werden nicht begonnene FA gelöscht';
comment on column DIRKSPZM32.APS_PLAN_STATUS."APS_INTERVAL_SEC" is 'Interval in Sekunden beim Start aus der FIRMA_CFG übernommen';
comment on column DIRKSPZM32.APS_PLAN_STATUS."APS_MODE" is '0 = Kein Automatikmodus, 1 = Automatikmodus ist eingeschaltet';
comment on column DIRKSPZM32.APS_PLAN_STATUS."APS_STATUS" is 'Typ der Aktion:
PS = Start Planung,
PE = Ende Planung fertig mit Ergebnis,
PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt -
IMP, EXP bei Gantplan Import oder Export
U = Aktuelle Übernahme aus Plan in BDE
UE = Nötige Anzahl in BDE Übernommen ';
comment on column DIRKSPZM32.APS_PLAN_STATUS."ERZ_DATUM" is 'Erstellungsdatum, erstellt am';
comment on column DIRKSPZM32.APS_PLAN_STATUS."ERZ_LOGIN_ID" is 'ID des Erstellers';
comment on column DIRKSPZM32.APS_PLAN_STATUS."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.APS_PLAN_STATUS."INFO_DEBUG" is 'internes Informationsfeld';
comment on column DIRKSPZM32.APS_PLAN_STATUS."MESSAGE_CODE" is 'Message Return Code';
comment on column DIRKSPZM32.APS_PLAN_STATUS."MESSAGE_TEXT" is 'Message text';
comment on column DIRKSPZM32.APS_PLAN_STATUS."PLAN_STATUS" is 'Canceled = Die Aufgabe hat den Abbruch durch Auslösen einer OperationCanceledException mit einem eigenenCancellationToken bestätigt, während das Token im Zustand „signalisiert“ war, oder das CancellationToken der Aufgabe wurde bereits vor dem Start der Aufgabenausführung signalisiert.
Created = Die Aufgabe wurde initialisiert, aber noch nicht geplant.
Faulted = Die Aufgabe wurde aufgrund eines Ausnahmefehlers abgeschlossen. 
RanToCompletion = Die Ausführung der Aufgabe wurde erfolgreich abgeschlossen. 
Running = Die Aufgabe wird ausgeführt, wurde aber noch nicht abgeschlossen. 
WaitingForActivation = Der Task wartet auf seine Aktivierung und interne Planung. 
WaitingForChildrenToComplete = Die Aufgabe hat die Ausführung beendet und wartet implizit auf den Abschluss angefügter untergeordneter Aufgaben. 
WaitingToRun = Die Aufgabe wurde zur Ausführung geplant, aber noch nicht gestartet.';
comment on column DIRKSPZM32.APS_PLAN_STATUS."PLAN_TS_END" is 'Zeitpunkt der Aktion Ende';
comment on column DIRKSPZM32.APS_PLAN_STATUS."PLAN_TS_START" is 'Zeitpunkt der Aktion START';
comment on column DIRKSPZM32.APS_PLAN_STATUS."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"637a05f411aeed10426ea3e98d8f49126d9407cf","type":"COMMENT","name":"aps_plan_status","schemaName":"dirkspzm32","sxml":""}