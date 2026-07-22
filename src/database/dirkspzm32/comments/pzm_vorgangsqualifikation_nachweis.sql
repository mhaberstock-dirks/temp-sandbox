comment on table DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS is 'Vorgangs Qualifikation Prüfungsunterlagen oder Nachweis';
comment on column DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS."PERS_NR" is 'eindeutige Personalnummer (Primary-Key)';
comment on column DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS."QUALIFIKATION_ABLAUF_DATUM" is 'NULL ist ohne Ablaufdatum. - Diese Qualifikation ist gültig bis und endet oder muss erneut nachgewiesen werden zu diesem Datum';
comment on column DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS."QUALIFIKATION_AUSTELLER" is 'Wer hat diesen Qualifikationsnachweis ausgestellt';
comment on column DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS."QUALIFIKATION_CHECK_PERS_NR" is '	Wer hat diesen Qualifikationsnachweis kontrolliert (Personalnummer)';
comment on column DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS."QUALIFIKATION_DATEI_ABLAGE" is 'Gibt es eine Datei (Bild, PDF oder ähnliches) des nachweis';
comment on column DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS."QUALIFIKATION_ID" is 'Vorgangsqualifikation ist für diese Abeilung (Primary-Key)';
comment on column DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS."QUALIFIKATION_INTERN" is 'Vorgangsqualifikation wir automatisch zugewiesen, bei Zuweisung';
comment on column DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS."QUALIFIKATION_PRUEFUNG_DATUM" is 'Datum des Erwerbs die Qualifikation';
comment on column DIRKSPZM32.PZM_VORGANGSQUALIFIKATION_NACHWEIS."VORGANGSQUALIFIKATION" is 'Vorgangsqualifikation des Personals (Primary-Key)';



-- sqlcl_snapshot {"hash":"a3d16e22af58ebcf240ef57d68c4aa3ead99aa40","type":"COMMENT","name":"pzm_vorgangsqualifikation_nachweis","schemaName":"dirkspzm32","sxml":""}