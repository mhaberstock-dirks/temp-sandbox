comment on table DIRKSPZM32.PZM_ZEITERFASSUNG is 'Zeiterfassung (Daten immer Anmeldung und Abmeldung ein Datensatz.';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_AA_STATUS" is 'Abwesenheitsart-ID (Foreign-Key PZM_ABWESENHEITSARTEN)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_ABT_ID" is 'Abteilung-ID';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_BEMERKUNG" is 'Bemerkung';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_CALC_IST_ENDE" is 'Ende bis wann die verechneten Stunden gewertet werden, anhand des Schichtmodels';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_CALC_IST_START" is 'Anfang ab wann die verechneten Stunden gewertet werden, anhand des Schichtmodels';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_ID" is 'Zeiterfassung-ID (Primary-Key)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_IST_ENDE" is 'Mitarbeiter hat aufgehört wann';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_IST_START" is 'Mitarbeiter hat angefangen wann';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_KORR_DATUM" is 'Zeitpunkt der letzten Änderung';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_KORR_PERS_NR" is 'Personal-ID der die Änderung vorgenommen hat (Foreign-Key PZM_PERSONAL)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_KST_ID" is 'Kostenstelle-ID (PZM_KOSTENSTELLEN)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_PB_ID" is 'Produktionsbereich (Foreign-Key PZM_PRODUKTIONSBEREICHE)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_PERS_NR" is 'Personal-ID';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_SA_KURZNAME" is 'Kurzname der Schichtart (Foreign-Key PZM_SCHICHTARTEN)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_SCHICHT_TAG" is 'Auswertungstag';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_SM_NAME" is 'Schichtmodellname für diesen Zeiteintrag';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_STATUS" is 'ZE_STATUS:
0  Abwesend                 abw  Abwesenheit des Mitarbeiters -> Zusatzinfo in Abwesenheitsart
2  Anwesend                 anw  Mitarbeiter ist zur Arbeit gekommen, aber noch nicht produktiv
4  Pause                    pa   Pause    
5  Dienstgang               dg   Mitarbeiter ist im Dienst unterwegs    
6  Feiertag                 F    Bezahlter Feiertag  32768  
7  Rufbereitschaft Einsatz  RBE  Rufbereitschaft Einsatz
';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_STD" is 'Erfasste Stunden';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_TYP" is 'NULL=Aus Stempeluhr (legacy), A = Automatisch generiert (System), M = Manuell eingetragen (User), T = aus Terminal/Stempeluhr importiert, L = Live gestempelt (App), S = vom System angepasst (bspw. Auto-Close)';
comment on column DIRKSPZM32.PZM_ZEITERFASSUNG."ZE_WORK_LOCATION" is 'Arbeitsort:
1  -> Description = "Betrieb" OnSite (Default für Anwesend in der Firma)
2  -> Description = "Büro", Office
3  -> Description = "Home-Office", HomeOffice
4  -> Description = "Mobil", Remote
51 -> Description = "Reise (aktiv)", TravelActive
52 -> Description = "Reise (passiv)", TravelPassive
53 -> Description = "Unterwegs", OffSite (Default für Dienstreise)
54 -> Description = "Montage"), FieldWork
55 -> Description = "Aussendienst", FieldService';



-- sqlcl_snapshot {"hash":"9ec712440c1afc54776492f295ff7377f5886946","type":"COMMENT","name":"pzm_zeiterfassung","schemaName":"dirkspzm32","sxml":""}