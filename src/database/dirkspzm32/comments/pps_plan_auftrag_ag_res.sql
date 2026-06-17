comment on table DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES is 'Resourcenliste für diesen AG im Planauftrag';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."AG_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."FIRMA_NR" is 'Firma Nr.';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."NIO_RES_ID" is 'Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."PLAN_AUF_AG_ID" is 'Eindeutige Nummer aus SEQ';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."PLAN_AUF_ID" is 'Auftragsnummer aus PPS_PLAN_AUFTRAG';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."POS_NR" is 'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."RES_DELTA" is 'Angabe, um wie viel Prozent besser eine Alternativ-Ressource als die Standard-Ressource sein muss, damit sie ohne bestehenden Maschinenengpass genutzt wird 0%, d.h. alle Maschinen sind gleichwertig';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."RES_ID" is 'Resource(ngruppe), die für die Produktion eingesetzt werden soll';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."SID" is 'SID';
comment on column DIRKSPZM32.PPS_PLAN_AUFTRAG_AG_RES."VORGANG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';



-- sqlcl_snapshot {"hash":"b891acd2f63cc6854b6a2c5e53012b22d0d139f4","type":"COMMENT","name":"pps_plan_auftrag_ag_res","schemaName":"dirkspzm32","sxml":""}