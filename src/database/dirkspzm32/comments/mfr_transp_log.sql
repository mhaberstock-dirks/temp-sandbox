comment on column DIRKSPZM32.MFR_TRANSP_LOG."DURATION_SEC" is 'Duration in sconds needed for finishing the order';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."ELEMENT" is 'Name of the logging MFR element';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."FINAL_DEST" is 'Name of the final destination element where the transport unit is assumed to go';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."GUID" is 'Oracle SYS_GUID as globally unique identifier';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."IS_NIO" is '''T'' = True (is NIO), ''F'' = False (is not NIO); Indicator, if there is currently a defect at the transport unit';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."LOG_DATE" is 'Timestamp of the log entry';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."LTE_ID" is 'Transport unit identifier from WMS';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."MFR_UNIQUE_ID" is 'Uniue Identifier of the transport unit within MFR (especially for unknown transport units)';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."ORIGIN_SOURCE" is 'Name of the element where the transport unit has been created in the MFR';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."SOURCE" is 'Name of current source MFR element';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."TARGET" is 'Name of current target/destination MFR element';
comment on column DIRKSPZM32.MFR_TRANSP_LOG."TYPE" is 'BEW=Transportbewegung (später sollen auch andere Typenunterstützt werden)';



-- sqlcl_snapshot {"hash":"867e09afb080ec9277b99b7b31c112b19d7725a2","type":"COMMENT","name":"mfr_transp_log","schemaName":"dirkspzm32","sxml":""}