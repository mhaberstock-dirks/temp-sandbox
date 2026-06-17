comment on table DIRKSPZM32.S_SAP_IDOC_OUTBOUND is 'SAP IDoc Ausgangstabelle für ISI.SAP.Connector';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."BEARB_DATUM" is 'Bearbeitungsdatum und -uhrzeit, zuletzt bearbeitet am';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."DOCNUM" is 'Nummer des IDocs (16)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."ERSTELL_DATUM" is 'Erstellungsdatum und -uhrzeit, erstellt am';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."EXPORT_DATUM" is 'Datum und Uhrzeit des Exports durch Service Logic';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."FEHLER_CODE" is 'Host-Übertragung Fehlernummer';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."FEHLER_TEXT" is 'Host-Übertragung Fehlertext';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."HLEVEL" is 'Hierarchieebene des SAP-Segmentes (2)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."IDOC_TYP" is 'IDoc Typ, z.B. BANK_CREATE01, IDOC_CONTROL_REC_40.IDOCTYP (30)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."MANDT" is 'Mandant (3)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."NACHRICHT_DATUM" is 'Erstellungsdatum und Erstellungsuhrzeit des IDoc. EDI_DC40..CREDAT (8) + EDI_DC40.CRETIM (6)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."NACHRICHT_IDOC" is 'Nummer des IDocs, z.B. 51640835, EDI_DC40.DOCNUM als long (16)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."NACHRICHT_TYP" is 'Nachrichten Typ, z.B. BANK_CREATE, IDOC_CONTROL_REC_40.MESTYP (30)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."PSGNUM" is 'Nummer des übergeordneten Elternsegments (6)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."SDATA" is 'Anwendungsdaten (1000)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."SEGNAM" is 'Segment (externer Name) (30)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."SEGNUM" is 'Segmentnummer (6)';
comment on column DIRKSPZM32.S_SAP_IDOC_OUTBOUND."TRANSFER_STATUS" is 'Host-Übertragung Status; N=Neu, U=In Übertragung, UE=erfolgreich übertragen, F=Fehler, L=zum Löschen markiert, X=Maintenance';



-- sqlcl_snapshot {"hash":"1cb077af5a6fd4a91b24b8bfa230141f7ae7aae8","type":"COMMENT","name":"s_sap_idoc_outbound","schemaName":"dirkspzm32","sxml":""}