comment on table MFR_TRANSP_LOG_NIO is 'List of NIO states associated to a transport log entry';
comment on column MFR_TRANSP_LOG_NIO."MFR_TRANSP_LOG_ID" is 'GUI of the MFR transport log dataset';
comment on column MFR_TRANSP_LOG_NIO."MT_GRUPPE" is 'Textgroup ID to identify the related text of the nio';
comment on column MFR_TRANSP_LOG_NIO."NIO_MT_INDEX" is 'BIT position index of the NIO identifier based on WORD (array) datatypes as decimal value. "1.01" means WORD 1 bit 1 and "1.16" means WORD 1 bit 16';



-- sqlcl_snapshot {"hash":"c70971c2929315652502178d18a9ec3c207b8d16","type":"COMMENT","name":"mfr_transp_log_nio","schemaName":"dirkspzm32","sxml":""}