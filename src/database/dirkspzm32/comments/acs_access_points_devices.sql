comment on table dirkspzm32.acs_access_points_devices is
    'Configured accesspoint devices used by ACS (Liste von konfiguerierten Zutrittspunkten)';

comment on column dirkspzm32.acs_access_points_devices.access_device_bus_address is
    'Depends on the device type and hardware configuration the access point can be acessed via a device bus address';

comment on column dirkspzm32.acs_access_points_devices.access_device_name is
    'Technical name of of the device that controls the access handling and user identification';

comment on column dirkspzm32.acs_access_points_devices.access_device_tcp_hostname is
    'TCP Hostname of the device to establish the communication with';

comment on column dirkspzm32.acs_access_points_devices.access_device_tcp_port is
    'TCP Port of the device';

comment on column dirkspzm32.acs_access_points_devices.access_device_type is
    'Type of the device (to load the correct device driver within the ACS service logic)';

comment on column dirkspzm32.acs_access_points_devices.access_point_description is
    'Plain text for a free description of the access point (e.g. special handling etc.)';

comment on column dirkspzm32.acs_access_points_devices.access_point_device_id is
    'Unique identifier of an access point device configuration (GUID)';

comment on column dirkspzm32.acs_access_points_devices.access_point_location is
    'Plain text to identify the location of the access point (can be used for grouping or filtering)';

comment on column dirkspzm32.acs_access_points_devices.access_point_name is
    'Plain name of the access point (to be identified by the admin)';

comment on column dirkspzm32.acs_access_points_devices.enabled is
    'T=True, the access point is active, F=False, this configuration is not loaded into the ACS service logic)';

comment on column dirkspzm32.acs_access_points_devices.keep_open_sec is
    'Duration (in seconds) to keep the access point open after a granted access (give people time to pass the access point)';


-- sqlcl_snapshot {"hash":"60593e65a2511237034d3749193640a39b55012b","type":"COMMENT","name":"acs_access_points_devices","schemaName":"dirkspzm32","sxml":""}