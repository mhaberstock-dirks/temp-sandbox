comment on table DIRKSPZM32.REP_SECURITY_CFG is 'this table is used to manage security for reports';
comment on column DIRKSPZM32.REP_SECURITY_CFG."CAN_DELETE_DATA" is 'T = this group can delete a record of the report data, F = delete not allowed';
comment on column DIRKSPZM32.REP_SECURITY_CFG."CAN_EDIT_DATA" is 'T = this group can edit the report data, F = edit not allowed';
comment on column DIRKSPZM32.REP_SECURITY_CFG."CAN_INSERT_DATA" is 'T = this group can insert a new record into the report data, F = insert not allowed';
comment on column DIRKSPZM32.REP_SECURITY_CFG."LOGIN_ID" is 'the referencing user login id which is allowed to execute this report';
comment on column DIRKSPZM32.REP_SECURITY_CFG."REP_ID" is 'the report id where this security schuld be applied';
comment on column DIRKSPZM32.REP_SECURITY_CFG."REP_SECURITY_CFG_ID" is 'unique id of this security config';
comment on column DIRKSPZM32.REP_SECURITY_CFG."SECURITY_TYPE" is '''G'' = security by group, ''U'' = security by user';
comment on column DIRKSPZM32.REP_SECURITY_CFG."SEC_GROUP_ID" is 'the referencing group id which is allowed to execute this report';



-- sqlcl_snapshot {"hash":"8f046107e577bae36d39e14f190bd770ce360ae6","type":"COMMENT","name":"rep_security_cfg","schemaName":"dirkspzm32","sxml":""}