comment on table dirkspzm32.s_sap_idoc_inbound is
    'SAP IDoc Eingangstabelle für ISI.SAP.Connector';

comment on column dirkspzm32.s_sap_idoc_inbound.bearb_datum is
    'Bearbeitungsdatum und -uhrzeit, zuletzt bearbeitet am';

comment on column dirkspzm32.s_sap_idoc_inbound.docnum is
    'Nummer des IDocs (16)';

comment on column dirkspzm32.s_sap_idoc_inbound.erstell_datum is
    'Erstellungsdatum und -uhrzeit, erstellt am';

comment on column dirkspzm32.s_sap_idoc_inbound.fehler_code is
    'Host-Übertragung Fehlernummer';

comment on column dirkspzm32.s_sap_idoc_inbound.fehler_text is
    'Host-Übertragung Fehlertext';

comment on column dirkspzm32.s_sap_idoc_inbound.hlevel is
    'Hierarchieebene des SAP-Segmentes (2)';

comment on column dirkspzm32.s_sap_idoc_inbound.idoc_typ is
    'IDoc Typ, z.B. BANK_CREATE01, IDOC_CONTROL_REC_40.IDOCTYP (30)';

comment on column dirkspzm32.s_sap_idoc_inbound.import_datum is
    'Datum und Uhrzeit des Imports durch Service Logic';

comment on column dirkspzm32.s_sap_idoc_inbound.mandt is
    'Mandant (3)';

comment on column dirkspzm32.s_sap_idoc_inbound.nachricht_datum is
    'Erstellungsdatum und Erstellungsuhrzeit des IDoc. EDI_DC40..CREDAT (8) + EDI_DC40.CRETIM (6)';

comment on column dirkspzm32.s_sap_idoc_inbound.nachricht_idoc is
    'Nummer des IDocs, z.B. 51640835, EDI_DC40.DOCNUM als long (16)';

comment on column dirkspzm32.s_sap_idoc_inbound.nachricht_typ is
    'Nachrichten Typ, z.B. BANK_CREATE, IDOC_CONTROL_REC_40.MESTYP (30)';

comment on column dirkspzm32.s_sap_idoc_inbound.psgnum is
    'Nummer des übergeordneten Elternsegments (6)';

comment on column dirkspzm32.s_sap_idoc_inbound.sdata is
    'Anwendungsdaten (1000)';

comment on column dirkspzm32.s_sap_idoc_inbound.segnam is
    'Segment (externer Name) (30)';

comment on column dirkspzm32.s_sap_idoc_inbound.segnum is
    'Segmentnummer (6)';

comment on column dirkspzm32.s_sap_idoc_inbound.transfer_status is
    'Host-Übertragung Status; N=Neu, U=In Übertragung, UE=erfolgreich übertragen, F=Fehler, L=zum Löschen markiert, X=Maintenance';


-- sqlcl_snapshot {"hash":"22b977f03e52eeeef3dd5eed8e884389bde31a18","type":"COMMENT","name":"s_sap_idoc_inbound","schemaName":"dirkspzm32","sxml":""}