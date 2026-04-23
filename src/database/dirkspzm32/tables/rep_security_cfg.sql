create table dirkspzm32.rep_security_cfg (
    sid                   varchar2(2 char) not null enable,
    firma_nr              number(6, 0) not null enable,
    rep_security_cfg_id   number(*, 0) not null enable,
    rep_id                number(*, 0) not null enable,
    sec_group_id          number(*, 0),
    login_id              number(*, 0),
    security_type         varchar2(1 char) default 'G' not null enable,
    granted_view_profiles varchar2(2000 char),
    default_view_profile  varchar2(50 char),
    can_edit_data         varchar2(1 char) default 'F' not null enable,
    can_insert_data       varchar2(1 char) default 'F' not null enable,
    can_delete_data       varchar2(1 char) default 'F' not null enable
);

alter table dirkspzm32.rep_security_cfg
    add constraint chk_rep_sec_cfg_st
        check ( security_type in ( 'G', 'U' ) ) enable;

alter table dirkspzm32.rep_security_cfg
    add constraint chk_rep_sec_cfg_stgu
        check ( ( security_type = 'G'
                  and sec_group_id is not null
                  and login_id is null )
                or ( security_type = 'U'
                     and login_id is not null
                     and sec_group_id is null ) ) enable;

alter table dirkspzm32.rep_security_cfg
    add constraint pk_rep_security_cfg
        primary key ( rep_security_cfg_id,
                      rep_id,
                      firma_nr,
                      sid )
            using index enable;

alter table dirkspzm32.rep_security_cfg
    add constraint uk1_rep_security_cfg
        unique ( rep_id,
                 sec_group_id,
                 login_id )
            using index enable;

alter table dirkspzm32.rep_security_cfg
    add constraint uk2_rep_security_cfg
        unique ( rep_id,
                 login_id,
                 sec_group_id )
            using index (
                create unique index dirkspzm32.uk1_rep_security_cfg on
                    dirkspzm32.rep_security_cfg (
                        rep_id,
                        sec_group_id,
                        login_id
                    )
            ) enable;


-- sqlcl_snapshot {"hash":"b0d166125cfbfbc41b8b1f990b8f9c5cd23f6016","type":"TABLE","name":"REP_SECURITY_CFG","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>REP_SECURITY_CFG</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>6</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REP_SECURITY_CFG_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REP_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SEC_GROUP_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SECURITY_TYPE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'G'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GRANTED_VIEW_PROFILES</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2000</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DEFAULT_VIEW_PROFILE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CAN_EDIT_DATA</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CAN_INSERT_DATA</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CAN_DELETE_DATA</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>1</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'F'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_REP_SEC_CFG_STGU</NAME>\n            <CONDITION>(security_type = 'G' and sec_group_id is not null and login_id is null) or (security_type = 'U' and login_id is not null and sec_group_id is null)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>CHK_REP_SEC_CFG_ST</NAME>\n            <CONDITION>security_type in ('G', 'U')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_REP_SECURITY_CFG</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>REP_SECURITY_CFG_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>REP_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>FIRMA_NR</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>UK1_REP_SECURITY_CFG</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>REP_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SEC_GROUP_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>LOGIN_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>UK2_REP_SECURITY_CFG</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>REP_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>LOGIN_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>SEC_GROUP_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX>\n               <INDEX version=\"1.0\">\n                  <UNIQUE></UNIQUE>\n                  <SCHEMA>DIRKSPZM32</SCHEMA>\n                  <NAME>UK1_REP_SECURITY_CFG</NAME>\n                  <TABLE_INDEX>\n                     <ON_TABLE>\n                        <SCHEMA>DIRKSPZM32</SCHEMA>\n                        <NAME>REP_SECURITY_CFG</NAME>\n                     </ON_TABLE>\n                     <COL_LIST>\n                        <COL_LIST_ITEM>\n                           <NAME>REP_ID</NAME>\n                        </COL_LIST_ITEM>\n                        <COL_LIST_ITEM>\n                           <NAME>SEC_GROUP_ID</NAME>\n                        </COL_LIST_ITEM>\n                        <COL_LIST_ITEM>\n                           <NAME>LOGIN_ID</NAME>\n                        </COL_LIST_ITEM>\n                     </COL_LIST>\n                  </TABLE_INDEX>\n               </INDEX>\n            </USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}