comment on table DIRKSPZM32.LVS_SERIE_ID_POS is 'Tabelle mit allen IDs die für einen Fertigungsauftrag generiert worden sind';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."LAM_ID" is 'LAM-ID mit der diese SDeriennummer verküpft ist. Wenn NULL dann frei';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."SERIE_ID" is 'ID des zu der Serie gehörenden Headers (BDE_SERIAL_ID_HDR)';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."SERIE_ID_LFDN" is 'LFDN der SERIE-ID';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."SERIE_NR" is 'Seriennummer aus Kopf fertig aufgelöst (Gleich wie bei der Charge die Chargenbezeichnung - Eigentliche Seriennummer auf dem Produkt)';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."SERIE_NR_EXTERN" is 'Externe Seriennummer aus Kopf fertig aufgelöst - Z.B. Owner-ID ';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."SERIE_POS_LFDN" is 'Laufende Nummer der IDs in Vergabereihenfolge einer Serie (Bsp. bei einer Menge von 1000 => 1 bis 1000 )';
comment on column DIRKSPZM32.LVS_SERIE_ID_POS."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"ce2977abafbedfa3fb98a8a8a298256eee465f99","type":"COMMENT","name":"lvs_serie_id_pos","schemaName":"dirkspzm32","sxml":""}