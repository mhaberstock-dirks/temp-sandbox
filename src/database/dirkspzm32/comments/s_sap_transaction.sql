comment on table dirkspzm32.s_sap_transaction is
    'Storage for Transaction ID Handler of ISI.SAP.Connector (R4)';

comment on column dirkspzm32.s_sap_transaction.created is
    'Creation Timestamp';

comment on column dirkspzm32.s_sap_transaction.dest_sys is
    'Logical Name of SAP Destination System';

comment on column dirkspzm32.s_sap_transaction.direction is
    'Direction Inbound (SAP->ISI) or Outbound (ISI->SAP)';

comment on column dirkspzm32.s_sap_transaction.error_message is
    'Error Message when error occured';

comment on column dirkspzm32.s_sap_transaction.idoc_type is
    'Type name of IDoc';

comment on column dirkspzm32.s_sap_transaction.message_type is
    'SAP Message Type';

comment on column dirkspzm32.s_sap_transaction.modified is
    'Last modified Timestamp';

comment on column dirkspzm32.s_sap_transaction.source_sys is
    'Logical Name of SAP Source System';

comment on column dirkspzm32.s_sap_transaction.tid is
    'Transaction ID';

comment on column dirkspzm32.s_sap_transaction.tid_status is
    'Created, Executed, Committed, RolledBack, Confirmed';


-- sqlcl_snapshot {"hash":"22843e844f12285f83d63e49df19ed2a1aa078e8","type":"COMMENT","name":"s_sap_transaction","schemaName":"dirkspzm32","sxml":""}