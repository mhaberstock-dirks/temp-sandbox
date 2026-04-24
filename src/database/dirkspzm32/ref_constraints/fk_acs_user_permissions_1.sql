alter table dirkspzm32.acs_user_permissions
    add constraint fk_acs_user_permissions_1
        foreign key ( access_point_device_id )
            references dirkspzm32.acs_access_points_devices ( access_point_device_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"463d15ba84b961cc031f113c511aac552346374d","type":"REF_CONSTRAINT","name":"FK_ACS_USER_PERMISSIONS_1","schemaName":"DIRKSPZM32","sxml":""}