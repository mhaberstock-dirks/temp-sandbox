comment on table dirkspzm32.acs_role_permissions is
    'Access Control System (assigned Roles to Access Points)';

comment on column dirkspzm32.acs_role_permissions.access_point_device_id is
    'Unique Identifier of Access Point Device (GUID)';

comment on column dirkspzm32.acs_role_permissions.role_id is
    'Unique Identifier of Role (GUID)';

comment on column dirkspzm32.acs_role_permissions.security_level is
    'Number Value between 0 and 3, representing the knowlegde of this role of this access point';


-- sqlcl_snapshot {"hash":"0ba5a1b35f6e473ae25047be13bf86b040c48e0b","type":"COMMENT","name":"acs_role_permissions","schemaName":"dirkspzm32","sxml":""}