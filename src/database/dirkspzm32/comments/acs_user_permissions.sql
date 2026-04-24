comment on table dirkspzm32.acs_user_permissions is
    'Users and the related access point devices where they have permission to access';

comment on column dirkspzm32.acs_user_permissions.access_point_device_id is
    'The related access point device to user is granted to pass (GUID)';

comment on column dirkspzm32.acs_user_permissions.expires_at is
    'Expiration date of the grant (of defined, the access is automatically not granted after the date)';

comment on column dirkspzm32.acs_user_permissions.security_level is
    'Number Value between 0 and 3, representing the knowlegde of this role of this access point';

comment on column dirkspzm32.acs_user_permissions.user_id is
    'Unique identifier of the user (from ISI_USER table or any other security system)';


-- sqlcl_snapshot {"hash":"82f3060ff82b8a91eacba723adf3686a34173af1","type":"COMMENT","name":"acs_user_permissions","schemaName":"dirkspzm32","sxml":""}