comment on table DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST is 'PPS Liste der Resourcen, die diesen Arbeitsgang fertigen können.';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."AG_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."AG_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."ANZ_BEDIENER" is 'Anzahl der für diese Vorgangsposition benötigten Bediener';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."ARB_PLAN_ID" is 'Arbeitsplan, dem dieser AG zugeordnet werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."ARB_PLAN_POS_ID" is 'Eindeutige ID der Position für die Verbindung zur STL';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."FIRMA_NR" is 'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."GROUP_ID" is 'eindeutige, frei wählbare ID des benötigten Personalbedarfs (Personalbedarfsgruppe), z.B. ''1'', ''Packer'' oder ''Schweißer''. Die Gruppennummer darf
nicht leer sein!
Diese wird benötigt, um unterschiedlichen Personalbedarf unterscheiden zu können (nicht mit ID der Personalgruppe verwechseln!)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."MAX_BEDIENER" is 'maximale Anzahl gleichzeitiger Bediener';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."PERSONALWECHSELTYP" is 'Einstellungen zum Personalwechsel
Personalwechseltyp
Wert Bezeichnung Beschreibung
0 ständiger Wechsel
erlaubt
Mehrschichtbearbeitung ist zugelassen, d.h. dass ein Mitarbeiter aus z.B. einer anderen Schicht die
angemeldete Tätigkeit auf diesem Arbeitsplatz weiterbearbeiten darf
1 kein Wechsel in Vorgangsposition erlaubt Personalwechsel innerhalb von Vorgangspositionen ist nicht erlaubt (keine Mehrschichtbearbeitung), d.h. der/die gleicheMitarbeiter bearbeiten komplett eine Vorgangsposition
2 kein Wechsel in Vorgang erlaubt Personalwechsel innerhalb eines kompletten Vorgangs ist nicht erlaubt, d.h. exakt der/die gleicheMitarbeiter werden für den kompletten Vorgang verwendet (entspricht Bedienzwang)
Achtung: Wird dieser Typ gewählt, dann muss activity_type = 0 (alle) sein';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."PROZ_BEDIENER" is 'prozentuale Auslastung der Bediener';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."RES_ID" is 'Arbeitsplätze und/oder Arbeitsplatzgruppen, für die der Personalbedarf gilt
leer = alle Arbeitsplätze';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."SID" is 'Datenbank dieser Firma';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."VORGANGSQUALIFIKATION" is 'optionale Vorgangsqualifikation (Sonder- oder auch Tätigkeitsqualifikation), die das Personal zur Bedienung des Vorgangs benötigt';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_PERS_Q_LIST."VORGANGSTYP" is 'Für welchen Vorgangspositionstyp gilt der angegeben Personalbedarf
0 = alle (Personalbedarf gilt automatisch für alle Positionen eines Vorgangs)
1 = fertigen
2 = rüsten';



-- sqlcl_snapshot {"hash":"0f489c8c0700bae38085d53013a33ca600989416","type":"COMMENT","name":"pps_arb_plan_ag_pers_q_list","schemaName":"dirkspzm32","sxml":""}