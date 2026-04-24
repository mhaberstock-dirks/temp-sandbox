create table dirkspzm32.acs_access_points_devices (
    access_point_device_id     varchar2(32 char) default sys_guid() not null enable,
    access_point_name          varchar2(50 char) not null enable,
    access_point_description   varchar2(1000 char),
    access_point_location      varchar2(255 char),
    access_device_name         varchar2(50 char) not null enable,
    access_device_type         varchar2(50 char) default 'IR1000' not null enable,
    access_device_tcp_hostname varchar2(255 char) not null enable,
    access_device_tcp_port     number(*, 5) default 8000 not null enable,
    access_device_bus_address  number(*, 0) default 255 not null enable,
    keep_open_sec              number(*, 12) default 5 not null enable,
    enabled                    varchar2(1 char) default 'F' not null enable
);

alter table dirkspzm32.acs_access_points_devices
    add constraint chk_access_device_bus_address
        check ( access_device_bus_address is null
                or ( access_device_bus_address >= 0
                     and access_device_bus_address <= 255 ) ) disable;

alter table dirkspzm32.acs_access_points_devices
    add constraint chk_access_device_type
        check ( access_device_type in ( 'IR1000', 'ZKBOX', 'EVO43', 'pure.box' ) ) enable;

alter table dirkspzm32.acs_access_points_devices
    add constraint chk_enabled
        check ( enabled in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.acs_access_points_devices
    add constraint pk_acs_access_points_devices primary key ( access_point_device_id )
        using index enable;

alter table dirkspzm32.acs_access_points_devices add constraint uk_acs_access_points_devices unique ( access_point_name )
    using index enable;

alter table dirkspzm32.acs_access_points_devices
    add constraint uk_acs_devices_bus_address
        unique ( access_device_tcp_hostname,
                 access_device_tcp_port,
                 access_device_bus_address )
            using index enable;


-- sqlcl_snapshot {"hash":"3f0516720495c86cdde13cdf4ca781ed9a541690","type":"TABLE","name":"ACS_ACCESS_POINTS_DEVICES","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ACS_ACCESS_POINTS_DEVICES</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_POINT_DEVICE_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>32</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>sys_guid()</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_POINT_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_POINT_DESCRIPTION</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1000</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_POINT_LOCATION</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_DEVICE_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_DEVICE_TYPE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'IR1000'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_DEVICE_TCP_HOSTNAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_DEVICE_TCP_PORT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>5</SCALE>\n            <DEFAULT>8000</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_DEVICE_BUS_ADDRESS</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <DEFAULT>255</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KEEP_OPEN_SEC</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>12</SCALE>\n            <DEFAULT>5</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ENABLED</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ACCESS_DEVICE_BUS_ADDRESS</NAME>\n            <CONDITION>ACCESS_DEVICE_BUS_ADDRESS is null or (ACCESS_DEVICE_BUS_ADDRESS >= 0 and ACCESS_DEVICE_BUS_ADDRESS &#60;= 255)</CONDITION>\n            <DISABLE></DISABLE>\n            <NOVALIDATE></NOVALIDATE>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ACCESS_DEVICE_TYPE</NAME>\n            <CONDITION>ACCESS_DEVICE_TYPE in ('IR1000', 'ZKBOX', 'EVO43', 'pure.box')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_ENABLED</NAME>\n            <CONDITION>ENABLED in ('T', 'F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_ACS_ACCESS_POINTS_DEVICES</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>ACCESS_POINT_DEVICE_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>UK_ACS_ACCESS_POINTS_DEVICES</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>ACCESS_POINT_NAME</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>UK_ACS_DEVICES_BUS_ADDRESS</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>ACCESS_DEVICE_TCP_HOSTNAME</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>ACCESS_DEVICE_TCP_PORT</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>ACCESS_DEVICE_BUS_ADDRESS</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}