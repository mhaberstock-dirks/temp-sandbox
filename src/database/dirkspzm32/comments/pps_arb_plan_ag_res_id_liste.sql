comment on table DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE is 'PPS Liste der Resourcen, die diesen Arbeitsgang fertigen können.';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."AG_ALTERNATIVE" is 'Vorgang Alternative Leer = Standard';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."AG_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."ARB_PLAN_ID" is 'Arbeitsplan, dem dieser AG zugeordnet werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."ARB_PLAN_POS_ID" is 'Eindeutige ID der Position für die Verbindung zur STL';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."FIRMA_NR" is 'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."MASCHINENZEITFAKTOR" is 'Faktor auf Arbeitsplatzzeit der Position bei Wahl dieses Arbeitsplatzes';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."NIO_RES_ID" is 'Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."RES_ID" is 'Resource(ngruppe), die für die Produktion eingesetzt werden soll';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."SID" is 'Datenbank dieser Firma';
comment on column DIRKSPZM32.PPS_ARB_PLAN_AG_RES_ID_LISTE."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';



-- sqlcl_snapshot {"hash":"fda8e61c3312ae6aca5ee9766de8a94ece911a62","type":"COMMENT","name":"pps_arb_plan_ag_res_id_liste","schemaName":"dirkspzm32","sxml":""}