comment on table DIRKSPZM32.ACS_USER_PERMISSIONS is 'Users and the related access point devices where they have permission to access';
comment on column DIRKSPZM32.ACS_USER_PERMISSIONS."ACCESS_POINT_DEVICE_ID" is 'The related access point device to user is granted to pass (GUID)';
comment on column DIRKSPZM32.ACS_USER_PERMISSIONS."EXPIRES_AT" is 'Expiration date of the grant (of defined, the access is automatically not granted after the date)';
comment on column DIRKSPZM32.ACS_USER_PERMISSIONS."SECURITY_LEVEL" is 'Number Value between 0 and 3, representing the knowlegde of this role of this access point';
comment on column DIRKSPZM32.ACS_USER_PERMISSIONS."USER_ID" is 'Unique identifier of the user (from ISI_USER table or any other security system)';



-- sqlcl_snapshot {"hash":"d7d90886cd76f03ee1d9821b247f3bbe4026ee95","type":"COMMENT","name":"acs_user_permissions","schemaName":"dirkspzm32","sxml":""}