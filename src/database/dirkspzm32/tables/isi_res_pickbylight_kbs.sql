create table dirkspzm32.isi_res_pickbylight_kbs (
    sid              varchar2(2 char) default '01' not null enable,
    firma_nr         number(2, 0) default 1 not null enable,
    controller_id    varchar2(4 char) not null enable,
    controller_ip    varchar2(20 char),
    controller_port  number(5, 0),
    enabled          varchar2(1 char) default 'T',
    device_id        varchar2(4 char) not null enable,
    device_driver    varchar2(40 char) not null enable,
    out_display      varchar2(3 char),
    out_display_mode varchar2(3 char),
    out_led1_red     varchar2(1 char),
    out_led1_green   varchar2(1 char),
    out_led1_blue    varchar2(1 char),
    out_led2_red     varchar2(1 char),
    out_led2_green   varchar2(1 char),
    out_led2_blue    varchar2(1 char),
    out_dp1          varchar2(1 char),
    out_dp2          varchar2(1 char),
    out_changed      date,
    in_changed       date,
    in_data_long     number(3, 0),
    in_key1          varchar2(1 char),
    in_key2          varchar2(1 char),
    in_key3          varchar2(1 char),
    in_key4          varchar2(1 char)
);

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_enabled
        check ( enabled in ( 'T', 'F' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_in_key1
        check ( in_key1 in ( '0', '1' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_in_key2
        check ( in_key2 in ( '0', '1' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_in_key3
        check ( in_key3 in ( '0', '1' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_in_key4
        check ( in_key4 in ( '0', '1' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_out_dp1
        check ( out_dp1 in ( '0', '1', '2', '3' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_out_dp2
        check ( out_dp2 in ( '0', '1', '2', '3' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_out_led1_blue
        check ( out_led1_blue in ( '0', '1', '2', '3' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_out_led1_green
        check ( out_led1_green in ( '0', '1', '2', '3' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_out_led1_red
        check ( out_led1_red in ( '0', '1', '2', '3' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_out_led2_blue
        check ( out_led2_blue in ( '0', '1', '2', '3' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_out_led2_green
        check ( out_led2_green in ( '0', '1', '2', '3' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint isi_res_pbl_kbs_out_led2_red
        check ( out_led2_red in ( '0', '1', '2', '3' ) ) enable;

alter table dirkspzm32.isi_res_pickbylight_kbs
    add constraint pk_isi_res_pickbylight_kbs
        primary key ( device_id,
                      firma_nr,
                      sid )
            using index enable;


-- sqlcl_snapshot {"hash":"4be2e4d7d0d4303e47c6ec2758dad047f10839bd","type":"TABLE","name":"ISI_RES_PICKBYLIGHT_KBS","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_RES_PICKBYLIGHT_KBS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'01'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>2</PRECISION>\n            <SCALE>0</SCALE>\n            <DEFAULT>1</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CONTROLLER_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>4</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CONTROLLER_IP</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CONTROLLER_PORT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>5</PRECISION>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ENABLED</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'T'</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DEVICE_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>4</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DEVICE_DRIVER</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>40</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_DISPLAY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>3</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_DISPLAY_MODE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>3</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_LED1_RED</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_LED1_GREEN</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_LED1_BLUE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_LED2_RED</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_LED2_GREEN</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_LED2_BLUE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_DP1</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_DP2</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>OUT_CHANGED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IN_CHANGED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IN_DATA_LONG</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>3</PRECISION>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IN_KEY1</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IN_KEY2</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IN_KEY3</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IN_KEY4</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_ENABLED</NAME>\n            <CONDITION>ENABLED in ('T', 'F')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_IN_KEY1</NAME>\n            <CONDITION>IN_KEY1 in ('0', '1')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_IN_KEY2</NAME>\n            <CONDITION>IN_KEY2 in ('0', '1')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_IN_KEY3</NAME>\n            <CONDITION>IN_KEY3 in ('0', '1')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_IN_KEY4</NAME>\n            <CONDITION>IN_KEY4 in ('0', '1')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_OUT_DP1</NAME>\n            <CONDITION>OUT_DP1 in ('0', '1', '2', '3')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_OUT_DP2</NAME>\n            <CONDITION>OUT_DP2 in ('0', '1', '2', '3')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_OUT_LED1_BLUE</NAME>\n            <CONDITION>OUT_LED1_BLUE in ('0', '1', '2', '3')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_OUT_LED1_GREEN</NAME>\n            <CONDITION>OUT_LED1_GREEN in ('0', '1', '2', '3')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_OUT_LED1_RED</NAME>\n            <CONDITION>OUT_LED1_RED in ('0', '1', '2', '3')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_OUT_LED2_BLUE</NAME>\n            <CONDITION>OUT_LED2_BLUE in ('0', '1', '2', '3')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_OUT_LED2_GREEN</NAME>\n            <CONDITION>OUT_LED2_GREEN in ('0', '1', '2', '3')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>ISI_RES_PBL_KBS_OUT_LED2_RED</NAME>\n            <CONDITION>OUT_LED2_RED in ('0', '1', '2', '3')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_ISI_RES_PICKBYLIGHT_KBS</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>DEVICE_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}