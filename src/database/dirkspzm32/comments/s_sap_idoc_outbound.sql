comment on table dirkspzm32.s_sap_idoc_outbound is
    'SAP IDoc Ausgangstabelle für ISI.SAP.Connector';

comment on column dirkspzm32.s_sap_idoc_outbound.bearb_datum is
    'Bearbeitungsdatum und -uhrzeit, zuletzt bearbeitet am';

comment on column dirkspzm32.s_sap_idoc_outbound.docnum is
    'Nummer des IDocs (16)';

comment on column dirkspzm32.s_sap_idoc_outbound.erstell_datum is
    'Erstellungsdatum und -uhrzeit, erstellt am';

comment on column dirkspzm32.s_sap_idoc_outbound.export_datum is
    'Datum und Uhrzeit des Exports durch Service Logic';

comment on column dirkspzm32.s_sap_idoc_outbound.fehler_code is
    'Host-Übertragung Fehlernummer';

comment on column dirkspzm32.s_sap_idoc_outbound.fehler_text is
    'Host-Übertragung Fehlertext';

comment on column dirkspzm32.s_sap_idoc_outbound.hlevel is
    'Hierarchieebene des SAP-Segmentes (2)';

comment on column dirkspzm32.s_sap_idoc_outbound.idoc_typ is
    'IDoc Typ, z.B. BANK_CREATE01, IDOC_CONTROL_REC_40.IDOCTYP (30)';

comment on column dirkspzm32.s_sap_idoc_outbound.mandt is
    'Mandant (3)';

comment on column dirkspzm32.s_sap_idoc_outbound.nachricht_datum is
    'Erstellungsdatum und Erstellungsuhrzeit des IDoc. EDI_DC40..CREDAT (8) + EDI_DC40.CRETIM (6)';

comment on column dirkspzm32.s_sap_idoc_outbound.nachricht_idoc is
    'Nummer des IDocs, z.B. 51640835, EDI_DC40.DOCNUM als long (16)';

comment on column dirkspzm32.s_sap_idoc_outbound.nachricht_typ is
    'Nachrichten Typ, z.B. BANK_CREATE, IDOC_CONTROL_REC_40.MESTYP (30)';

comment on column dirkspzm32.s_sap_idoc_outbound.psgnum is
    'Nummer des übergeordneten Elternsegments (6)';

comment on column dirkspzm32.s_sap_idoc_outbound.sdata is
    'Anwendungsdaten (1000)';

comment on column dirkspzm32.s_sap_idoc_outbound.segnam is
    'Segment (externer Name) (30)';

comment on column dirkspzm32.s_sap_idoc_outbound.segnum is
    'Segmentnummer (6)';

comment on column dirkspzm32.s_sap_idoc_outbound.transfer_status is
    'Host-Übertragung Status; N=Neu, U=In Übertragung, UE=erfolgreich übertragen, F=Fehler, L=zum Löschen markiert, X=Maintenance';


-- sqlcl_snapshot {"hash":"18ddacbf42e7a1c2bb265ca714b7c39e78cfa591","type":"COMMENT","name":"s_sap_idoc_outbound","schemaName":"dirkspzm32","sxml":""}