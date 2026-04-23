comment on table dirkspzm32.acs_user_access_log is
    'Track users or peoples access history via configured active access control points';

comment on column dirkspzm32.acs_user_access_log.access_granted is
    'T=True, access successfully granted; F=False, access denied for the user on the access point';

comment on column dirkspzm32.acs_user_access_log.access_point_device_id is
    'The related access point device to user tried to pass';

comment on column dirkspzm32.acs_user_access_log.access_point_device_info is
    'Plain text access point device info';

comment on column dirkspzm32.acs_user_access_log.access_time is
    'Timestamp of the access (try)';

comment on column dirkspzm32.acs_user_access_log.log_id is
    'Unique access history log id (GUID)';

comment on column dirkspzm32.acs_user_access_log.log_text is
    'Plain log text with available informations created by the ACS service logic';

comment on column dirkspzm32.acs_user_access_log.user_id is
    'If possible User identification key (login_id, UserId or username) of the user trying to access';

comment on column dirkspzm32.acs_user_access_log.user_identity_info is
    'Identity info (e.g. transponder code, etc.) the tried to access with';

comment on column dirkspzm32.acs_user_access_log.user_info is
    'Static plain text user information (first name, last name, username, etc.). All user info the ACS service logic can grab';


-- sqlcl_snapshot {"hash":"916b948c9f8029fdf886ba073bfc2794be5f79d5","type":"COMMENT","name":"acs_user_access_log","schemaName":"dirkspzm32","sxml":""}