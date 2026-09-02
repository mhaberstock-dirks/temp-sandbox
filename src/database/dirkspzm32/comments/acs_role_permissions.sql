comment on table ACS_ROLE_PERMISSIONS is 'Access Control System (assigned Roles to Access Points)';
comment on column ACS_ROLE_PERMISSIONS."ACCESS_POINT_DEVICE_ID" is 'Unique Identifier of Access Point Device (GUID)';
comment on column ACS_ROLE_PERMISSIONS."ROLE_ID" is 'Unique Identifier of Role (GUID)';
comment on column ACS_ROLE_PERMISSIONS."SECURITY_LEVEL" is 'Number Value between 0 and 3, representing the knowlegde of this role of this access point';



-- sqlcl_snapshot {"hash":"874b1b71d79594ae033c9ea366c204933b203f46","type":"COMMENT","name":"acs_role_permissions","schemaName":"dirkspzm32","sxml":""}