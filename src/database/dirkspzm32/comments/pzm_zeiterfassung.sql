comment on table dirkspzm32.pzm_zeiterfassung is
    'Zeiterfassung (Daten immer Anmeldung und Abmeldung ein Datensatz.';

comment on column dirkspzm32.pzm_zeiterfassung.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_zeiterfassung.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_zeiterfassung.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_zeiterfassung.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_zeiterfassung.ze_aa_status is
    'Abwesenheitsart-ID (Foreign-Key PZM_ABWESENHEITSARTEN)';

comment on column dirkspzm32.pzm_zeiterfassung.ze_abt_id is
    'Abteilung-ID';

comment on column dirkspzm32.pzm_zeiterfassung.ze_bemerkung is
    'Bemerkung';

comment on column dirkspzm32.pzm_zeiterfassung.ze_calc_ist_ende is
    'Ende bis wann die verechneten Stunden gewertet werden, anhand des Schichtmodels';

comment on column dirkspzm32.pzm_zeiterfassung.ze_calc_ist_start is
    'Anfang ab wann die verechneten Stunden gewertet werden, anhand des Schichtmodels';

comment on column dirkspzm32.pzm_zeiterfassung.ze_id is
    'Zeiterfassung-ID (Primary-Key)';

comment on column dirkspzm32.pzm_zeiterfassung.ze_ist_ende is
    'Mitarbeiter hat aufgehört wann';

comment on column dirkspzm32.pzm_zeiterfassung.ze_ist_start is
    'Mitarbeiter hat angefangen wann';

comment on column dirkspzm32.pzm_zeiterfassung.ze_korr_datum is
    'Zeitpunkt der letzten Änderung';

comment on column dirkspzm32.pzm_zeiterfassung.ze_korr_pers_nr is
    'Personal-ID der die Änderung vorgenommen hat (Foreign-Key PZM_PERSONAL)';

comment on column dirkspzm32.pzm_zeiterfassung.ze_kst_id is
    'Kostenstelle-ID (PZM_KOSTENSTELLEN)';

comment on column dirkspzm32.pzm_zeiterfassung.ze_pb_id is
    'Produktionsbereich (Foreign-Key PZM_PRODUKTIONSBEREICHE)';

comment on column dirkspzm32.pzm_zeiterfassung.ze_pers_nr is
    'Personal-ID';

comment on column dirkspzm32.pzm_zeiterfassung.ze_sa_kurzname is
    'Kurzname der Schichtart (Foreign-Key PZM_SCHICHTARTEN)';

comment on column dirkspzm32.pzm_zeiterfassung.ze_schicht_tag is
    'Auswertungstag';

comment on column dirkspzm32.pzm_zeiterfassung.ze_sm_name is
    'Schichtmodellname für diesen Zeiteintrag';

comment on column dirkspzm32.pzm_zeiterfassung.ze_status is
    'ZE_STATUS:
0  Abwesend                 abw  Abwesenheit des Mitarbeiters -> Zusatzinfo in Abwesenheitsart
2  Anwesend                 anw  Mitarbeiter ist zur Arbeit gekommen, aber noch nicht produktiv
4  Pause                    pa   Pause    
5  Dienstgang               dg   Mitarbeiter ist im Dienst unterwegs    
6  Feiertag                 F    Bezahlter Feiertag  32768  
7  Rufbereitschaft Einsatz  RBE  Rufbereitschaft Einsatz
';

comment on column dirkspzm32.pzm_zeiterfassung.ze_std is
    'Erfasste Stunden';

comment on column dirkspzm32.pzm_zeiterfassung.ze_typ is
    'NULL=Aus Stempeluhr (legacy), A = Automatisch generiert (System), M = Manuell eingetragen (User), T = aus Terminal/Stempeluhr importiert, L = Live gestempelt (App), S = vom System angepasst (bspw. Auto-Close)'
    ;

comment on column dirkspzm32.pzm_zeiterfassung.ze_work_location is
    'Arbeitsort:
1  -> Description = "Betrieb" OnSite (Default für Anwesend in der Firma)
2  -> Description = "Büro", Office
3  -> Description = "Home-Office", HomeOffice
4  -> Description = "Mobil", Remote
51 -> Description = "Reise (aktiv)", TravelActive
52 -> Description = "Reise (passiv)", TravelPassive
53 -> Description = "Unterwegs", OffSite (Default für Dienstreise)
54 -> Description = "Montage"), FieldWork
55 -> Description = "Aussendienst", FieldService';


-- sqlcl_snapshot {"hash":"018768c3f518cc6475d3102d7805129ce5de1e24","type":"COMMENT","name":"pzm_zeiterfassung","schemaName":"dirkspzm32","sxml":""}