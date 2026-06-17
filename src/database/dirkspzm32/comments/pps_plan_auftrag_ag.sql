comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."AG_NAME1" is 'FA_AG Bezeichnung1 (Klartext)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."AG_NAME2" is 'FA_AG Bezeichnung2 (Klartext)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."AG_TEXT1" is 'Zusatztext1 für die Beschreibung des FA_AG';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."AG_TEXT2" is 'Zusatztext2 für die Beschreibung des FA_AG';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."AG_TEXT3" is 'Zusatztext3 für die Beschreibung des FA_AG';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."AG_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."FIRMA_NR" is 'Firma Nr.';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."NIO_RES_ID" is 'Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."PLAN_AUF_AG_ID" is 'Eindeutige Nummer aus SEQ';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."PLAN_AUF_ID" is 'Auftragsnummer aus PPS_PLAN_AUFTRAG';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."PROD_PARAMS" is 'Produktionsparameter (Aus Bedienereingabe oder pps_arb_plan/Stueckliste)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."QUITT_GRUPPE_AG" is 'Quittierungs-Gruppe der quittierenden Pos_Nr, sonst eigene Pos_Nr.';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."RES_ID" is 'Resource(ngruppe), die für die Produktion eingesetzt werden soll';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."SATZART" is '"V" Verrichten, "VA" = Verrichten Auswäts, "VR" = Verrichten Rüsten';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."SID" is 'SID';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."SOLL_MENGE" is 'Sollmenge für AG';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."SOLL_ZEIT_PROD" is 'Geplante netto Produktionszeit  in Minuten';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."SOLL_ZEIT_P_EINH" is 'Sollzeit pro gefertigte Einheit / Zyklus in Minuten';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."SOLL_ZEIT_RUEST" is 'Geplante netto Rüstzeit  in Minuten';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."SOLL_ZEIT_STOER" is 'Geplante, Berücksichtigte Stillstandszeit  in Minuten';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."TERMIN_ENDE_GEPL" is 'Geplantes Produktionsende';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."TERMIN_START_GEPL" is 'Geplanter Produktionsbeginn';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG."VORGANGSQUALIFIKATION" is 'Qualifikation, die das Personal zur Bedienung des Vorgangs benötigt';



-- sqlcl_snapshot {"hash":"758b35434d37687fd098ae95cc80ead9c9e9a444","type":"COMMENT","name":"pps_plan_auftrag_ag","schemaName":"dirkspzm32","sxml":""}