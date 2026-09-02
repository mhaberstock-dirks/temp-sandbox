comment on column PZM_ABWESENHEITS_ANTR."AU_ABWES_ART" is 'Abwesenheitsart-ID (Foreign-Key PZM_ABWESENHEITSARTEN)';
comment on column PZM_ABWESENHEITS_ANTR."AU_ARBEITSTAGE" is 'Anzahl Arbeitstage';
comment on column PZM_ABWESENHEITS_ANTR."AU_BEGINN" is 'Urlaubsbeginn (Primary-Key)';
comment on column PZM_ABWESENHEITS_ANTR."AU_BEMERKUNG" is 'Bemerkung zum Urlaubsantrag';
comment on column PZM_ABWESENHEITS_ANTR."AU_DATUM" is 'Antragsdatum (Primary-Key)';
comment on column PZM_ABWESENHEITS_ANTR."AU_EMAIL" is 'Email Benachrichtigung';
comment on column PZM_ABWESENHEITS_ANTR."AU_ENDE" is 'Urlaubsende';
comment on column PZM_ABWESENHEITS_ANTR."AU_PERS_NR" is 'Personal-ID des Antragstellers (Primary-Key & Foreign-Key PZM_PERSONAL)';
comment on column PZM_ABWESENHEITS_ANTR."AU_PRUEF_PERS_NR" is 'PersNr des prüfenden Personals (Foreign-Key PZM_PERSONAL)';
comment on column PZM_ABWESENHEITS_ANTR."AU_SCHICHT_START" is 'Urlaubsbeginn zur Schicht bzw. Arbeitszeit an einem Tag. NULL = ganzer Tag, 1 = Schichtanfang, 2 = Schichtende';
comment on column PZM_ABWESENHEITS_ANTR."AU_STATUS" is '0 = beantragt, 1 = genehmigt, 2 = abgelehnt, 3 = storniert (Foreign-Key PZM_PRUEF_STATUS_INFO.PSI_ID)';
comment on column PZM_ABWESENHEITS_ANTR."AU_UTAGE" is 'Anzahl Urlaubstage';
comment on column PZM_ABWESENHEITS_ANTR."CREATED_DATE" is 'Datum Erstellt';
comment on column PZM_ABWESENHEITS_ANTR."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column PZM_ABWESENHEITS_ANTR."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column PZM_ABWESENHEITS_ANTR."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';



-- sqlcl_snapshot {"hash":"0ea23a177db1d6e8ec78ccc09be299567216688d","type":"COMMENT","name":"pzm_abwesenheits_antr","schemaName":"dirkspzm32","sxml":""}