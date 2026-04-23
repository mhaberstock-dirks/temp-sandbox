comment on table dirkspzm32.mfr_transp_log_nio is
    'List of NIO states associated to a transport log entry';

comment on column dirkspzm32.mfr_transp_log_nio.mfr_transp_log_id is
    'GUI of the MFR transport log dataset';

comment on column dirkspzm32.mfr_transp_log_nio.mt_gruppe is
    'Textgroup ID to identify the related text of the nio';

comment on column dirkspzm32.mfr_transp_log_nio.nio_mt_index is
    'BIT position index of the NIO identifier based on WORD (array) datatypes as decimal value. "1.01" means WORD 1 bit 1 and "1.16" means WORD 1 bit 16'
    ;


-- sqlcl_snapshot {"hash":"b74788efba81236ea76e3fe3e3a0e8e39b569a41","type":"COMMENT","name":"mfr_transp_log_nio","schemaName":"dirkspzm32","sxml":""}