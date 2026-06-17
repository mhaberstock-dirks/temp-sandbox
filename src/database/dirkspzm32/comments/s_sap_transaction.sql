comment on table DIRKSPZM32.S_SAP_TRANSACTION is 'Storage for Transaction ID Handler of ISI.SAP.Connector (R4)';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."CREATED" is 'Creation Timestamp';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."DEST_SYS" is 'Logical Name of SAP Destination System';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."DIRECTION" is 'Direction Inbound (SAP->ISI) or Outbound (ISI->SAP)';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."ERROR_MESSAGE" is 'Error Message when error occured';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."IDOC_TYPE" is 'Type name of IDoc';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."MESSAGE_TYPE" is 'SAP Message Type';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."MODIFIED" is 'Last modified Timestamp';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."SOURCE_SYS" is 'Logical Name of SAP Source System';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."TID" is 'Transaction ID';
comment on column DIRKSPZM32.S_SAP_TRANSACTION."TID_STATUS" is 'Created, Executed, Committed, RolledBack, Confirmed';



-- sqlcl_snapshot {"hash":"ed2dbb9a203a4007c921fb79987accb082f2261c","type":"COMMENT","name":"s_sap_transaction","schemaName":"dirkspzm32","sxml":""}