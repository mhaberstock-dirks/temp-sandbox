comment on table dirkspzm32.aps_plan_status is
    'Status der Planung (APS)';

comment on column dirkspzm32.aps_plan_status.aend_datum is
    'Bearbeitungsdatum, zuletzt bearbeitet am';

comment on column dirkspzm32.aps_plan_status.aend_login_id is
    'ID des Bearbeiters';

comment on column dirkspzm32.aps_plan_status.aps_command is
    'StartAuto = Startet die zyklische Verarbeitung.
StopAuto  = Beendet die zyklische Verarbeitung (die laufende Planung wird zuende durchgeführt).
Run       = Startet die Planung.
Abort     = Abbrechen der laufenden Planung, Rollback der akuell geplanten Elemente.
Reset     = Abbrechen der laufenden Planung, wenn diese noch läuft mit Rollback der aktuell geplanten Elemente,
            anschließend Löschen der bereits vorher geplanten Elemente.
            Zus. werden nicht begonnene FA gelöscht';

comment on column dirkspzm32.aps_plan_status.aps_interval_sec is
    'Interval in Sekunden beim Start aus der FIRMA_CFG übernommen';

comment on column dirkspzm32.aps_plan_status.aps_mode is
    '0 = Kein Automatikmodus, 1 = Automatikmodus ist eingeschaltet';

comment on column dirkspzm32.aps_plan_status.aps_status is
    'Typ der Aktion:
PS = Start Planung,
PE = Ende Planung fertig mit Ergebnis,
PA = Planung Abgebrochen, letzes Ergebnis ist wieder hergestellt -
IMP, EXP bei Gantplan Import oder Export
U = Aktuelle Übernahme aus Plan in BDE
UE = Nötige Anzahl in BDE Übernommen ';

comment on column dirkspzm32.aps_plan_status.erz_datum is
    'Erstellungsdatum, erstellt am';

comment on column dirkspzm32.aps_plan_status.erz_login_id is
    'ID des Erstellers';

comment on column dirkspzm32.aps_plan_status.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.aps_plan_status.info_debug is
    'internes Informationsfeld';

comment on column dirkspzm32.aps_plan_status.message_code is
    'Message Return Code';

comment on column dirkspzm32.aps_plan_status.message_text is
    'Message text';

comment on column dirkspzm32.aps_plan_status.plan_status is
    'Canceled = Die Aufgabe hat den Abbruch durch Auslösen einer OperationCanceledException mit einem eigenenCancellationToken bestätigt, während das Token im Zustand „signalisiert“ war, oder das CancellationToken der Aufgabe wurde bereits vor dem Start der Aufgabenausführung signalisiert.
Created = Die Aufgabe wurde initialisiert, aber noch nicht geplant.
Faulted = Die Aufgabe wurde aufgrund eines Ausnahmefehlers abgeschlossen. 
RanToCompletion = Die Ausführung der Aufgabe wurde erfolgreich abgeschlossen. 
Running = Die Aufgabe wird ausgeführt, wurde aber noch nicht abgeschlossen. 
WaitingForActivation = Der Task wartet auf seine Aktivierung und interne Planung. 
WaitingForChildrenToComplete = Die Aufgabe hat die Ausführung beendet und wartet implizit auf den Abschluss angefügter untergeordneter Aufgaben. 
WaitingToRun = Die Aufgabe wurde zur Ausführung geplant, aber noch nicht gestartet.';

comment on column dirkspzm32.aps_plan_status.plan_ts_end is
    'Zeitpunkt der Aktion Ende';

comment on column dirkspzm32.aps_plan_status.plan_ts_start is
    'Zeitpunkt der Aktion START';

comment on column dirkspzm32.aps_plan_status.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"a19fddbd5d55e0f35997266c3f2412cb9be41f55","type":"COMMENT","name":"aps_plan_status","schemaName":"dirkspzm32","sxml":""}