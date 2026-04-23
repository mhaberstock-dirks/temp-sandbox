create table dirkspzm32.bde_pd_schicht_lese_hist (
    schicht_log_id   number(*, 0) not null enable,
    read_by_login_id number(*, 0) not null enable
);

alter table dirkspzm32.bde_pd_schicht_lese_hist
    add constraint pk_bde_schicht_lese_hist primary key ( schicht_log_id,
                                                          read_by_login_id )
        using index enable;


-- sqlcl_snapshot {"hash":"cf4a690c0ba96bd139e5e85c860067b42dd03f09","type":"TABLE","name":"BDE_PD_SCHICHT_LESE_HIST","schemaName":"DIRKSPZM32","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>BDE_PD_SCHICHT_LESE_HIST</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SCHICHT_LOG_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>READ_BY_LOGIN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_BDE_SCHICHT_LESE_HIST</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>SCHICHT_LOG_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>READ_BY_LOGIN_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}