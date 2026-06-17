comment on table DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES is 'Configured accesspoint devices used by ACS (Liste von konfiguerierten Zutrittspunkten)';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ACCESS_DEVICE_BUS_ADDRESS" is 'Depends on the device type and hardware configuration the access point can be acessed via a device bus address';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ACCESS_DEVICE_NAME" is 'Technical name of of the device that controls the access handling and user identification';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ACCESS_DEVICE_TCP_HOSTNAME" is 'TCP Hostname of the device to establish the communication with';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ACCESS_DEVICE_TCP_PORT" is 'TCP Port of the device';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ACCESS_DEVICE_TYPE" is 'Type of the device (to load the correct device driver within the ACS service logic)';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ACCESS_POINT_DESCRIPTION" is 'Plain text for a free description of the access point (e.g. special handling etc.)';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ACCESS_POINT_DEVICE_ID" is 'Unique identifier of an access point device configuration (GUID)';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ACCESS_POINT_LOCATION" is 'Plain text to identify the location of the access point (can be used for grouping or filtering)';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ACCESS_POINT_NAME" is 'Plain name of the access point (to be identified by the admin)';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."ENABLED" is 'T=True, the access point is active, F=False, this configuration is not loaded into the ACS service logic)';
comment on column DIRKSPZM32.ACS_ACCESS_POINTS_DEVICES."KEEP_OPEN_SEC" is 'Duration (in seconds) to keep the access point open after a granted access (give people time to pass the access point)';



-- sqlcl_snapshot {"hash":"e163d114aea11ec74ab008d2ca3098aa11a05618","type":"COMMENT","name":"acs_access_points_devices","schemaName":"dirkspzm32","sxml":""}