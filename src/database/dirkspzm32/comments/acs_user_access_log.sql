comment on table DIRKSPZM32.ACS_USER_ACCESS_LOG is 'Track users or peoples access history via configured active access control points';
comment on column DIRKSPZM32.ACS_USER_ACCESS_LOG."ACCESS_GRANTED" is 'T=True, access successfully granted; F=False, access denied for the user on the access point';
comment on column DIRKSPZM32.ACS_USER_ACCESS_LOG."ACCESS_POINT_DEVICE_ID" is 'The related access point device to user tried to pass';
comment on column DIRKSPZM32.ACS_USER_ACCESS_LOG."ACCESS_POINT_DEVICE_INFO" is 'Plain text access point device info';
comment on column DIRKSPZM32.ACS_USER_ACCESS_LOG."ACCESS_TIME" is 'Timestamp of the access (try)';
comment on column DIRKSPZM32.ACS_USER_ACCESS_LOG."LOG_ID" is 'Unique access history log id (GUID)';
comment on column DIRKSPZM32.ACS_USER_ACCESS_LOG."LOG_TEXT" is 'Plain log text with available informations created by the ACS service logic';
comment on column DIRKSPZM32.ACS_USER_ACCESS_LOG."USER_ID" is 'If possible User identification key (login_id, UserId or username) of the user trying to access';
comment on column DIRKSPZM32.ACS_USER_ACCESS_LOG."USER_IDENTITY_INFO" is 'Identity info (e.g. transponder code, etc.) the tried to access with';
comment on column DIRKSPZM32.ACS_USER_ACCESS_LOG."USER_INFO" is 'Static plain text user information (first name, last name, username, etc.). All user info the ACS service logic can grab';



-- sqlcl_snapshot {"hash":"8b598dba5e316c43e8cb8914b31b690fd87389d0","type":"COMMENT","name":"acs_user_access_log","schemaName":"dirkspzm32","sxml":""}