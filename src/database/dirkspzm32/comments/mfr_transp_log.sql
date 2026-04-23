comment on column dirkspzm32.mfr_transp_log.duration_sec is
    'Duration in sconds needed for finishing the order';

comment on column dirkspzm32.mfr_transp_log.element is
    'Name of the logging MFR element';

comment on column dirkspzm32.mfr_transp_log.final_dest is
    'Name of the final destination element where the transport unit is assumed to go';

comment on column dirkspzm32.mfr_transp_log.guid is
    'Oracle SYS_GUID as globally unique identifier';

comment on column dirkspzm32.mfr_transp_log.is_nio is
    '''T'' = True (is NIO), ''F'' = False (is not NIO); Indicator, if there is currently a defect at the transport unit';

comment on column dirkspzm32.mfr_transp_log.log_date is
    'Timestamp of the log entry';

comment on column dirkspzm32.mfr_transp_log.lte_id is
    'Transport unit identifier from WMS';

comment on column dirkspzm32.mfr_transp_log.mfr_unique_id is
    'Uniue Identifier of the transport unit within MFR (especially for unknown transport units)';

comment on column dirkspzm32.mfr_transp_log.origin_source is
    'Name of the element where the transport unit has been created in the MFR';

comment on column dirkspzm32.mfr_transp_log.source is
    'Name of current source MFR element';

comment on column dirkspzm32.mfr_transp_log.target is
    'Name of current target/destination MFR element';

comment on column dirkspzm32.mfr_transp_log.type is
    'BEW=Transportbewegung (später sollen auch andere Typenunterstützt werden)';


-- sqlcl_snapshot {"hash":"3140ec80a6b7baf87b8f7da4703fec8e1d40e6bd","type":"COMMENT","name":"mfr_transp_log","schemaName":"dirkspzm32","sxml":""}