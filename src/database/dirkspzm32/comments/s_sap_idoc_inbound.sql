comment on table DIRKSPZM32.S_SAP_IDOC_INBOUND is 'SAP IDoc Eingangstabelle für ISI.SAP.Connector';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."BEARB_DATUM" is 'Bearbeitungsdatum und -uhrzeit, zuletzt bearbeitet am';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."DOCNUM" is 'Nummer des IDocs (16)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."ERSTELL_DATUM" is 'Erstellungsdatum und -uhrzeit, erstellt am';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."FEHLER_CODE" is 'Host-Übertragung Fehlernummer';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."FEHLER_TEXT" is 'Host-Übertragung Fehlertext';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."HLEVEL" is 'Hierarchieebene des SAP-Segmentes (2)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."IDOC_TYP" is 'IDoc Typ, z.B. BANK_CREATE01, IDOC_CONTROL_REC_40.IDOCTYP (30)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."IMPORT_DATUM" is 'Datum und Uhrzeit des Imports durch Service Logic';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."MANDT" is 'Mandant (3)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."NACHRICHT_DATUM" is 'Erstellungsdatum und Erstellungsuhrzeit des IDoc. EDI_DC40..CREDAT (8) + EDI_DC40.CRETIM (6)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."NACHRICHT_IDOC" is 'Nummer des IDocs, z.B. 51640835, EDI_DC40.DOCNUM als long (16)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."NACHRICHT_TYP" is 'Nachrichten Typ, z.B. BANK_CREATE, IDOC_CONTROL_REC_40.MESTYP (30)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."PSGNUM" is 'Nummer des übergeordneten Elternsegments (6)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."SDATA" is 'Anwendungsdaten (1000)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."SEGNAM" is 'Segment (externer Name) (30)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."SEGNUM" is 'Segmentnummer (6)';
comment on column DIRKSPZM32.S_SAP_IDOC_INBOUND."TRANSFER_STATUS" is 'Host-Übertragung Status; N=Neu, U=In Übertragung, UE=erfolgreich übertragen, F=Fehler, L=zum Löschen markiert, X=Maintenance';



-- sqlcl_snapshot {"hash":"9de0e32e4b13a8c131e279b72df8ff39289a250a","type":"COMMENT","name":"s_sap_idoc_inbound","schemaName":"dirkspzm32","sxml":""}