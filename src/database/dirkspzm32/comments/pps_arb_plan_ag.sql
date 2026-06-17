comment on table DIRKSPZM32.PPS_ARB_PLAN_AG is 'Arbeitsgang im Arbeitsplan';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."AG_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."AG_NAME1" is 'FA_AG Bezeichnung (Klartext)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."AG_NAME2" is 'FA_AG Bezeichnung Name 2';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."AG_TEXT1" is 'Zusatztext für die Beschreibung des FA_AG';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."AG_TEXT2" is 'Zusatztext - 2';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."AG_TEXT3" is 'Zusatztext - 3';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."AG_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."ARB_PLAN_ID" is 'Arbeitsplan, dem dieser AG zugeordnet werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."ARB_PLAN_POS_ID" is 'Eindeutige ID der Position für die Verbindung zur STL';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."NIO_RES_ID" is 'Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."PLAN_MENGE_FAKTOR" is 'Faktor Bedarfsmenge zur AG Planmenge';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."PLAN_MENGE_FAKTOR_OP" is '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."PROD_PARAMS" is 'Produktionsparameter zum Steuern von Prozessen oder Maschinenparametern oder Werkzeugen etc.';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."QUITT_GRUPPE_AG" is 'Quittierungs-Gruppe der quittierenden Pos_Nr, sonst eigene Pos_Nr.';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."RES_ID" is 'Resource(ngruppe), die für die Produktion eingesetzt werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."SATZART" is '"V" Verrichten, "VA" = Verrichten Auswäts, "VR" = Verrichten Rüsten';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."SOLL_ZEIT_LIEGEN" is 'Geplante netto Liegezeit (Dauer in Min). Vormaterial muss soviel Zeit Reifen (Liegen), bis es weiterverarbeitet werden kann';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."SOLL_ZEIT_P_EINH" is 'Sollzeit pro gefertigte Einheit / Zyklus in Minuten';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."SOLL_ZEIT_RUEST" is 'Geplante netto Rüstzeit (Dauer in Min)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."SOLL_ZEIT_STOER_P_STD" is 'Geplante, Berücksichtigte Stillstandszeit pro Stunde';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG."VORGANGSQUALIFIKATION" is 'Qualifikation, die das Personal zur Bedienung des Vorgangs benötigt';



-- sqlcl_snapshot {"hash":"06c50fcd6f895021644217edbcd625add939789c","type":"COMMENT","name":"pps_arb_plan_ag","schemaName":"dirkspzm32","sxml":""}