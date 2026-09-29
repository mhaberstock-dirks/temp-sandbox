comment on table PZM_VORGANGSQUAL_W_PLAN_VALIDE is 'Plan für den Personaleinsatz als Vorgabe für eine Woche';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."CREATED_DATE" is 'Datum Erstellt';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_BIS_ZEIT" is 'In der Zeit bis (Primary-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_DATUM" is 'Datum für den Einsatz (Primary-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_EINSATZ_NR" is 'Reihenfolge (Für jeden Bedarf können 1 - n Personalnummern geplant werden) (Primary-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_ID" is 'Eindeutiger Key des führenden  (U-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_PERS_NR" is 'Geplant für Personalnummer (Primary-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_SCHICHT" is 'Sichtnummer für den Einsatz (Primary-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_START" is 'Erster Tag der Woche des Wochenplan (Primary-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_VALID_ID" is 'Eindeutiger Key für diesen Datensatz';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_V_CHECK_NR" is 'Nummer (Rangfolge des Datensatz) (Primary-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_V_EINTRAG_VALIDE" is 'KEY von OK (100) alles richtig bis Fehler(0). Ist wie eine Prozentzahl, wie valide der Eintrag ist';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_VON_ZEIT" is 'In der Zeit von (Primary-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_VQ_ID" is 'Vorgangsqualifikation (Primary-Key)';
comment on column PZM_VORGANGSQUAL_W_PLAN_VALIDE."W_PLAN_V_VALALID_BESCHREIBUNG" is 'Langtext zur Validität dees Eintrags, ggf mit LC_KEY o.ä. ';



-- sqlcl_snapshot {"hash":"daf388195f455af1245e7356879a569c50cac7a9","type":"COMMENT","name":"pzm_vorgangsqual_w_plan_valide","schemaName":"dirkspzm32","sxml":""}